From: akpm@linux-foundation.org
Subject: + x86-paravirt-revert-exports-to-restore-old-behaviour.patch added to -mm tree
Date: Tue, 27 Nov 2007 15:38:55 -0800
Message-ID: <200711272338.lARNctNs005417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbXK0XjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 18:39:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Jeremy.Fitzhardinge@citrix.com, hch@infradead.org, t.powa@gmx.de, tiwai@suse.de, zach@vmware.com


The patch titled
     x86/paravirt: revert exports to restore old behaviour
has been added to the -mm tree.  Its filename is
     x86-paravirt-revert-exports-to-restore-old-behaviour.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86/paravirt: revert exports to restore old behaviour
From: Jeremy Fitzhardinge <jeremy@goop.org>

Subdividing the paravirt_ops structure caused a regression in certain
non-GPL modules which try to use mmu_ops and cpu_ops.  This restores the
old behaviour, and makes it consistent with the non-CONFIG_PARAVIRT case.

Takashi Iwai <tiwai@suse.de> adds:
> I took at this problem (as I have an nvidia card on one of my
> workstations), and found out that the following suffer from
> EXPORT_SYMBOL_GPL changes:
>
> * local_disable_irq(), local_irq_save*(), etc.
> * MSR-related macros like rdmsr(), wrmsr(), read_cr0(), etc.
>   wbinvd(), too.
> * pmd_val(), pgd_val(), etc are all involved with pv_mm_ops.
>   pmd_large() and pmd_bad() is also indirectly involved.
>   __flush_tlb() and friends suffer, too.

Christoph Hellwig objects to this patch on the grounds that modules
shouldn't be using these operations anyway.  I don't think this is a
particularly good reason to reject the patch, for several reasons:

1. These operations are still available to modules when not using
   CONFIG_PARAVIRT, since they are implicitly exported as inline
   functions via the kernel headers.  Exporting the same functionality as
   GPL-only symbols just adds a gratuitious difference between
   CONFIG_PARAVIRT and non-CONFIG_PARAVIRT configurations.  If we really
   think these operations are not for module use (or non-GPL module use),
   then we should solve the problem in a general way.

2. It's a regression from previous kernels, which would work these
   modules even with CONFIG_PARAVIRT enabled.

3. The operations in question seem pretty reasonable for modules to
   use.  The control registers/MSRs can be accessed directly anyway, so there's
   no benefit in preventing modules from using standard interfaces.  And it seems
   reasonable to allow a graphics driver to create its own mappings if it wants.

Therefore, I think this patch should go in for 2.6.24.  If people
really think that these operations should not be available to modules,
then we can address that separately.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Tobias Powalowski <t.powa@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/paravirt_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/paravirt_32.c~x86-paravirt-revert-exports-to-restore-old-behaviour arch/x86/kernel/paravirt_32.c
--- a/arch/x86/kernel/paravirt_32.c~x86-paravirt-revert-exports-to-restore-old-behaviour
+++ a/arch/x86/kernel/paravirt_32.c
@@ -465,8 +465,8 @@ struct pv_mmu_ops pv_mmu_ops = {
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
-EXPORT_SYMBOL_GPL(pv_cpu_ops);
-EXPORT_SYMBOL_GPL(pv_mmu_ops);
+EXPORT_SYMBOL    (pv_cpu_ops);
+EXPORT_SYMBOL    (pv_mmu_ops);
 EXPORT_SYMBOL_GPL(pv_apic_ops);
 EXPORT_SYMBOL_GPL(pv_info);
 EXPORT_SYMBOL    (pv_irq_ops);
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-mask-_page_pcd-from-ptes.patch
x86-paravirt-revert-exports-to-restore-old-behaviour.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-kpagecount-interface.patch
