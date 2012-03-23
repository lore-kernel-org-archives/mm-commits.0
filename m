From: akpm@linux-foundation.org
Subject: [folded] kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:20:53 -0700
Message-ID: <20120323212053.6F325A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61711 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CWVUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:20:54 -0400
Received: by qabg24 with SMTP id g24so150646qab.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:20:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
has been removed from the -mm tree.  Its filename was
     kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch

This patch was dropped because it was folded into kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix

add 0x to hex number output

Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
+++ a/kernel/exit.c
@@ -712,7 +712,7 @@ static struct task_struct *find_new_reap
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
 		if (unlikely(pid_ns == &init_pid_ns)) {
-			panic("Attempted to kill init! exitcode=%08x\n",
+			panic("Attempted to kill init! exitcode=0x%08x\n",
 				father->signal->group_exit_code ?:
 					father->exit_code);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

