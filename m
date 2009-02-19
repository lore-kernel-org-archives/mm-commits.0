From: akpm@linux-foundation.org
Subject: [merged] vmalloc-add-__get_vm_area_caller.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:16 -0800
Message-ID: <200902191916.n1JJGHtm016241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZBSTQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmalloc: add __get_vm_area_caller()
has been removed from the -mm tree.  Its filename was
     vmalloc-add-__get_vm_area_caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: add __get_vm_area_caller()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

We have get_vm_area_caller() and __get_vm_area() but not
__get_vm_area_caller()

On powerpc, I use __get_vm_area() to separate the ranges of addresses
given to vmalloc vs.  ioremap (various good reasons for that) so in order
to be able to implement the new caller tracking in /proc/vmallocinfo, I
need a "_caller" variant of it.

(akpm: needed for ongoing powerpc development, so merge it early)

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++++
 mm/vmalloc.c            |    8 ++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/vmalloc.h~vmalloc-add-__get_vm_area_caller include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-add-__get_vm_area_caller
+++ a/include/linux/vmalloc.h
@@ -84,6 +84,10 @@ extern struct vm_struct *get_vm_area_cal
 					unsigned long flags, void *caller);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
+extern struct vm_struct *__get_vm_area_caller(unsigned long size,
+					unsigned long flags,
+					unsigned long start, unsigned long end,
+					void *caller);
 extern struct vm_struct *get_vm_area_node(unsigned long size,
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
diff -puN mm/vmalloc.c~vmalloc-add-__get_vm_area_caller mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-add-__get_vm_area_caller
+++ a/mm/vmalloc.c
@@ -1106,6 +1106,14 @@ struct vm_struct *__get_vm_area(unsigned
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
 
+struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
+				       unsigned long start, unsigned long end,
+				       void *caller)
+{
+	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+				  caller);
+}
+
 /**
  *	get_vm_area  -  reserve a contiguous kernel virtual area
  *	@size:		size of the area
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch
atyfb-fix-header-file-trailing-whitespace.patch
edac-new-ppc4xx-driver-module.patch
edac-new-ppc4xx-driver-module-update.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch

