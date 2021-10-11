Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C136C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 22:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7370660F22
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJKW47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Oct 2021 18:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhJKW46 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Oct 2021 18:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE44960F3A;
        Mon, 11 Oct 2021 22:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633992897;
        bh=IYft3san32/y2cuuJezw0CM1fs1OzTHbLySopcoRv08=;
        h=Date:From:To:Subject:From;
        b=BVK/km3/4kxgv/GB8HND0HTqIVngwJa2tgSK0n0pzfABHybFGxAH6z9e3h498uFgj
         EXJ0O5f/omnpX4kNmw/8VN9UlFgVDye/HNDKbC9sjd02GG8Hp9Z/JfOnVyvUilS5BF
         Bufn/zSQC8B1gxE4DcLrCmQJ6pmTVR8oChnr48vU=
Date:   Mon, 11 Oct 2021 15:54:57 -0700
From:   akpm@linux-foundation.org
To:     liangcaifan19@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, zhang.lyra@gmail.com
Subject:  +
 mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch
 added to -mm tree
Message-ID: <20211011225457.kLPNOS88m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: Recalculate min_free_kbytes after stopping khugepaged
has been added to the -mm tree.  Its filename is
     mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liangcai Fan <liangcaifan19@gmail.com>
Subject: mm: khugepaged: Recalculate min_free_kbytes after stopping khugepaged

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
@@ -2291,6 +2291,11 @@ static void set_recommended_min_free_kby
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
@@ -2326,6 +2331,8 @@ static void set_recommended_min_free_kby
 
 		min_free_kbytes = recommended_min;
 	}
+
+update_wmarks:
 	setup_per_zone_wmarks();
 }
 
@@ -2347,12 +2354,11 @@ int start_stop_khugepaged(void)
 
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
@@ -8463,7 +8463,7 @@ void setup_per_zone_wmarks(void)
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-int __meminit init_per_zone_wmark_min(void)
+void calculate_min_free_kbytes(void)
 {
 	unsigned long lowmem_kbytes;
 	int new_min_free_kbytes;
@@ -8481,6 +8481,11 @@ int __meminit init_per_zone_wmark_min(vo
 		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
 				new_min_free_kbytes, user_min_free_kbytes);
 	}
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

mm-show-watermark_boost-of-zone-in-zoneinfo.patch
mm-khugepaged-recalculate-min_free_kbytes-after-stopping-khugepaged.patch

