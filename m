From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-make-init_pages_in_zone-faster-fix2.patch removed from -mm
 tree
Date: Wed, 06 Sep 2017 16:01:15 -0700
Message-ID: <59b07e3b.z8iRuT8bRbZUqU+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdIFXBQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-make-init_pages_in_zone-faster-fix2
has been removed from the -mm tree.  Its filename was
     mm-page_owner-make-init_pages_in_zone-faster-fix2.patch

This patch was dropped because it was folded into mm-page_owner-make-init_pages_in_zone-faster.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_owner-make-init_pages_in_zone-faster-fix2

Create statically allocated fake stack trace for early allocated pages, per
Michal Hocko.

Link: http://lkml.kernel.org/r/45813564-2342-fc8d-d31a-f4b68a724325@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix2 mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix2
+++ a/mm/page_owner.c
@@ -30,6 +30,7 @@ DEFINE_STATIC_KEY_FALSE(page_owner_inite
 
 static depot_stack_handle_t dummy_handle;
 static depot_stack_handle_t failure_handle;
+static depot_stack_handle_t early_handle;
 
 static void init_early_allocated_pages(void);
 
@@ -53,7 +54,7 @@ static bool need_page_owner(void)
 	return true;
 }
 
-static noinline void register_dummy_stack(void)
+static __always_inline depot_stack_handle_t create_dummy_stack(void)
 {
 	unsigned long entries[4];
 	struct stack_trace dummy;
@@ -64,21 +65,22 @@ static noinline void register_dummy_stac
 	dummy.skip = 0;
 
 	save_stack_trace(&dummy);
-	dummy_handle = depot_save_stack(&dummy, GFP_KERNEL);
+	return depot_save_stack(&dummy, GFP_KERNEL);
 }
 
-static noinline void register_failure_stack(void)
+static noinline void register_dummy_stack(void)
 {
-	unsigned long entries[4];
-	struct stack_trace failure;
+	dummy_handle = create_dummy_stack();
+}
 
-	failure.nr_entries = 0;
-	failure.max_entries = ARRAY_SIZE(entries);
-	failure.entries = &entries[0];
-	failure.skip = 0;
+static noinline void register_failure_stack(void)
+{
+	failure_handle = create_dummy_stack();
+}
 
-	save_stack_trace(&failure);
-	failure_handle = depot_save_stack(&failure, GFP_KERNEL);
+static noinline void register_early_stack(void)
+{
+	early_handle = create_dummy_stack();
 }
 
 static void init_page_owner(void)
@@ -88,6 +90,7 @@ static void init_page_owner(void)
 
 	register_dummy_stack();
 	register_failure_stack();
+	register_early_stack();
 	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
 }
@@ -529,13 +532,10 @@ static void init_pages_in_zone(pg_data_t
 	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
 	unsigned long end_pfn = pfn + zone->spanned_pages;
 	unsigned long count = 0;
-	depot_stack_handle_t init_handle;
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = zone->zone_start_pfn;
 
-	init_handle = save_stack(0);
