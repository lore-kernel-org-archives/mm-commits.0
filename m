From: akpm@linux-foundation.org
Subject: [merged]
 kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:34:47 -0700
Message-ID: <53960c57.eQ2i9eAyNunnrlNP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaFITes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yoshihiro.yunomae.ez@hitachi.com, vgoyal@redhat.com, tomoki.sekiyama@hds.com, satoru.moriya.br@hitachi.com, ebiederm@xmission.com, Motohiro.Kosaki@us.fujitsu.com, masami.hiramatsu.pt@hitachi.com

Subject: [merged] kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers.patch removed from -mm tree
To: masami.hiramatsu.pt@hitachi.com,Motohiro.Kosaki@us.fujitsu.com,ebiederm@xmission.com,satoru.moriya.br@hitachi.com,tomoki.sekiyama@hds.com,vgoyal@redhat.com,yoshihiro.yunomae.ez@hitachi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:34:47 -0700


The patch titled
     Subject: kernel/panic.c: add "crash_kexec_post_notifiers" option for kdump after panic_notifers
has been removed from the -mm tree.  Its filename was
     kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: kernel/panic.c: add "crash_kexec_post_notifiers" option for kdump after panic_notifers

Add a "crash_kexec_post_notifiers" boot option to run kdump after running
panic_notifiers and dump kmsg.  This can help rare situations where kdump
fails because of unstable crashed kernel or hardware failure (memory
corruption on critical data/code), or the 2nd kernel is already broken by
the 1st kernel (it's a broken behavior, but who can guarantee that the
"crashed" kernel works correctly?).

Usage: add "crash_kexec_post_notifiers" to kernel boot option.

Note that this actually increases risks of the failure of kdump.
This option should be set only if you worry about the rare case
of kdump failure rather than increasing the chance of success.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++++++
 kernel/panic.c                      |   23 +++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers
+++ a/Documentation/kernel-parameters.txt
@@ -2361,6 +2361,14 @@ bytes respectively. Such letter suffixes
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	crash_kexec_post_notifiers
+			Run kdump after running panic-notifiers and dumping
+			kmsg. This only for the users who doubt kdump always
+			succeeds in any situation.
+			Note that this also increases risks of kdump failure,
+			because some panic notifiers can make the crashed
+			kernel more unstable.
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
diff -puN kernel/panic.c~kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-add-crash_kexec_post_notifiers-option-for-kdump-after-panic_notifers
+++ a/kernel/panic.c
@@ -32,6 +32,7 @@ static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
+static bool crash_kexec_post_notifiers;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -112,9 +113,11 @@ void panic(const char *fmt, ...)
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
-	 * Do we want to call this before we try to display a message?
+	 * If we want to run this after calling panic_notifiers, pass
+	 * the "crash_kexec_post_notifiers" option to the kernel.
 	 */
-	crash_kexec(NULL);
+	if (!crash_kexec_post_notifiers)
+		crash_kexec(NULL);
 
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
@@ -131,6 +134,15 @@ void panic(const char *fmt, ...)
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
+	/*
+	 * If you doubt kdump always works fine in any situation,
+	 * "crash_kexec_post_notifiers" offers you a chance to run
+	 * panic_notifiers and dumping kmsg before kdump.
+	 * Note: since some panic_notifiers can make crashed kernel
+	 * more unstable, it can increase risks of the kdump failure too.
+	 */
+	crash_kexec(NULL);
+
 	bust_spinlocks(0);
 
 	if (!panic_blink)
@@ -472,6 +484,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init setup_crash_kexec_post_notifiers(char *s)
+{
+	crash_kexec_post_notifiers = true;
+	return 0;
+}
+early_param("crash_kexec_post_notifiers", setup_crash_kexec_post_notifiers);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
_

Patches currently in -mm which might be from masami.hiramatsu.pt@hitachi.com are

origin.patch
linux-next.patch

