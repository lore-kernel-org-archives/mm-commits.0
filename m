From: akpm@linux-foundation.org
Subject: +
 kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch added to -mm tree
Date: Mon, 11 Jul 2016 14:41:03 -0700
Message-ID: <5784126f.t5xNCETsC2nAzigN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbcGKVlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 17:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, bhe@redhat.com, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, mhiramat@kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: use core_param for crash_kexec_post_notifiers boot option
has been added to the -mm tree.  Its filename is
     kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-use-core_param-for-crash_kexec_post_notifiers-boot-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -134,6 +134,7 @@ void panic(const char *fmt, ...)
 	long i, i_next = 0;
 	int state = 0;
 	int old_cpu, this_cpu;
+	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
@@ -186,7 +187,7 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (!crash_kexec_post_notifiers) {
+	if (!_crash_kexec_post_notifiers) {
 		printk_nmi_flush_on_panic();
 		__crash_kexec(NULL);
 	}
@@ -212,7 +213,7 @@ void panic(const char *fmt, ...)
 	 *
 	 * Bypass the panic_cpu check and call __crash_kexec directly.
 	 */
-	if (crash_kexec_post_notifiers)
+	if (_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
 	bust_spinlocks(0);
@@ -592,13 +593,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
