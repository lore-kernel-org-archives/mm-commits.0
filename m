From: akpm@linux-foundation.org
Subject: + remove-frv-usage-of-flush_tlb_pgtables.patch added to -mm tree
Date: Fri, 27 Jul 2007 14:10:42 -0700
Message-ID: <200707272110.l6RLAgT4010141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761271AbXG0VK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 17:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, dhowells@redhat.com


The patch titled
     remove frv usage of flush_tlb_pgtables()
has been added to the -mm tree.  Its filename is
     remove-frv-usage-of-flush_tlb_pgtables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove frv usage of flush_tlb_pgtables()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

frv is the last user in the tree of that dubious hook, and it's my
understanding that it's not even needed.  It's only called by memory.c
free_pgd_range() which is always called within an mmu_gather, and
tlb_flush() on frv will do a flush_tlb_mm(), which from my reading of the
code, seems to do what flush_tlb_ptables() does, which is to clear the
cached PGE.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/tlbflush.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/asm-frv/tlbflush.h~remove-frv-usage-of-flush_tlb_pgtables include/asm-frv/tlbflush.h
--- a/include/asm-frv/tlbflush.h~remove-frv-usage-of-flush_tlb_pgtables
+++ a/include/asm-frv/tlbflush.h
@@ -57,8 +57,7 @@ do {								\
 #define __flush_tlb_global()			flush_tlb_all()
 #define flush_tlb()				flush_tlb_all()
 #define flush_tlb_kernel_range(start, end)	flush_tlb_all()
-#define flush_tlb_pgtables(mm,start,end) \
-	asm volatile("movgs %0,scr0 ! movgs %0,scr1" :: "r"(ULONG_MAX) : "memory");
+#define flush_tlb_pgtables(mm,start,end)	do { } while(0)
 
 #else
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

fix-dynreloc-miscount-link-error-on-powerpc.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
adbhid-produce-all-capslock-key-events.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-libata-all.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
ppc64-sparsemem_vmemmap-support.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
report-the-per-irq-statistics-on-allarches.patch
