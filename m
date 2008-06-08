From: akpm@linux-foundation.org
Subject: + bootmem-revisit-bootmem-descriptor-list-handling.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:23 -0700
Message-ID: <200806082335.m58NZN8T025607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321AbYFHXg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     bootmem: revisit bootmem descriptor list handling
has been added to the -mm tree.  Its filename is
     bootmem-revisit-bootmem-descriptor-list-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: revisit bootmem descriptor list handling
From: Johannes Weiner <hannes@saeurebad.de>

link_bootmem handles an insertion of a new descriptor into the sorted list
in more or less three explicit branches; empty list, insert in between and
append.  These cases can be expressed implicite.

Also mark the sorted list as initdata as it can be thrown away after boot
as well.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/bootmem.c~bootmem-revisit-bootmem-descriptor-list-handling mm/bootmem.c
--- a/mm/bootmem.c~bootmem-revisit-bootmem-descriptor-list-handling
+++ a/mm/bootmem.c
@@ -23,7 +23,6 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-static LIST_HEAD(bdata_list);
 #ifdef CONFIG_CRASH_DUMP
 /*
  * If we have booted due to a crash, max_pfn will be a very low value. We need
@@ -34,6 +33,8 @@ unsigned long saved_max_pfn;
 
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
+static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
+
 static int bootmem_debug;
 
 static int __init bootmem_debug_setup(char *buf)
@@ -73,20 +74,16 @@ unsigned long __init bootmem_bootmap_pag
  */
 static void __init link_bootmem(bootmem_data_t *bdata)
 {
-	bootmem_data_t *ent;
+	struct list_head *iter;
 
-	if (list_empty(&bdata_list)) {
-		list_add(&bdata->list, &bdata_list);
-		return;
-	}
-	/* insert in order */
-	list_for_each_entry(ent, &bdata_list, list) {
-		if (bdata->node_boot_start < ent->node_boot_start) {
-			list_add_tail(&bdata->list, &ent->list);
-			return;
-		}
+	list_for_each(iter, &bdata_list) {
+		bootmem_data_t *ent;
+
+		ent = list_entry(iter, bootmem_data_t, list);
+		if (bdata->node_boot_start < ent->node_boot_start)
+			break;
 	}
-	list_add_tail(&bdata->list, &bdata_list);
+	list_add_tail(&bdata->list, iter);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

