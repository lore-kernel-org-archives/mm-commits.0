Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C91FC3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbiG3BJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30F187374
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DF3761B04
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE7C433C1;
        Sat, 30 Jul 2022 01:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143326;
        bh=4WFD96mIeWxigcQCtngp6XwWhucYCm8F7Rc8g0KQxT4=;
        h=Date:To:From:Subject:From;
        b=LCtVsgdOSv5Q5XwEEoCxwwXMxlYEMgFgadJXzF1jl2XRtLTgU9LFneXFOaBf1QsNL
         n7Sb4UKm/IY0seX/tnjtsDXKRCO6ESoUFqrkCr3wLJ+ajYaZbT5JQi9acCu1WMJ/cF
         ko2PvVdXKlGZZBB+qUesfjqOLxrsTGskwNmmuOi4=
Date:   Fri, 29 Jul 2022 18:08:45 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-is_highmem.patch removed from -mm tree
Message-Id: <20220730010845.DBFE7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: cleanup is_highmem()
has been removed from the -mm tree.  Its filename was
     mm-cleanup-is_highmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: cleanup is_highmem()
Date: Tue, 26 Jul 2022 21:18:16 +0800

It is unnecessary to add CONFIG_HIGHMEM check in is_highmem(), which has
been done in is_highmem_idx(), and move is_highmem() close to
is_highmem_idx().  This has no functional impact.

Link: https://lkml.kernel.org/r/20220726131816.149075-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/include/linux/mmzone.h~mm-cleanup-is_highmem
+++ a/include/linux/mmzone.h
@@ -1137,15 +1137,6 @@ static inline int is_highmem_idx(enum zo
 #endif
 }
 
-#ifdef CONFIG_ZONE_DMA
-bool has_managed_dma(void);
-#else
-static inline bool has_managed_dma(void)
-{
-	return false;
-}
-#endif
-
 /**
  * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
@@ -1155,12 +1146,17 @@ static inline bool has_managed_dma(void)
  */
 static inline int is_highmem(struct zone *zone)
 {
-#ifdef CONFIG_HIGHMEM
 	return is_highmem_idx(zone_idx(zone));
+}
+
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void);
 #else
-	return 0;
-#endif
+static inline bool has_managed_dma(void)
+{
+	return false;
 }
+#endif
 
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


