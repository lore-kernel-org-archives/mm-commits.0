From: akpm@linux-foundation.org
Subject: + frv-gdb-use-__attribute_unused__.patch added to -mm tree
Date: Fri, 04 May 2007 02:09:22 -0700
Message-ID: <200705040909.l4499Mwm000548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767767AbXEDJKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 05:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dhowells@redhat.com


The patch titled
     frv: gdb: use __attribute_unused__
has been added to the -mm tree.  Its filename is
     frv-gdb-use-__attribute_unused__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: frv: gdb: use __attribute_unused__
From: David Rientjes <rientjes@google.com>

Replace function instances of __attribute__((unused)) with
__attribute_unused__ to suppress warnings.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-gdb-use-__attribute_unused__ arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-gdb-use-__attribute_unused__
+++ a/arch/frv/kernel/gdb-stub.c
@@ -1195,7 +1195,7 @@ static void gdbstub_check_breakpoint(voi
 /*
  *
  */
-static void __attribute__((unused)) gdbstub_show_regs(void)
+static void __attribute_unused__ gdbstub_show_regs(void)
 {
 	unsigned long *reg;
 	int loop;
@@ -1223,7 +1223,7 @@ static void __attribute__((unused)) gdbs
 /*
  * dump debugging regs
  */
-static void __attribute__((unused)) gdbstub_dump_debugregs(void)
+static void __attribute_unused__ gdbstub_dump_debugregs(void)
 {
 	gdbstub_printk("DCR    %08lx  ", __debug_status.dcr);
 	gdbstub_printk("BRR    %08lx\n", __debug_status.brr);
@@ -2079,25 +2079,25 @@ void gdbstub_exit(int status)
  * GDB wants to call malloc() and free() to allocate memory for calling kernel
  * functions directly from its command line
  */
-static void *malloc(size_t size) __attribute__((unused));
+static void *malloc(size_t size) __attribute_unused__;
 static void *malloc(size_t size)
 {
 	return kmalloc(size, GFP_ATOMIC);
 }
 
-static void free(void *p) __attribute__((unused));
+static void free(void *p) __attribute_unused__;
 static void free(void *p)
 {
 	kfree(p);
 }
 
-static uint32_t ___get_HSR0(void) __attribute__((unused));
+static uint32_t ___get_HSR0(void) __attribute_unused__;
 static uint32_t ___get_HSR0(void)
 {
 	return __get_HSR(0);
 }
 
-static uint32_t ___set_HSR0(uint32_t x) __attribute__((unused));
+static uint32_t ___set_HSR0(uint32_t x) __attribute_unused__;
 static uint32_t ___set_HSR0(uint32_t x)
 {
 	__set_HSR(0, x);
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
