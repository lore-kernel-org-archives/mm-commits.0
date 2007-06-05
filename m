From: akpm@linux-foundation.org
Subject: + rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch added to -mm tree
Date: Mon, 04 Jun 2007 18:19:19 -0700
Message-ID: <200706050119.l551JHLW026788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbXFEBTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 21:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org


The patch titled
     rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix
has been added to the -mm tree.  Its filename is
     rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Some changes done a while ago to avoid pounding on ptep_set_access_flags
and update_mmu_cache in some race situations break sun4c which requires
update_mmu_cache() to always be called on minor faults.

This patch reworks ptep_set_access_flags() semantics, implementations
and callers so that it's now responsible for returning whether an update
is necessary or not (basically whether the PTE actually changed). This
allow fixing the sparc implementation to always return 1 on sun4c.

Hope I got ia64 right this time !

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/pgtable.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix
+++ a/include/asm-ia64/pgtable.h
@@ -534,13 +534,13 @@ extern void lazy_mmu_prot_update (pte_t 
  */
 #ifdef CONFIG_SMP
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
-({										\
-	int __changed = !pte_same(*(__ptep), __entry);				\
-	if (__changed && __safely_writable) {					\
-		set_pte(__ptep, __entry);					\
-		flush_tlb_page(__vma, __addr);					\
-	}									\
-	__changed;								\
+({									\
+	int __changed = !pte_same(*(__ptep), __entry);			\
+	if (__changed && __safely_writable) {				\
+		set_pte(__ptep, __entry);				\
+		flush_tlb_page(__vma, __addr);				\
+	}								\
+	__changed;							\
 })
 #else
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix-fix.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
8xx-fix-whitespace-and-indentation.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
controlfb-the-pseudo_palette-is-only-16-elements-long.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
