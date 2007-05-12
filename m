From: akpm@linux-foundation.org
Subject: - mips-tlbex-use-__maybe_unused.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:48 -0700
Message-ID: <200705120536.l4C5amq3002404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbXELFhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: tlbex: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     mips-tlbex-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: tlbex: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace function instances of __attribute__((unused)) with
__maybe_unused.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/tlbex.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN arch/mips/mm/tlbex.c~mips-tlbex-use-__maybe_unused arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~mips-tlbex-use-__maybe_unused
+++ a/arch/mips/mm/tlbex.c
@@ -35,24 +35,24 @@
 #include <asm/smp.h>
 #include <asm/war.h>
 
-static __init int __attribute__((unused)) r45k_bvahwbug(void)
+static __init int __maybe_unused r45k_bvahwbug(void)
 {
 	/* XXX: We should probe for the presence of this bug, but we don't. */
 	return 0;
 }
 
-static __init int __attribute__((unused)) r4k_250MHZhwbug(void)
+static __init int __maybe_unused r4k_250MHZhwbug(void)
 {
 	/* XXX: We should probe for the presence of this bug, but we don't. */
 	return 0;
 }
 
-static __init int __attribute__((unused)) bcm1250_m3_war(void)
+static __init int __maybe_unused bcm1250_m3_war(void)
 {
 	return BCM1250_M3_WAR;
 }
 
-static __init int __attribute__((unused)) r10000_llsc_war(void)
+static __init int __maybe_unused r10000_llsc_war(void)
 {
 	return R10000_LLSC_WAR;
 }
@@ -511,18 +511,18 @@ L_LA(_r3000_write_probe_fail)
 #define i_ehb(buf) i_sll(buf, 0, 0, 3)
 
 #ifdef CONFIG_64BIT
-static __init int __attribute__((unused)) in_compat_space_p(long addr)
+static __init int __maybe_unused in_compat_space_p(long addr)
 {
 	/* Is this address in 32bit compat space? */
 	return (((addr) & 0xffffffff00000000L) == 0xffffffff00000000L);
 }
 
-static __init int __attribute__((unused)) rel_highest(long val)
+static __init int __maybe_unused rel_highest(long val)
 {
 	return ((((val + 0x800080008000L) >> 48) & 0xffff) ^ 0x8000) - 0x8000;
 }
 
-static __init int __attribute__((unused)) rel_higher(long val)
+static __init int __maybe_unused rel_higher(long val)
 {
 	return ((((val + 0x80008000L) >> 32) & 0xffff) ^ 0x8000) - 0x8000;
 }
@@ -556,8 +556,8 @@ static __init void i_LA_mostly(u32 **buf
 		i_lui(buf, rs, rel_hi(addr));
 }
 
-static __init void __attribute__((unused)) i_LA(u32 **buf, unsigned int rs,
-						long addr)
+static __init void __maybe_unused i_LA(u32 **buf, unsigned int rs,
+					     long addr)
 {
 	i_LA_mostly(buf, rs, addr);
 	if (rel_lo(addr))
@@ -636,8 +636,8 @@ static __init void copy_handler(struct r
 	move_labels(lab, first, end, off);
 }
 
-static __init int __attribute__((unused)) insn_has_bdelay(struct reloc *rel,
-							  u32 *addr)
+static __init int __maybe_unused insn_has_bdelay(struct reloc *rel,
+						       u32 *addr)
 {
 	for (; rel->lab != label_invalid; rel++) {
 		if (rel->addr == addr
@@ -650,15 +650,15 @@ static __init int __attribute__((unused)
 }
 
 /* convenience functions for labeled branches */
-static void __init __attribute__((unused))
+static void __init __maybe_unused
 	il_bltz(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
 	i_bltz(p, reg, 0);
 }
 
-static void __init __attribute__((unused)) il_b(u32 **p, struct reloc **r,
-					 enum label_id l)
+static void __init __maybe_unused il_b(u32 **p, struct reloc **r,
+					     enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
 	i_b(p, 0);
@@ -671,7 +671,7 @@ static void __init il_beqz(u32 **p, stru
 	i_beqz(p, reg, 0);
 }
 
-static void __init __attribute__((unused))
+static void __init __maybe_unused
 il_beqzl(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
@@ -692,7 +692,7 @@ static void __init il_bgezl(u32 **p, str
 	i_bgezl(p, reg, 0);
 }
 
-static void __init __attribute__((unused))
+static void __init __maybe_unused
 il_bgez(u32 **p, struct reloc **r, unsigned int reg, enum label_id l)
 {
 	r_mips_pc16(r, *p, l);
@@ -810,7 +810,7 @@ static __initdata u32 final_handler[64];
  *
  * As if we MIPS hackers wouldn't know how to nop pipelines happy ...
  */
-static __init void __attribute__((unused)) build_tlb_probe_entry(u32 **p)
+static __init void __maybe_unused build_tlb_probe_entry(u32 **p)
 {
 	switch (current_cpu_data.cputype) {
 	/* Found by experiment: R4600 v2.0 needs this, too.  */
@@ -1098,7 +1098,7 @@ build_get_pgd_vmalloc64(u32 **p, struct 
  * TMP and PTR are scratch.
  * TMP will be clobbered, PTR will hold the pgd entry.
  */
-static __init void __attribute__((unused))
+static __init void __maybe_unused
 build_get_pgde32(u32 **p, unsigned int tmp, unsigned int ptr)
 {
 	long pgdc = (long)pgd_current;
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
