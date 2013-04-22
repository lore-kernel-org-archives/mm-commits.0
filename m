From: akpm@linux-foundation.org
Subject: [merged] signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:07:01 -0700
Message-ID: <20130422200701.9445A31C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57735 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3DVUHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:07:04 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so733307vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:07:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: re.emese@gmail.com, ebiederm@xmission.com, keescook@chromium.org, oleg@redhat.com, pageexec@freemail.hu, serge.hallyn@canonical.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
has been removed from the -mm tree.  Its filename was
     signal-stop-info-leak-via-the-tkill-and-the-tgkill-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2948,7 +2948,7 @@ do_send_specific(pid_t tgid, pid_t pid,
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;
_

Patches currently in -mm which might be from re.emese@gmail.com are


