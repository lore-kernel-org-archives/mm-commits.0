From: akpm@linux-foundation.org
Subject: - lib-hexdump-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 03:33:02 -0700
Message-ID: <200705091033.l49AX22T021461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573AbXEIKdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib-hexdump-fix
has been removed from the -mm tree.  Its filename was
     lib-hexdump-fix.patch

This patch was dropped because it was folded into lib-hexdump.patch

------------------------------------------------------
Subject: lib-hexdump-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 lib/hexdump.c          |    5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~lib-hexdump-fix include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdump-fix
+++ a/include/linux/kernel.h
@@ -218,7 +218,8 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen);
+extern void hex_dumper(const void *buf, size_t len, char *linebuf,
+				size_t linebuflen);
 extern void print_hex_dump(const char *level, int prefix_type,
 				void *buf, size_t len);
 #define hextoasc(x)	"0123456789abcdef"[x]
diff -puN lib/hexdump.c~lib-hexdump-fix lib/hexdump.c
--- a/lib/hexdump.c~lib-hexdump-fix
+++ a/lib/hexdump.c
@@ -32,7 +32,7 @@
  * Prints the offsets of the block of memory, not addresses:
  * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
  */
-void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen)
+void hex_dumper(const void *buf, size_t len, char *linebuf, size_t linebuflen)
 {
 	const u8 *ptr = buf;
 	u8 ch;
@@ -87,8 +87,7 @@ void print_hex_dump(const char *level, i
 		remaining -= 16;
 		hex_dumper(ptr + i, linelen, linebuf, sizeof(linebuf));
 
-		switch (prefix_type)
-		{
+		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
 			printk("%s%*p: %s\n", level,
 				(int)(2 * sizeof(void *)), ptr + i, linebuf);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump.patch
lib-hexdump-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
