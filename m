From: akpm@linux-foundation.org
Subject: + vmalloc-add-__get_vm_area_caller.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:43:48 -0800
Message-ID: <200902112243.n1BMhmg8008736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZBKWoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmalloc: add __get_vm_area_caller()
has been added to the -mm tree.  Its filename is
     vmalloc-add-__get_vm_area_caller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 +++
 mm/vmalloc.c            |    8 ++++++++
 2 files changed, 11 insertions(+)

diff -puN include/linux/vmalloc.h~vmalloc-add-__get_vm_area_caller include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-add-__get_vm_area_caller
+++ a/include/linux/vmalloc.h
@@ -84,6 +84,9 @@ extern struct vm_struct *get_vm_area_cal
 					unsigned long flags, void *caller);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
+extern struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
+					      unsigned long start, unsigned long end,
+					      void *caller);
 extern struct vm_struct *get_vm_area_node(unsigned long size,
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
diff -puN mm/vmalloc.c~vmalloc-add-__get_vm_area_caller mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-add-__get_vm_area_caller
+++ a/mm/vmalloc.c
@@ -1107,6 +1107,14 @@ struct vm_struct *__get_vm_area(unsigned
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
vmalloc-add-__get_vm_area_caller.patch
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

