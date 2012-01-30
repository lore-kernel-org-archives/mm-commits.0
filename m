From: akpm@linux-foundation.org
Subject: + procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch added to -mm tree
Date: Mon, 30 Jan 2012 15:21:09 -0800
Message-ID: <20120130232109.E9ABEA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:41402 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2A3XVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 18:21:12 -0500
Received: by faaa19 with SMTP id a19so226532faa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 15:21:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, eric.dumazet@gmail.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, pjt@google.com, rmk@arm.linux.org.uk


The patch titled
     Subject: procfs-add-num_to_str-to-speed-up-proc-stat-fix
has been added to the -mm tree.  Its filename is
     procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch

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
Subject: procfs-add-num_to_str-to-speed-up-proc-stat-fix

- remove incorrect comment
- use less statck in num_to_str()
- move comment from .h to .c
- simplify seq_put_decimal_ull()

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |    5 ++---
 include/linux/kernel.h   |    6 ------
 include/linux/seq_file.h |    4 +---
 lib/vsprintf.c           |    8 +++++++-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff -puN fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/fs/seq_file.c
@@ -659,14 +659,13 @@ int seq_put_decimal_ull(struct seq_file 
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
+	m->buf[m->count++] = delimiter;
+
 	if (num < 10) {
-		m->buf[m->count++] = delimiter;
 		m->buf[m->count++] = num + '0';
 		return 0;
 	}
 
-	m->buf[m->count++] = delimiter;
-
 	len = num_to_str(m->buf + m->count, m->size - m->count, num);
 	if (!len)
 		goto overflow;
diff -puN include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix include/linux/kernel.h
--- a/include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/include/linux/kernel.h
@@ -299,12 +299,6 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
-/*
- * Convert passed number to decimal string.
- * returns returns the length of string. at buffer overflow, returns 0.
- *
- * If speed is not important, use snprintf(). It's easy to read the code.
- */
 extern int num_to_str(char *buf, int size, unsigned long long num);
 
 /* lib/printf utilities */
diff -puN include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/include/linux/seq_file.h
@@ -121,10 +121,8 @@ int single_release(struct inode *, struc
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
-
-/* defined in lib/vsprintf.c */
 int seq_put_decimal_ull(struct seq_file *m, char delimiter,
-		unsigned long long num);
+			unsigned long long num);
 
 #define SEQ_START_TOKEN ((void *)1)
 /*
diff -puN lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix lib/vsprintf.c
--- a/lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat-fix
+++ a/lib/vsprintf.c
@@ -212,9 +212,15 @@ char *put_dec(char *buf, unsigned long l
 	}
 }
 
+/*
+ * Convert passed number to decimal string.
+ * Returns the length of string.  On buffer overflow, returns 0.
+ *
+ * If speed is not important, use snprintf(). It's easy to read the code.
+ */
 int num_to_str(char *buf, int size, unsigned long long num)
 {
-	char tmp[66];
+	char tmp[21];		/* Enough for 2^64 in decimal */
 	int idx, len;
 
 	len = put_dec(tmp, num) - tmp;
_
Subject: Subject: procfs-add-num_to_str-to-speed-up-proc-stat-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

