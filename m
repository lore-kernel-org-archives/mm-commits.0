From: akpm@linux-foundation.org
Subject: +
 arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch added to
 -mm tree
Date: Thu, 30 May 2013 15:27:36 -0700
Message-ID: <51a7d258.7JicpOWRqxvnpIuq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3E3W1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, gang.chen@asianux.com

Subject: + arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch added to -mm tree
To: gang.chen@asianux.com,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:27:36 -0700


The patch titled
     Subject: arch/frv/kernel/traps.c: using vsnprintf() instead of vsprintf()
has been added to the -mm tree.  Its filename is
     arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch/frv/kernel/traps.c: using vsnprintf() instead of vsprintf()

Since die_if_kernel() is an extern common used function, better always
check the buffer length to avoid memory overflow by a long 'str'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/frv/kernel/traps.c~arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf
+++ a/arch/frv/kernel/traps.c
@@ -523,7 +523,7 @@ void die_if_kernel(const char *str, ...)
 		return;
 
 	va_start(va, str);
-	vsprintf(buffer, str, va);
+	vsnprintf(buffer, sizeof(buffer), str, va);
 	va_end(va);
 
 	console_verbose();
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w.patch
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
vfs-fix-invalid-ida_remove-call.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch

