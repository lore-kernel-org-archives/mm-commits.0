From: akpm@linux-foundation.org
Subject: [merged]
 kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:47 -0700
Message-ID: <559adb27.XTsKUvUVgv/eBTlC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbbGFTqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, bhe@redhat.com, hidehiro.kawai.ez@hitachi.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic/kexec: fix "crash_kexec_post_notifiers" option issue in oops path
has been removed from the -mm tree.  Its filename was
     kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: kernel/panic/kexec: fix "crash_kexec_post_notifiers" option issue in oops path

Commit f06e5153f4ae2e ("kernel/panic.c: add "crash_kexec_post_notifiers"
option for kdump after panic_notifers") introduced
"crash_kexec_post_notifiers" kernel boot option, which toggles wheather
panic() calls crash_kexec() before panic_notifiers and dump kmsg or after.

The problem is that the commit overlooks panic_on_oops kernel boot option.
 If it is enabled, crash_kexec() is called directly without going through
panic() in oops path.

To fix this issue, this patch adds a check to "crash_kexec_post_notifiers"
in the condition of kexec_should_crash().

Also, put a comment in kexec_should_crash() to explain not obvious things
on this patch.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Baoquan He <bhe@redhat.com>
Tested-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 +++
 kernel/kexec.c         |   11 +++++++++++
 kernel/panic.c         |    2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path
+++ a/include/linux/kernel.h
@@ -439,6 +439,9 @@ extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int panic_on_warn;
 extern int sysctl_panic_on_stackoverflow;
+
+extern bool crash_kexec_post_notifiers;
+
 /*
  * Only to be used by arch init code. If the user over-wrote the default
  * CONFIG_PANIC_TIMEOUT, honor it.
diff -puN kernel/kexec.c~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path kernel/kexec.c
--- a/kernel/kexec.c~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path
+++ a/kernel/kexec.c
@@ -84,6 +84,17 @@ struct resource crashk_low_res = {
 
 int kexec_should_crash(struct task_struct *p)
 {
+	/*
+	 * If crash_kexec_post_notifiers is enabled, don't run
+	 * crash_kexec() here yet, which must be run after panic
+	 * notifiers in panic().
+	 */
+	if (crash_kexec_post_notifiers)
+		return 0;
+	/*
+	 * There are 4 panic() calls in do_exit() path, each of which
+	 * corresponds to each of these 4 conditions.
+	 */
 	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
 		return 1;
 	return 0;
diff -puN kernel/panic.c~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path kernel/panic.c
--- a/kernel/panic.c~kernel-panic-kexec-fix-crash_kexec_post_notifiers-option-issue-in-oops-path
+++ a/kernel/panic.c
@@ -32,7 +32,7 @@ static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
-static bool crash_kexec_post_notifiers;
+bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

kdump-vmcoreinfo-report-actual-value-of-phys_base.patch

