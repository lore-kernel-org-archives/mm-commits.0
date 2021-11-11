Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15103C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7CCA61247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhKKCrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhKKCrv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A258B61108;
        Thu, 11 Nov 2021 02:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598702;
        bh=kf4/N5xxneQEQ6fc38nlGFXp9Qqf7rogbQaDGkUIDjc=;
        h=Date:From:To:Subject:From;
        b=cRfOTMXIxz8CVEqrYjninV3XGNdM5aD8ic4U6AqOmfTrcF09E/mf502SxID/b8iLJ
         Fbut51o87Hfa3kwTmc09QuUntbuFGy3R+VJ0Phbuz464gU21q2aqz8caAOV2ilkl7X
         p4/lJUcKISKQIF/9yq8E3YtPrXL1qjSA3LvLGEl8=
Date:   Wed, 10 Nov 2021 18:45:02 -0800
From:   akpm@linux-foundation.org
To:     liangcaifan19@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, zhang.lyra@gmail.com
Subject:  [merged]
 mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch
 removed from -mm tree
Message-ID: <20211111024502.teq65BKjH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: recalculate min_free_kbytes after stopping khugepaged
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liangcai Fan <liangcaifan19@gmail.com>
Subject: mm: khugepaged: recalculate min_free_kbytes after stopping khugepaged

When initializing transparent huge pages, min_free_kbytes would be
calculated according to what khugepaged expected.
So when disable transparent huge pages, min_free_kbytes should be
recalculated instead of the higher value set by khugepaged.

Link: https://lkml.kernel.org/r/1633937809-16558-1-git-send-email-liangcaifan19@gmail.com
Signed-off-by: Liangcai Fan <liangcaifan19@gmail.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/khugepaged.c    |   10 ++++++++--
 mm/page_alloc.c    |    7 ++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged
+++ a/include/linux/mm.h
@@ -2453,6 +2453,7 @@ extern void memmap_init_range(unsigned l
 		unsigned long, unsigned long, enum meminit_context,
 		struct vmem_altmap *, int migratetype);
 extern void setup_per_zone_wmarks(void);
+extern void calculate_min_free_kbytes(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
--- a/mm/khugepaged.c~mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged
+++ a/mm/khugepaged.c
@@ -2299,6 +2299,11 @@ static void set_recommended_min_free_kby
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
+	if (!khugepaged_enabled()) {
+		calculate_min_free_kbytes();
+		goto update_wmarks;
+	}
+
 	for_each_populated_zone(zone) {
 		/*
 		 * We don't need to worry about fragmentation of
@@ -2334,6 +2339,8 @@ static void set_recommended_min_free_kby
 
 		min_free_kbytes = recommended_min;
 	}
+
+update_wmarks:
 	setup_per_zone_wmarks();
 }
 
@@ -2355,12 +2362,11 @@ int start_stop_khugepaged(void)
 
 		if (!list_empty(&khugepaged_scan.mm_head))
 			wake_up_interruptible(&khugepaged_wait);
-
-		set_recommended_min_free_kbytes();
 	} else if (khugepaged_thread) {
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
+	set_recommended_min_free_kbytes();
 fail:
 	mutex_unlock(&khugepaged_mutex);
 	return err;
--- a/mm/page_alloc.c~mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged
+++ a/mm/page_alloc.c
@@ -8469,7 +8469,7 @@ void setup_per_zone_wmarks(void)
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-int __meminit init_per_zone_wmark_min(void)
+void calculate_min_free_kbytes(void)
 {
 	unsigned long lowmem_kbytes;
 	int new_min_free_kbytes;
@@ -8483,6 +8483,11 @@ int __meminit init_per_zone_wmark_min(vo
 		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
 				new_min_free_kbytes, user_min_free_kbytes);
 
+}
+
+int __meminit init_per_zone_wmark_min(void)
+{
+	calculate_min_free_kbytes();
 	setup_per_zone_wmarks();
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
_

Patches currently in -mm which might be from liangcaifan19@gmail.com are


