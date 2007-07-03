From: akpm@linux-foundation.org
Subject: + bonding-bond_mainc-make-2-functions-static.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:51:15 -0700
Message-ID: <200707032151.l63LpFDY018001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbXGCVwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ctindel@users.sourceforge.net, fubar@us.ibm.com


The patch titled
     bonding/bond_main.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     bonding-bond_mainc-make-2-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bonding/bond_main.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Chad Tindel <ctindel@users.sourceforge.net>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    5 +++--
 drivers/net/bonding/bonding.h   |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-bond_mainc-make-2-functions-static drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-bond_mainc-make-2-functions-static
+++ a/drivers/net/bonding/bond_main.c
@@ -187,7 +187,7 @@ static void bond_send_gratuitous_arp(str
 
 /*---------------------------- General routines -----------------------------*/
 
-const char *bond_mode_name(int mode)
+static const char *bond_mode_name(int mode)
 {
 	switch (mode) {
 	case BOND_MODE_ROUNDROBIN :
@@ -1224,7 +1224,8 @@ static void bond_detach_slave(struct bon
 
 /*---------------------------------- IOCTL ----------------------------------*/
 
-int bond_sethwaddr(struct net_device *bond_dev, struct net_device *slave_dev)
+static int bond_sethwaddr(struct net_device *bond_dev,
+			  struct net_device *slave_dev)
 {
 	dprintk("bond_dev=%p\n", bond_dev);
 	dprintk("slave_dev=%p\n", slave_dev);
diff -puN drivers/net/bonding/bonding.h~bonding-bond_mainc-make-2-functions-static drivers/net/bonding/bonding.h
--- a/drivers/net/bonding/bonding.h~bonding-bond_mainc-make-2-functions-static
+++ a/drivers/net/bonding/bonding.h
@@ -301,13 +301,11 @@ int bond_create_slave_symlinks(struct ne
 void bond_destroy_slave_symlinks(struct net_device *master, struct net_device *slave);
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev);
 int bond_release(struct net_device *bond_dev, struct net_device *slave_dev);
-int bond_sethwaddr(struct net_device *bond_dev, struct net_device *slave_dev);
 void bond_mii_monitor(struct net_device *bond_dev);
 void bond_loadbalance_arp_mon(struct net_device *bond_dev);
 void bond_activebackup_arp_mon(struct net_device *bond_dev);
 void bond_set_mode_ops(struct bonding *bond, int mode);
 int bond_parse_parm(char *mode_arg, struct bond_parm_tbl *tbl);
-const char *bond_mode_name(int mode);
 void bond_select_active_slave(struct bonding *bond);
 void bond_change_active_slave(struct bonding *bond, struct slave *new_active);
 void bond_register_arp(struct bonding *);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
bonding-bond_mainc-make-2-functions-static.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
