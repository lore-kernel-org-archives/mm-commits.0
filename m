From: akpm@linux-foundation.org
Subject: + i386-pci-type-may-be-unused.patch added to -mm tree
Date: Fri, 04 May 2007 02:09:15 -0700
Message-ID: <200705040909.l4499FqC000539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422909AbXEDJJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 05:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de


The patch titled
     i386 pci: type may be unused
has been added to the -mm tree.  Its filename is
     i386-pci-type-may-be-unused.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 pci: type may be unused
From: David Rientjes <rientjes@google.com>

In the case of !CONFIG_PCI_DIRECT && !CONFIG_PCI_MMCONFIG, type is
unreferened.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/pci/init.c~i386-pci-type-may-be-unused arch/i386/pci/init.c
--- a/arch/i386/pci/init.c~i386-pci-type-may-be-unused
+++ a/arch/i386/pci/init.c
@@ -6,7 +6,7 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type = 0;
+	int type __attribute_unused__ = 0;
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
wavefront-only-declare-isapnp-on-config_pnp.patch
git-cpufreq.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-define-__attribute_unused__.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__attribute_unused__.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__attribute_unused__.patch
i386-voyager-use-__attribute_unused__.patch
mips-excite-use-__attribute_unused__.patch
mips-tlbex-use-__attribute_unused__.patch
powerpc-ps3-use-__attribute_unused__.patch
i386-mmzone-use-__attribute_unused__.patch
