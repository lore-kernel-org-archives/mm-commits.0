Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4571C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhLPWQj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:16:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53262 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhLPWQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:16:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 085B9B8258A
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A1BC36AE2;
        Thu, 16 Dec 2021 22:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639692996;
        bh=FqpA6vV++0aDUc/2qodywczXi3GPLVwHSnlq0zFpPgc=;
        h=Date:From:To:Subject:From;
        b=puM4hoDhm50frawnfe9k0gSEpIVaWq0DlY07VRWx260a4QDXKS7EcXM44S0cnOMIo
         h//n0dsFffzwYOhaTqIhKRK/eAgKfnc5/ZmXKBvgxzrX/TjDo5rexN0gXBX8+NT9vi
         AWbzJICVmKd42X1bYBeaUBxkBmeSA2WrWOauwWCQ=
Date:   Thu, 16 Dec 2021 14:16:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ddstreet@ieee.org,
        zackary.liu.pro@gmail.com
Subject:  + zpool-remove-the-list-of-pools_head.patch added to -mm
 tree
Message-ID: <20211216221636._VgCq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove the list of pools_head
has been added to the -mm tree.  Its filename is
     zpool-remove-the-list-of-pools_head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zpool-remove-the-list-of-pools_head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zpool-remove-the-list-of-pools_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhaoyu Liu <zackary.liu.pro@gmail.com>
Subject: zpool: remove the list of pools_head

The list of pools_head is no longer needed because the caller has been
deleted in commit 479305fd7172 ("zpool: remove zpool_evict()").

Link: https://lkml.kernel.org/r/20211215163727.GA17196@pc
Signed-off-by: Zhaoyu Liu <zackary.liu.pro@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/zpool.c~zpool-remove-the-list-of-pools_head
+++ a/mm/zpool.c
@@ -24,16 +24,11 @@ struct zpool {
 	const struct zpool_ops *ops;
 	bool evictable;
 	bool can_sleep_mapped;
-
-	struct list_head list;
 };
 
 static LIST_HEAD(drivers_head);
 static DEFINE_SPINLOCK(drivers_lock);
 
-static LIST_HEAD(pools_head);
-static DEFINE_SPINLOCK(pools_lock);
-
 /**
  * zpool_register_driver() - register a zpool implementation.
  * @driver:	driver to register
@@ -195,10 +190,6 @@ struct zpool *zpool_create_pool(const ch
 
 	pr_debug("created pool type %s\n", type);
 
-	spin_lock(&pools_lock);
-	list_add(&zpool->list, &pools_head);
-	spin_unlock(&pools_lock);
-
 	return zpool;
 }
 
@@ -217,9 +208,6 @@ void zpool_destroy_pool(struct zpool *zp
 {
 	pr_debug("destroying pool type %s\n", zpool->driver->type);
 
-	spin_lock(&pools_lock);
-	list_del(&zpool->list);
-	spin_unlock(&pools_lock);
 	zpool->driver->destroy(zpool->pool);
 	zpool_put_driver(zpool->driver);
 	kfree(zpool);
_

Patches currently in -mm which might be from zackary.liu.pro@gmail.com are

zpool-remove-the-list-of-pools_head.patch

