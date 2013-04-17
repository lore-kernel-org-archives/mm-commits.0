From: akpm@linux-foundation.org
Subject: + signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls.patch added to -mm tree
Date: Wed, 17 Apr 2013 13:45:51 -0700
Message-ID: <20130417204551.98FFE3261B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53004 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3DQUpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 16:45:55 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so207846qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 13:45:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: re.emese@gmail.com, ebiederm@xmission.com, keescook@chromium.org, oleg@redhat.com, pageexec@freemail.hu, serge.hallyn@canonical.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
has been added to the -mm tree.  Its filename is
     signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Emese Revfy <re.emese@gmail.com>
Subject: kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

This fixes a kernel memory contents leak via the tkill and tgkill syscalls
for compat processes.

This is visible in the siginfo_t->_sifields._rt.si_sigval.sival_ptr field
when handling signals delivered from tkill.

The place of the infoleak:

int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
{
        ...
        put_user_ex(ptr_to_compat(from->si_ptr), &to->si_ptr);
        ...
}

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Reviewed-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls kernel/signal.c
--- a/kernel/signal.c~signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls
+++ a/kernel/signal.c
@@ -2949,7 +2949,7 @@ do_send_specific(pid_t tgid, pid_t pid,
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;
_

Patches currently in -mm which might be from re.emese@gmail.com are

signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls.patch

