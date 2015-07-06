From: akpm@linux-foundation.org
Subject: [merged]
 kernel-panic-call-the-2nd-crash_kexec-only-if-crash_kexec_post_notifiers-is-enabled.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:44 -0700
Message-ID: <559adb24.vryLAl2ljfXiQhxA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbbGFTqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, bhe@redhat.com, ebiederm@xmission.com, hidehiro.kawai.ez@hitachi.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic: call the 2nd crash_kexec() only if crash_kexec_post_notifiers is enabled
has been removed from the -mm tree.  Its filename was
     kernel-panic-call-the-2nd-crash_kexec-only-if-crash_kexec_post_notifiers-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: kernel/panic: call the 2nd crash_kexec() only if crash_kexec_post_notifiers is enabled

For compatibility with the behaviour before the commit f06e5153f4ae2e
("kernel/panic.c: add "crash_kexec_post_notifiers" option for kdump after
panic_notifers"), the 2nd crash_kexec() should be called only if
crash_kexec_post_notifiers is enabled.

Note that crash_kexec() returns immediately if kdump crash kernel is not
loaded, so in this case, this patch makes no functionality change, but the
point is to make it explicit, from the caller panic() side, that the 2nd
crash_kexec() does nothing.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~kernel-panic-call-the-2nd-crash_kexec-only-if-crash_kexec_post_notifiers-is-enabled kernel/panic.c
--- a/kernel/panic.c~kernel-panic-call-the-2nd-crash_kexec-only-if-crash_kexec_post_notifiers-is-enabled
+++ a/kernel/panic.c
@@ -142,7 +142,8 @@ void panic(const char *fmt, ...)
 	 * Note: since some panic_notifiers can make crashed kernel
 	 * more unstable, it can increase risks of the kdump failure too.
 	 */
-	crash_kexec(NULL);
+	if (crash_kexec_post_notifiers)
+		crash_kexec(NULL);
 
 	bust_spinlocks(0);
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

kdump-vmcoreinfo-report-actual-value-of-phys_base.patch

