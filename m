Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28A1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59DE6146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhGABB0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGABB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FEF1610A7;
        Thu,  1 Jul 2021 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101136;
        bh=DEHKwgWtNXX1BsSbHaLtPmKKCmmy31DDTajw1BvAGFY=;
        h=Date:From:To:Subject:From;
        b=Xxlx0Gl3k26kNMtKcFlmNpK/Qp6QIMpX03KOHqmoy2fwRhVHGJsjaZ0iGdKe10m+w
         2xEdZ4Fnt/7QZH6RgQ3rj/0b0QJQwSngqrC8IW/rKwrnpP9zKxrk+FP7bU5gIo+Zkj
         t6XF2raA1STQh9aH1qlwTcSyRK/79bd5kKzMqi2E=
Date:   Wed, 30 Jun 2021 17:58:56 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [folded-merged]
 mmmemory_hotplug-drop-unneeded-locking-fix.patch removed from -mm tree
Message-ID: <20210701005856.QawUhlNzX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmmemory_hotplug-drop-unneeded-locking-fix
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-drop-unneeded-locking-fix.patch

This patch was dropped because it was folded into mmmemory_hotplug-drop-unneeded-locking.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmmemory_hotplug-drop-unneeded-locking-fix

remove now-unused locals

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-unneeded-locking-fix
+++ a/mm/memory_hotplug.c
@@ -397,7 +397,7 @@ void __ref remove_pfn_range_from_zone(st
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	unsigned long pfn, cur_nr_pages, flags;
+	unsigned long pfn, cur_nr_pages;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -630,7 +630,6 @@ void __ref move_pfn_range_to_zone(struct
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-	unsigned long flags;
 
 	clear_zone_contiguous(zone);
 
@@ -727,8 +726,6 @@ struct zone *zone_for_pfn_range(int onli
  */
 void adjust_present_page_count(struct zone *zone, long nr_pages)
 {
-	unsigned long flags;
-
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmmemory_hotplug-drop-unneeded-locking.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

