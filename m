From: akpm@linux-foundation.org
Subject: + alpha-convert-u64-to-unsigned-long-long-fix-3.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:46:57 -0800
Message-ID: <200902262246.n1QMkvoJ030591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbZBZWro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:47:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: more u64/ull type fixes
has been added to the -mm tree.  Its filename is
     alpha-convert-u64-to-unsigned-long-long-fix-3.patch

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
Subject: alpha: more u64/ull type fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

More alpha u64/ull fixes, on top of Andrew's 2 small patches.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/machvec.h |    2 +-
 arch/alpha/kernel/proto.h        |   14 +++++++-------
 arch/alpha/kernel/sys_jensen.c   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/alpha/include/asm/machvec.h~alpha-convert-u64-to-unsigned-long-long-fix-3 arch/alpha/include/asm/machvec.h
--- a/arch/alpha/include/asm/machvec.h~alpha-convert-u64-to-unsigned-long-long-fix-3
+++ a/arch/alpha/include/asm/machvec.h
@@ -80,7 +80,7 @@ struct alpha_machine_vector
 	void (*update_irq_hw)(unsigned long, unsigned long, int);
 	void (*ack_irq)(unsigned long);
 	void (*device_interrupt)(unsigned long vector);
-	void (*machine_check)(u64 vector, u64 la);
+	void (*machine_check)(unsigned long vector, unsigned long la);
 
 	void (*smp_callin)(void);
 	void (*init_arch)(void);
diff -puN arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long-fix-3 arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long-fix-3
+++ a/arch/alpha/kernel/proto.h
@@ -20,7 +20,7 @@ struct pci_controller;
 extern struct pci_ops apecs_pci_ops;
 extern void apecs_init_arch(void);
 extern void apecs_pci_clr_err(void);
-extern void apecs_machine_check(u64, u64);
+extern void apecs_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void apecs_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_cia.c */
@@ -29,7 +29,7 @@ extern void cia_init_pci(void);
 extern void cia_init_arch(void);
 extern void pyxis_init_arch(void);
 extern void cia_kill_arch(int);
-extern void cia_machine_check(u64, u64);
+extern void cia_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void cia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_irongate.c */
@@ -42,7 +42,7 @@ extern void irongate_machine_check(u64, 
 /* core_lca.c */
 extern struct pci_ops lca_pci_ops;
 extern void lca_init_arch(void);
-extern void lca_machine_check(u64, u64);
+extern void lca_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void lca_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_marvel.c */
@@ -72,14 +72,14 @@ extern struct pci_ops polaris_pci_ops;
 extern int polaris_read_config_dword(struct pci_dev *, int, u32 *);
 extern int polaris_write_config_dword(struct pci_dev *, int, u32);
 extern void polaris_init_arch(void);
-extern void polaris_machine_check(u64, u64);
+extern void polaris_machine_check(unsigned long vector, unsigned long la_ptr);
 #define polaris_pci_tbi ((void *)0)
 
 /* core_t2.c */
 extern struct pci_ops t2_pci_ops;
 extern void t2_init_arch(void);
 extern void t2_kill_arch(int);
-extern void t2_machine_check(u64, u64);
+extern void t2_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void t2_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_titan.c */
@@ -94,14 +94,14 @@ extern struct _alpha_agp_info *titan_agp
 extern struct pci_ops tsunami_pci_ops;
 extern void tsunami_init_arch(void);
 extern void tsunami_kill_arch(int);
-extern void tsunami_machine_check(u64, u64);
+extern void tsunami_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void tsunami_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_wildfire.c */
 extern struct pci_ops wildfire_pci_ops;
 extern void wildfire_init_arch(void);
 extern void wildfire_kill_arch(int);
-extern void wildfire_machine_check(u64, u64);
+extern void wildfire_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void wildfire_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern int wildfire_pa_to_nid(unsigned long);
 extern int wildfire_cpuid_to_nid(int);
diff -puN arch/alpha/kernel/sys_jensen.c~alpha-convert-u64-to-unsigned-long-long-fix-3 arch/alpha/kernel/sys_jensen.c
--- a/arch/alpha/kernel/sys_jensen.c~alpha-convert-u64-to-unsigned-long-long-fix-3
+++ a/arch/alpha/kernel/sys_jensen.c
@@ -244,7 +244,7 @@ jensen_init_arch(void)
 }
 
 static void
-jensen_machine_check (u64 vector, u64 la)
+jensen_machine_check (unsigned long vector, unsigned long la)
 {
 	printk(KERN_CRIT "Machine check\n");
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
via-sdmmc-via-msp-card-reader-driver-support-update.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

