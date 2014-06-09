From: akpm@linux-foundation.org
Subject: [merged]
 mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:39:53 -0700
Message-ID: <53960d89.LcmSfDmMKepff68x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaFITjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:53 -0700


The patch titled
     Subject: mm: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 mm/page_alloc.c     |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/page-writeback.c~mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table mm/page-writeback.c
--- a/mm/page-writeback.c~mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/mm/page-writeback.c
@@ -1664,7 +1664,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
-int dirty_writeback_centisecs_handler(ctl_table *table, int write,
+int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
diff -puN mm/page_alloc.c~mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table mm/page_alloc.c
--- a/mm/page_alloc.c~mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/mm/page_alloc.c
@@ -3389,7 +3389,7 @@ early_param("numa_zonelist_order", setup
 /*
  * sysctl handler for numa_zonelist_order
  */
-int numa_zonelist_order_handler(ctl_table *table, int write,
+int numa_zonelist_order_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos)
 {
@@ -5805,7 +5805,7 @@ module_init(init_per_zone_wmark_min)
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
+int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5822,7 +5822,7 @@ int min_free_kbytes_sysctl_handler(ctl_t
 }
 
 #ifdef CONFIG_NUMA
-int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5838,7 +5838,7 @@ int sysctl_min_unmapped_ratio_sysctl_han
 	return 0;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
+int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -5864,7 +5864,7 @@ int sysctl_min_slab_ratio_sysctl_handler
  * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
-int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
+int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec_minmax(table, write, buffer, length, ppos);
@@ -5877,7 +5877,7 @@ int lowmem_reserve_ratio_sysctl_handler(
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu
  * pagelist can have before it gets flushed back to buddy allocator.
  */
-int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
+int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

