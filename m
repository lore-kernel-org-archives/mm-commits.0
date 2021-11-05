Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70DBC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C786127C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhKEUoR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhKEUoR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 608FC61262;
        Fri,  5 Nov 2021 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144897;
        bh=+EIMaYi6ms3T0TFdzwjLTv7AeIMRwHSwaaCVCc5YJac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GKXpojr8O1lasW3573w4Vjd2rClXubWsH6JzF+gBiTPYU6ldEdvXOCU5CHeBbpZdj
         MslLTb7Uo7l52Jsqu9HSWSYiOoWaJ1LVI4Myc3UqJv1+hgNbT5TgIT0K4WbpI/YGzl
         mmDBTZeu5ryPVXpP50M2RCHxLjOimtFe8cmEW12o=
Date:   Fri, 05 Nov 2021 13:41:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liangcaifan19@gmail.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhang.lyra@gmail.com
Subject:  [patch 133/262] mm: khugepaged: recalculate
 min_free_kbytes after stopping khugepaged
Message-ID: <20211105204136.NtGWXjIhw%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
