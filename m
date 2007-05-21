From: akpm@linux-foundation.org
Subject: + git-kbuild-fixup.patch added to -mm tree
Date: Mon, 21 May 2007 13:07:24 -0700
Message-ID: <200705212007.l4LK7QDb018705@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759115AbXEUUIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:08:06 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4LK7RFO011908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 21 May 2007 13:08:04 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-kbuild-fixup
has been added to the -mm tree.  Its filename is
     git-kbuild-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-kbuild-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h  |   16 ----------------
 scripts/mod/modpost.c |   27 ---------------------------
 2 files changed, 43 deletions(-)

diff -puN include/linux/init.h~git-kbuild-fixup include/linux/init.h
--- a/include/linux/init.h~git-kbuild-fixup
+++ a/include/linux/init.h
@@ -45,21 +45,6 @@
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
 #define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
-<<<<<<< HEAD/include/linux/init.h
-/* modpost check for section mismatches during the kernel build.
- * A section mismatch happens when there are references from a
- * code or data section to an init section (both code or data).
- * The init sections are (for most archs) discarded by the kernel
- * when early init has completed so all such references are potential bugs.
- * For exit sections the same issue exists.
- * The following markers are used for the cases where the reference to
- * the init/exit section (code or data) is valid and will teach modpost
- * not to issue a warning.
- * The markers follow same syntax rules as __init / __initdata. */
-#define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
-#define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
-
-=======
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
  * code or data section to an init section (both code or data).
@@ -73,7 +58,6 @@
 #define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
 #define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
 
->>>>>>> /include/linux/init.h
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
diff -puN scripts/mod/modpost.c~git-kbuild-fixup scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~git-kbuild-fixup
+++ a/scripts/mod/modpost.c
@@ -873,55 +873,28 @@ static void warn_sec_mismatch(const char
 		return;
 
 	if (before && after) {
-<<<<<<< HEAD/scripts/mod/modpost.c
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
-		     "(between '%s' and '%s')\n",
-		     modname, fromsec, (unsigned long long)r.r_offset,
-		     secname, refsymname,
-=======
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(between '%s' and '%s')\n",
 		     modname, fromsec, (long long)r.r_offset,
 		     secname, refsymname,
->>>>>>> /scripts/mod/modpost.c
 		     elf->strtab + before->st_name,
 		     elf->strtab + after->st_name);
 	} else if (before) {
-<<<<<<< HEAD/scripts/mod/modpost.c
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
-		     "(after '%s')\n",
-		     modname, fromsec, (unsigned long long)r.r_offset,
-		     secname, refsymname,
-		     elf->strtab + before->st_name);
-=======
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(after '%s')\n",
 		     modname, fromsec, (long long)r.r_offset,
 		     secname, refsymname,
 		     elf->strtab + before->st_name);
->>>>>>> /scripts/mod/modpost.c
 	} else if (after) {
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "before '%s' (at offset -0x%llx)\n",
-<<<<<<< HEAD/scripts/mod/modpost.c
-		     modname, fromsec, (unsigned long long)r.r_offset,
-		     secname, refsymname,
-		     elf->strtab + after->st_name);
-=======
 		     modname, fromsec, (long long)r.r_offset,
 		     secname, refsymname,
 		     elf->strtab + after->st_name);
->>>>>>> /scripts/mod/modpost.c
 	} else {
-<<<<<<< HEAD/scripts/mod/modpost.c
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
-		     modname, fromsec, (unsigned long long)r.r_offset,
-		     secname, refsymname);
-=======
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
 		     modname, fromsec, (long long)r.r_offset,
 		     secname, refsymname);
->>>>>>> /scripts/mod/modpost.c
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
pci-x-pci-express-read-control-interfaces-fix.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
simplify-cleanup_workqueue_thread-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
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
cfs-scheduler-vs-detach-schedh-from-mmh.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch
