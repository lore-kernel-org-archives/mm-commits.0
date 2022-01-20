Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46675C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347854AbiATV2D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347843AbiATV2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB225C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55F8B60A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0363C340E0;
        Thu, 20 Jan 2022 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714081;
        bh=s9yQnZt1PxC28G9vkQZ/rN0WUc1FlIsidUUYF6iawYI=;
        h=Date:From:To:Subject:From;
        b=WSznwR/m1aO9TVAEXS9K75nudBEak4XBf94S4oOArV1ATFlgCBpxRiipiIs80MoyZ
         mJ455UZuSONk6NzYFTtdFRVDQMhuLorH9/2jnRV1tsNkPm9x1meAw/v+XsOioX8Cym
         yqydJ3Fld4jKjEfbM7FBo8ksRBPpj3jpHb/0ZwJ0=
Date:   Thu, 20 Jan 2022 13:28:01 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, mm-commits@vger.kernel.org,
        zackary.liu.pro@gmail.com
Subject:  [merged] zpool-remove-the-list-of-pools_head.patch
 removed from -mm tree
Message-ID: <20220120212801.FC8rRUc6F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove the list of pools_head
has been removed from the -mm tree.  Its filename was
     zpool-remove-the-list-of-pools_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


