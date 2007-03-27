From: akpm@linux-foundation.org
Subject: - lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:02:06 -0800
Message-ID: <200703270602.l2R626Jq008870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41111 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXC0GFY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: remove check_bug_kill()
has been removed from the -mm tree.  Its filename was
     lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch

This patch was dropped because it was folded into lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch

------------------------------------------------------
Subject: lguest: remove check_bug_kill()
From: Adrian Bunk <bunk@stusta.de>

check_bug_kill() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/interrupts_and_traps.c |   27 ----------------------
 arch/i386/lguest/lg.h                   |    1 
 2 files changed, 28 deletions(-)

diff -puN arch/i386/lguest/interrupts_and_traps.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy arch/i386/lguest/interrupts_and_traps.c
--- a/arch/i386/lguest/interrupts_and_traps.c~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy
+++ a/arch/i386/lguest/interrupts_and_traps.c
@@ -118,33 +118,6 @@ int deliver_trap(struct lguest *lg, unsi
 	return 1;
 }
 
-void check_bug_kill(struct lguest *lg)
-{
-#ifdef CONFIG_BUG
-	u32 eip = lg->regs->eip - PAGE_OFFSET;
-	u16 insn;
-
-	/* This only works for addresses in linear mapping... */
-	if (lg->regs->eip < PAGE_OFFSET)
-		return;
-	lhread(lg, &insn, eip, sizeof(insn));
-	if (insn == 0x0b0f) {
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-		u16 l;
-		u32 f;
-		char file[128];
-		lhread(lg, &l, eip+sizeof(insn), sizeof(l));
-		lhread(lg, &f, eip+sizeof(insn)+sizeof(l), sizeof(f));
-		lhread(lg, file, f - PAGE_OFFSET, sizeof(file));
-		file[sizeof(file)-1] = 0;
-		kill_guest(lg, "BUG() at %#x %s:%u", eip, file, l);
-#else
-		kill_guest(lg, "BUG() at %#x", eip);
-#endif	/* CONFIG_DEBUG_BUGVERBOSE */
-	}
-#endif	/* CONFIG_BUG */
-}
-
 static int direct_trap(const struct lguest *lg,
 		       const struct desc_struct *trap,
 		       unsigned int num)
diff -puN arch/i386/lguest/lg.h~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy
+++ a/arch/i386/lguest/lg.h
@@ -195,7 +195,6 @@ int find_free_guest(void);
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest *lg);
 int deliver_trap(struct lguest *lg, unsigned int num);
-void check_bug_kill(struct lguest *lg);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void pin_stack_pages(struct lguest *lg);
 void pin_trap_pages(struct lguest *lg);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-spi-fix-section-mismatches.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
make-mptspi_target_destroy-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
