From: akpm@linux-foundation.org
Subject: + pie-randomization-fix.patch added to -mm tree
Date: Fri, 18 May 2007 10:29:29 -0700
Message-ID: <200705181729.l4IHTT2R019700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:49486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbXERRex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, honza@jikos.cz, jakub@redhat.com, jkosina@suse.cz, mingo@elte.hu, roland@redhat.com


The patch titled
     pie-randomization-fix
has been added to the -mm tree.  Its filename is
     pie-randomization-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pie-randomization-fix
From: Andrew Morton <akpm@linux-foundation.org>

- the compiler knows how to inline things

- return -EINVAL on zero-size, not -EIO

- reduce scope of local `interp_map_addr', remove unneeded initialisation,
  add needed comment.

- coding-style repairs

Cc: Jan Kratochvil <honza@jikos.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_elf.c~pie-randomization-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-randomization-fix
+++ a/fs/binfmt_elf.c
@@ -322,17 +322,17 @@ static unsigned long elf_map(struct file
 
 #endif /* !elf_map */
 
-static inline unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
+static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
 {
 	int i, first_idx = -1, last_idx = -1;
 
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < nr; i++) {
 		if (cmds[i].p_type == PT_LOAD) {
 			last_idx = i;
 			if (first_idx == -1)
 				first_idx = i;
 		}
-
+	}
 	if (first_idx == -1)
 		return 0;
 
@@ -396,8 +396,10 @@ static unsigned long load_elf_interp(str
 	}
 
 	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
-	if (!total_size)
+	if (!total_size) {
+		error = -EINVAL;
 		goto out_close;
+	}
 
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
@@ -586,7 +588,8 @@ static int load_elf_binary(struct linux_
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry, interp_load_addr = 0, interp_map_addr = 0;
+	unsigned long elf_entry;
+	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -908,7 +911,7 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 			load_bias = 0;
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
@@ -992,16 +995,21 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (interpreter_type == INTERPRETER_AOUT) {
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		else {
+		} else {
+			unsigned long interp_map_addr;	/* unused */
+
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
 						    &interp_map_addr,
 						    load_bias);
 			if (!BAD_ADDR(elf_entry)) {
-				/* load_elf_interp() returns relocation adjustment */
+				/*
+				 * load_elf_interp() returns relocation
+				 * adjustment
+				 */
 				interp_load_addr = elf_entry;
 				elf_entry += loc->interp_elf_ex.e_entry;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-powerpc.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-fix-machine-rebooting-fix.patch
xfs-clean-up-shrinker-games.patch
pci-x-pci-express-read-control-interfaces-fix.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
pie-randomization-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch
