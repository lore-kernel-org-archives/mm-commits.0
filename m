From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 05 Jun 2020 13:00:13 -0700
Message-ID: <20200605200013.-wswU1Rzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgFEUAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/pci/cdns-pcie.yaml       |   10 -
 Documentation/devicetree/bindings/serial/rs485.yaml        |    3 
 Documentation/devicetree/bindings/usb/aspeed,usb-vhub.yaml |    3 
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi                    |   79 ----------
 arch/powerpc/mm/kasan/kasan_init_32.c                      |    6 
 arch/powerpc/mm/ptdump/ptdump.c                            |   10 -
 6 files changed, 111 deletions(-)

--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi~linux-next-git-rejects
+++ a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -100,82 +100,6 @@
 		};
 	};
 
-<<<<<<< HEAD
-	mcc {
-		compatible = "arm,vexpress,config-bus";
-		arm,vexpress,config-bridge = <&v2m_sysreg>;
-
-		oscclk0 {
-			/* MCC static memory clock */
-			compatible = "arm,vexpress-osc";
-			arm,vexpress-sysreg,func = <1 0>;
-			freq-range = <25000000 60000000>;
-			#clock-cells = <0>;
-			clock-output-names = "v2m:oscclk0";
-		};
-
-		v2m_oscclk1: oscclk1 {
-			/* CLCD clock */
-			compatible = "arm,vexpress-osc";
-			arm,vexpress-sysreg,func = <1 1>;
-			freq-range = <23750000 65000000>;
-			#clock-cells = <0>;
-			clock-output-names = "v2m:oscclk1";
-		};
-
-		v2m_oscclk2: oscclk2 {
-			/* IO FPGA peripheral clock */
-			compatible = "arm,vexpress-osc";
-			arm,vexpress-sysreg,func = <1 2>;
-			freq-range = <24000000 24000000>;
-			#clock-cells = <0>;
-			clock-output-names = "v2m:oscclk2";
-		};
-
-		volt-vio {
-			/* Logic level voltage */
-			compatible = "arm,vexpress-volt";
-			arm,vexpress-sysreg,func = <2 0>;
-			regulator-name = "VIO";
-			regulator-always-on;
-			label = "VIO";
-		};
-
-		temp-mcc {
-			/* MCC internal operating temperature */
-			compatible = "arm,vexpress-temp";
-			arm,vexpress-sysreg,func = <4 0>;
-			label = "MCC";
-		};
-
-		reset {
-			compatible = "arm,vexpress-reset";
-			arm,vexpress-sysreg,func = <5 0>;
-		};
-
-		muxfpga {
-			compatible = "arm,vexpress-muxfpga";
-			arm,vexpress-sysreg,func = <7 0>;
-		};
-
-		shutdown {
-			compatible = "arm,vexpress-shutdown";
-			arm,vexpress-sysreg,func = <8 0>;
-		};
-
-		reboot {
-			compatible = "arm,vexpress-reboot";
-			arm,vexpress-sysreg,func = <9 0>;
-		};
-
-		dvimode {
-			compatible = "arm,vexpress-dvimode";
-			arm,vexpress-sysreg,func = <11 0>;
-		};
-	};
-
-=======
->>>>>>> linux-next/akpm-base
 	bus@8000000 {
 		motherboard-bus {
 			model = "V2M-P1";
@@ -438,8 +362,6 @@
 						};
 					};
 				};
-<<<<<<< HEAD
-=======
 
 				mcc {
 					compatible = "arm,vexpress,config-bus";
@@ -513,7 +435,6 @@
 						arm,vexpress-sysreg,func = <11 0>;
 					};
 				};
->>>>>>> linux-next/akpm-base
 			};
 		};
 	};
--- a/arch/powerpc/mm/kasan/kasan_init_32.c~linux-next-git-rejects
+++ a/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -103,13 +103,7 @@ static void __init kasan_remap_early_sha
 	pgprot_t prot = kasan_prot_ro();
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
-<<<<<<< HEAD
-	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
-		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
-=======
 	kasan_populate_pte(kasan_early_shadow_pte, prot);
->>>>>>> linux-next/akpm-base
 
 	kasan_update_early_region(KASAN_SHADOW_START, KASAN_SHADOW_END,
 				  pfn_pte(PHYS_PFN(pa), prot));
--- a/arch/powerpc/mm/ptdump/ptdump.c~linux-next-git-rejects
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -333,15 +333,6 @@ static void walk_pagetables(struct pg_st
 	 * the hash pagetable.
 	 */
 	for (i = pgd_index(addr); i < PTRS_PER_PGD; i++, pgd++, addr += PGDIR_SIZE) {
-<<<<<<< HEAD
-		p4d_t *p4d = p4d_offset(pgd, 0);
-
-		if (!p4d_none(*p4d) && !p4d_is_leaf(*p4d))
-			/* pgd exists */
-			walk_pud(st, p4d, addr);
-		else
-			note_page(st, addr, 1, p4d_val(*p4d));
-=======
 		if (pgd_none(*pgd) || pgd_is_leaf(*pgd))
 			note_page(st, addr, 1, pgd_val(*pgd), PGDIR_SIZE);
 		else if (is_hugepd(__hugepd(pgd_val(*pgd))))
@@ -349,7 +340,6 @@ static void walk_pagetables(struct pg_st
 		else
 			/* pgd exists */
 			walk_pud(st, pgd, addr);
->>>>>>> linux-next/akpm-base
 	}
 }
 
--- a/Documentation/devicetree/bindings/pci/cdns-pcie.yaml~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/pci/cdns-pcie.yaml
@@ -10,16 +10,6 @@ maintainers:
   - Tom Joseph <tjoseph@cadence.com>
 
 properties:
-<<<<<<< HEAD
-  cdns,max-outbound-regions:
-    description: maximum number of outbound regions
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 1
-    maximum: 32
-    default: 32
-
-=======
->>>>>>> linux-next/akpm-base
   phys:
     description:
       One per lane if more than one in the list. If only one PHY listed it must
--- a/Documentation/devicetree/bindings/serial/rs485.yaml~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/serial/rs485.yaml
@@ -41,11 +41,8 @@ properties:
   rs485-rx-during-tx:
     description: enables the receiving of data even while sending data.
     $ref: /schemas/types.yaml#/definitions/flag
-<<<<<<< HEAD
-=======
 
   rs485-term-gpios:
     description: GPIO pin to enable RS485 bus termination.
     maxItems: 1
->>>>>>> linux-next/akpm-base
 ...
--- a/Documentation/devicetree/bindings/usb/aspeed,usb-vhub.yaml~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/usb/aspeed,usb-vhub.yaml
@@ -49,8 +49,6 @@ properties:
     default: 15
     minimum: 1
     maximum: 21
-<<<<<<< HEAD
-=======
 
   vhub-vendor-id:
     description: vhub Vendor ID
@@ -104,7 +102,6 @@ properties:
             description: vhub device serial number
             allOf:
               - $ref: /schemas/types.yaml#/definitions/string
->>>>>>> linux-next/akpm-base
 
 required:
   - compatible
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
