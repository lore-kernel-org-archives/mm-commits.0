From: akpm@linux-foundation.org
Subject: + pci-dmar-add-__init-annotation-to-dmar_ir_support.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:55:52 -0700
Message-ID: <200910162155.n9GLtq3T012798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbZJPV4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bebarino@gmail.com, David.Woodhouse@intel.com, jbarnes@virtuousgeek.org


The patch titled
     pci/dmar: add __init annotation to dmar_ir_support()
has been added to the -mm tree.  Its filename is
     pci-dmar-add-__init-annotation-to-dmar_ir_support.patch

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
Subject: pci/dmar: add __init annotation to dmar_ir_support()
From: Stephen Boyd <bebarino@gmail.com>

dmar_ir_support() references dmar_tbl which is annotated with
__initdata. The only caller of dmar_ir_support() is
intr_remapping_supported() also annotated with __init.

WARNING: drivers/pci/built-in.o(.text+0xa110): Section mismatch in
reference from the function dmar_ir_support() to the variable
.init.data:dmar_tbl
The function dmar_ir_support() references
the variable __initdata dmar_tbl.
This is often because dmar_ir_support lacks a __initdata
annotation or the annotation of dmar_tbl is wrong.

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pci/dmar.c~pci-dmar-add-__init-annotation-to-dmar_ir_support drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~pci-dmar-add-__init-annotation-to-dmar_ir_support
+++ a/drivers/pci/dmar.c
@@ -1375,7 +1375,7 @@ int dmar_reenable_qi(struct intel_iommu 
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
_

Patches currently in -mm which might be from bebarino@gmail.com are

pci-dmar-add-__init-annotation-to-dmar_ir_support.patch

