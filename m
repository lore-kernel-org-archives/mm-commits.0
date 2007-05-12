From: akpm@linux-foundation.org
Subject: - upper-32-bits.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:03 -0700
Message-ID: <200705120515.l4C5F3ef001725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbXELFPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@SteelEye.com, Mike.Miller@hp.com, Steve.Cameron@hp.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     add upper-32-bits macro
has been removed from the -mm tree.  Its filename was
     upper-32-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add upper-32-bits macro
From: Andrew Morton <akpm@linux-foundation.org>

We keep on getting "right shift count >= width of type" warnings when doing
things like

	sector_t s;

	x = s >> 56;

because with CONFIG_LBD=n, s is only 32-bit.  Similar problems can occur with
dma_addr_t's.

So add a simple wrapper function which code can use to avoid this warning. 
The above example would become

	x = upper_32_bits(s) >> 24;

The first user is in fact AFS.

Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/kernel.h~upper-32-bits include/linux/kernel.h
--- a/include/linux/kernel.h~upper-32-bits
+++ a/include/linux/kernel.h
@@ -41,6 +41,16 @@ extern const char linux_proc_banner[];
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
+/**
+ * upper_32_bits - return bits 32-63 of a number
+ * @n: the number we're accessing
+ *
+ * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
+ * the "right shift count >= width of type" warning when that quantity is
+ * 32-bits.
+ */
+#define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
pm3fb-preliminary-24-to-26-port.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
arm-stacktrace-fix.patch
git-avr32.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect.patch
git-leds.patch
git-leds-fixup.patch
git-libata-all-sata_via-build-fix.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
netxen_nic_main-dont-use-deprecated-irq-flags.patch
mlx4-dont-use-deprecated-irq-flags.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
