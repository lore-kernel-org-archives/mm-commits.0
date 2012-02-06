From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-fix-warning-with-config_numa=n.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:23 -0800
Message-ID: <20120206203123.7356CA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49197 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2BFUb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:26 -0500
Received: by bkas6 with SMTP id s6so263412bka.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, lizf@cn.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix warning with CONFIG_NUMA=n
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-fix-warning-with-config_numa=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: fix warning with CONFIG_NUMA=n

mm/memcontrol.c: In function 'memcg_check_events':
mm/memcontrol.c:779: warning: unused variable 'do_numainfo'

Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-fix-warning-with-config_numa=n mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-fix-warning-with-config_numa=n
+++ a/mm/memcontrol.c
@@ -776,7 +776,8 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit, do_numainfo;
+		bool do_softlimit;
+		bool do_numainfo __maybe_unused;
 
 		do_softlimit = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_SOFTLIMIT);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
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
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
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

