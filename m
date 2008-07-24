From: akpm@linux-foundation.org
Subject: - bootmem-revisit-bootmem-descriptor-list-handling.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:56 -0700
Message-ID: <200807242323.m6ONNurv010730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYGXXYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem: revisit bootmem descriptor list handling
has been removed from the -mm tree.  Its filename was
     bootmem-revisit-bootmem-descriptor-list-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

