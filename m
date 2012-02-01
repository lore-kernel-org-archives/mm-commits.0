From: akpm@linux-foundation.org
Subject: + fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch added to -mm tree
Date: Wed, 01 Feb 2012 15:22:59 -0800
Message-ID: <20120201232259.A8935A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:64918 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2BAXXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 18:23:00 -0500
Received: by ghrr17 with SMTP id r17so194574ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 15:23:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, richard@nod.at


The patch titled
     Subject: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty
has been added to the -mm tree.  Its filename is
     fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty

If CONFIG_NET_NS, CONFIG_UTS_NS and CONFIG_IPC_NS are disabled,
ns_entries[] becomes empty and things like
ns_entries[ARRAY_SIZE(ns_entries) - 1] will explode.

Reported-by: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/namespaces.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/namespaces.c~fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty fs/proc/namespaces.c
--- a/fs/proc/namespaces.c~fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty
+++ a/fs/proc/namespaces.c
@@ -156,15 +156,15 @@ static struct dentry *proc_ns_dir_lookup
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
-	last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
-	for (entry = ns_entries; entry <= last; entry++) {
+	last = &ns_entries[ARRAY_SIZE(ns_entries)];
+	for (entry = ns_entries; entry < last; entry++) {
 		if (strlen((*entry)->name) != len)
 			continue;
 		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
 			break;
 	}
 	error = ERR_PTR(-ENOENT);
-	if (entry > last)
+	if (entry == last)
 		goto out;
 
 	error = proc_ns_instantiate(dir, dentry, task, *entry);
_
Subject: Subject: fs/proc/namespaces.c: prevent crash when ns_entries[] is empty

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-cpufreq-gx-suspmodc-fix-build.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
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
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

