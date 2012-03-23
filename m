From: akpm@linux-foundation.org
Subject: [folded] procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:31:58 -0700
Message-ID: <20120323213159.1141FA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51093 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2CWVcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:32:01 -0400
Received: by eaaq10 with SMTP id q10so188458eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:32:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, eric.dumazet@gmail.com, glommer@parallels.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, pjt@google.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-num_to_str-to-speed-up-proc-stat-fix
has been removed from the -mm tree.  Its filename was
     procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch

This patch was dropped because it was folded into procfs-add-num_to_str-to-speed-up-proc-stat.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -313,12 +313,6 @@ extern long long simple_strtoll(const ch
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
@@ -122,10 +122,8 @@ int single_release(struct inode *, struc
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

