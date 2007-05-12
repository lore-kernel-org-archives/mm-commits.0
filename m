From: akpm@linux-foundation.org
Subject: - frv-gdb-use-__maybe_unused.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:56 -0700
Message-ID: <200705120532.l4C5WuaU002072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbXELFdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: gdb: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     frv-gdb-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: frv: gdb: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace function instances of __attribute__((unused)) with
__maybe_unused to suppress warnings.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-gdb-use-__maybe_unused arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-gdb-use-__maybe_unused
+++ a/arch/frv/kernel/gdb-stub.c
@@ -1195,7 +1195,7 @@ static void gdbstub_check_breakpoint(voi
 /*
  *
  */
-static void __attribute__((unused)) gdbstub_show_regs(void)
+static void __maybe_unused gdbstub_show_regs(void)
 {
 	unsigned long *reg;
 	int loop;
@@ -1223,7 +1223,7 @@ static void __attribute__((unused)) gdbs
 /*
  * dump debugging regs
  */
-static void __attribute__((unused)) gdbstub_dump_debugregs(void)
+static void __maybe_unused gdbstub_dump_debugregs(void)
 {
 	gdbstub_printk("DCR    %08lx  ", __debug_status.dcr);
 	gdbstub_printk("BRR    %08lx\n", __debug_status.brr);
@@ -2079,25 +2079,25 @@ void gdbstub_exit(int status)
  * GDB wants to call malloc() and free() to allocate memory for calling kernel
  * functions directly from its command line
  */
-static void *malloc(size_t size) __attribute__((unused));
+static void *malloc(size_t size) __maybe_unused;
 static void *malloc(size_t size)
 {
 	return kmalloc(size, GFP_ATOMIC);
 }
 
-static void free(void *p) __attribute__((unused));
+static void free(void *p) __maybe_unused;
 static void free(void *p)
 {
 	kfree(p);
 }
 
-static uint32_t ___get_HSR0(void) __attribute__((unused));
+static uint32_t ___get_HSR0(void) __maybe_unused;
 static uint32_t ___get_HSR0(void)
 {
 	return __get_HSR(0);
 }
 
-static uint32_t ___set_HSR0(uint32_t x) __attribute__((unused));
+static uint32_t ___set_HSR0(uint32_t x) __maybe_unused;
 static uint32_t ___set_HSR0(uint32_t x)
 {
 	__set_HSR(0, x);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
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
