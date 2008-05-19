From: akpm@linux-foundation.org
Subject: - x86-fix-mprotects-nx-handling-on-pae.patch removed from -mm tree
Date: Mon, 19 May 2008 16:29:08 -0700
Message-ID: <200805192329.m4JNT8AH026744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYESX3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 19:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix mprotect's NX handling on PAE
has been removed from the -mm tree.  Its filename was
     x86-fix-mprotects-nx-handling-on-pae.patch

This patch was dropped because Linus woke up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix mprotect's NX handling on PAE
From: Hugh Dickins <hugh@veritas.com>

2.6.26-rc3 with CONFIG_X86_PAE may leave the NX bit set when PROT_EXEC
is intending to clear it, causing irqbalance and others to segfault,
and X startup to fail.

This comes from an assumption in
1c12c4cf9411eb130b245fa8d0fbbaf989477c7b mprotect: prevent alteration
of the PAT bits, that PTE_MASK is what it's supposed to be: whereas
it's been wrong forever with PAE, staying 32-bit where 64-bit is
needed.

Jeremy Fitzhardinge already has patches to fix that in Ingo's tree; but
if they're not considered 2.6.26 material, or people want a quick
two-liner to get working, here's a shorter hack to fix up pte_modify.

I apologize to those we've broken, and to Venki Pallipadi: it was I who
persuaded him to change his working patch to make that false
assumption.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/pgtable.h~x86-fix-mprotects-nx-handling-on-pae include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~x86-fix-mprotects-nx-handling-on-pae
+++ a/include/asm-x86/pgtable.h
@@ -57,8 +57,8 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(((pteval_t) PTE_MASK & ~_PAGE_NX) | 		\
+			 _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
x86-fix-mprotects-nx-handling-on-pae.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
prio_tree-debugging-patch.patch

