Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD33C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiANWJZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81131C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1EDFCE2498
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB73C36AE5;
        Fri, 14 Jan 2022 22:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198160;
        bh=poGYbaTX2+cz0z8Cnf73X/eJ76wvLpRwgchPkO/xz4E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fDR4ILereFpWIKbK7kzBNxzTW7WB+g1fKCTWc1Z/CpNSvjRkZqz+BYV3TqogYK4kC
         lRse9StUh8G4wGKgIOyrCjWPzsmPtrLkaJMIyXb/v0Y51gW0vOknIdJXzGEJUndjPy
         Ih60yHwlasQ2Qgx5NfC9pIUfCHYBCKaT3UWIat7Y=
Date:   Fri, 14 Jan 2022 14:09:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zackary.liu.pro@gmail.com
Subject:  [patch 116/146] zpool: remove the list of pools_head
Message-ID: <20220114220919.syBRmxBpv%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
