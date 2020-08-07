Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A27EC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FF922CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781530;
	bh=if0fmXdcSlH3PBaSbxnm+/cw3O536ZSZiFYOFINENVo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FaESidEO/WtYjsA/I38hHyrKLkHtJibqO8n8jD7IJHgPapxnFZ222OtVzJPYuyNDl
	 f9XD1woJDNF53+qvJPn3GMkf+pzP7rIhTi1EQz971JoJZUkK/NUdSh+PdO7XIMBkg0
	 /tmzYgbPtolZ/c2dXDC4icryMBnqeO73LO6Ah+88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1FCD22CAE;
        Fri,  7 Aug 2020 06:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781528;
        bh=if0fmXdcSlH3PBaSbxnm+/cw3O536ZSZiFYOFINENVo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=N9dDXq/3lZu75CpjrELEQjsEGp/5sWeT0QBT4oN8upBybeww7+UDjpCSlWrce1gDB
         gZ9TONAbJhbIgdPErQ6f3n1VD2Z6LGMxzzSwCDsN6LIwcZojfS8boQW0k3wkZDUWTP
         XQC6w1NIWG8u6frbXio0S2klqEjGHHuUEs5erNl0=
Date:   Thu, 06 Aug 2020 23:25:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        richard.weiyang@gmail.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, ying.huang@intel.com
Subject:  [patch 144/163] mm: remove vm_total_pages
Message-ID: <20200807062527.kGCv_ARgH%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: remove vm_total_pages

The global variable "vm_total_pages" is a relic from older days.  There is
only a single user that reads the variable - build_all_zonelists() - and
the first thing it does is update it.

Use a local variable in build_all_zonelists() instead and remove the
global variable.

Link: http://lkml.kernel.org/r/20200619132410.23859-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/memory_hotplug.c  |    3 ---
 mm/page-writeback.c  |    6 ++----
 mm/page_alloc.c      |    2 ++
 mm/vmscan.c          |    5 -----
 5 files changed, 4 insertions(+), 13 deletions(-)

--- a/include/linux/swap.h~mm-drop-vm_total_pages
+++ a/include/linux/swap.h
@@ -372,7 +372,6 @@ extern unsigned long mem_cgroup_shrink_n
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
-extern unsigned long vm_total_pages;
 
 extern unsigned long reclaim_pages(struct list_head *page_list);
 #ifdef CONFIG_NUMA
--- a/mm/memory_hotplug.c~mm-drop-vm_total_pages
+++ a/mm/memory_hotplug.c
@@ -844,8 +844,6 @@ int __ref online_pages(unsigned long pfn
 	kswapd_run(nid);
 	kcompactd_run(nid);
 
-	vm_total_pages = nr_free_pagecache_pages();
-
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_ONLINE, &arg);
@@ -1595,7 +1593,6 @@ static int __ref __offline_pages(unsigne
 		kcompactd_stop(node);
 	}
 
-	vm_total_pages = nr_free_pagecache_pages();
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
--- a/mm/page_alloc.c~mm-drop-vm_total_pages
+++ a/mm/page_alloc.c
@@ -5912,6 +5912,8 @@ build_all_zonelists_init(void)
  */
 void __ref build_all_zonelists(pg_data_t *pgdat)
 {
+	unsigned long vm_total_pages;
+
 	if (system_state == SYSTEM_BOOTING) {
 		build_all_zonelists_init();
 	} else {
--- a/mm/page-writeback.c~mm-drop-vm_total_pages
+++ a/mm/page-writeback.c
@@ -2076,13 +2076,11 @@ static int page_writeback_cpu_online(uns
  * Called early on to tune the page writeback dirty limits.
  *
  * We used to scale dirty pages according to how total memory
- * related to pages that could be allocated for buffers (by
- * comparing nr_free_buffer_pages() to vm_total_pages.
+ * related to pages that could be allocated for buffers.
  *
  * However, that was when we used "dirty_ratio" to scale with
  * all memory, and we don't do that any more. "dirty_ratio"
- * is now applied to total non-HIGHPAGE memory (by subtracting
- * totalhigh_pages from vm_total_pages), and as such we can't
+ * is now applied to total non-HIGHPAGE memory, and as such we can't
  * get into the old insane situation any more where we had
  * large amounts of dirty pages compared to a small amount of
  * non-HIGHMEM memory.
--- a/mm/vmscan.c~mm-drop-vm_total_pages
+++ a/mm/vmscan.c
@@ -170,11 +170,6 @@ struct scan_control {
  * From 0 .. 200.  Higher means more swappy.
  */
 int vm_swappiness = 60;
-/*
- * The total number of pages which are beyond the high watermark within all
- * zones.
- */
-unsigned long vm_total_pages;
 
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
_
