From: akpm@linux-foundation.org
Subject: [folded] thermal-thermal_sys-fix-build-warning-fix.patch removed from -mm tree
Date: Wed, 08 Feb 2012 12:49:23 -0800
Message-ID: <20120208204924.23DC4A03DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52517 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2BHUtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 15:49:25 -0500
Received: by ggnp1 with SMTP id p1so102147ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 12:49:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, durgadoss.r@intel.com, fabio.estevam@freescale.com, festevam@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal-thermal_sys-fix-build-warning-fix
has been removed from the -mm tree.  Its filename was
     thermal-thermal_sys-fix-build-warning-fix.patch

This patch was dropped because it was folded into thermal-thermal_sys-fix-build-warning.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thermal-thermal_sys-fix-build-warning-fix

make thermal_event_seqnum local to generate_netlink_event()

Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning-fix drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-thermal_sys-fix-build-warning-fix
+++ a/drivers/thermal/thermal_sys.c
@@ -1302,8 +1302,6 @@ static struct genl_multicast_group therm
 	.name = THERMAL_GENL_MCAST_GROUP_NAME,
 };
 
-static unsigned int thermal_event_seqnum;
-
 int thermal_generate_netlink_event(u32 orig, enum events event)
 {
 	struct sk_buff *skb;
@@ -1312,6 +1310,7 @@ int thermal_generate_netlink_event(u32 o
 	void *msg_header;
 	int size;
 	int result;
+	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
 	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
fs-btrfs-inode-mapc-fix-warnings.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

