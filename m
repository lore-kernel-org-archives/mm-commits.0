From: akpm@linux-foundation.org
Subject: [patch 084/111] kexec: use core_param for
 crash_kexec_post_notifiers boot option
Date: Tue, 02 Aug 2016 14:06:13 -0700
Message-ID: <57a10b45.5rBCLegIIEywt/g2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbcHBVXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com, bhe@redhat.com, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, mhiramat@kernel.org, vgoyal@redhat.com

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: kexec: use core_param for crash_kexec_post_notifiers boot option

crash_kexec_post_notifiers ia a boot option which controls whether the 1st
kernel calls panic notifiers or not before booting the 2nd kernel. 
However, there is no need to limit it to being modifiable only at boot
time.  So, use core_param instead of early_param.

Link: http://lkml.kernel.org/r/20160705113327.5864.43139.stgit@softrs
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN kernel/panic.c~kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option kernel/panic.c
--- a/kernel/panic.c~kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option
+++ a/kernel/panic.c
@@ -108,6 +108,7 @@ void panic(const char *fmt, ...)
 	long i, i_next = 0;
 	int state = 0;
 	int old_cpu, this_cpu;
+	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
@@ -160,7 +161,7 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!crash_kexec_post_notifiers) {
+	if (!_crash_kexec_post_notifiers) {
 		printk_nmi_flush_on_panic();
 		__crash_kexec(NULL);
 	}
@@ -191,7 +192,7 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (crash_kexec_post_notifiers)
+	if (_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
 	bust_spinlocks(0);
@@ -571,13 +572,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
