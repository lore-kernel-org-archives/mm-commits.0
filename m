From: akpm@linux-foundation.org
Subject: + use-pid_t-instead-of-int.patch added to -mm tree
Date: Mon, 09 May 2016 14:22:18 -0700
Message-ID: <5730ff8a.hUomUavJP4ah2A55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcEIVWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@renenyffenegger.ch, arnd@arndb.de, josh@joshtriplett.org, luto@amacapital.net, milosz@adfin.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/syscalls.h: use pid_t instead of int
has been added to the -mm tree.  Its filename is
     use-pid_t-instead-of-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/use-pid_t-instead-of-int.p=
atch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/use-pid_t-instead-of-int.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ren=E9 Nyffenegger <mail@renenyffenegger.ch>
Subject: include/linux/syscalls.h: use pid_t instead of int

In include/linux/syscalls.h, the four functions sys_kill, sys_tgkill,
sys_tkill and sys_rt_sigqueueinfo are declared with "int pid" and
"int tgid".

However, in kernel/signal.c, the corresponding definitions use
the more appropriate "pid_t" (which is a typedef'd int).

This patch changes "int" to "pid_t" in the declarations of
sys_kill, sys_tgkill, sys_tkill and sys_rt_sigqueueinfo in
include/linux/syscalls.h in order to harmonize the function
declarations with their respective definitions.

Link: http://lkml.kernel.org/r/57302FDA.7020205@renenyffenegger.ch
Signed-off-by: Ren=E9 Nyffenegger <mail@renenyffenegger.ch>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: Zach Brown <zab@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/syscalls.h~use-pid_t-instead-of-int include/lin=
ux/syscalls.h
--- a/include/linux/syscalls.h~use-pid_t-instead-of-int
+++ a/include/linux/syscalls.h
@@ -371,10 +371,10 @@ asmlinkage long sys_rt_sigtimedwait(cons
 				size_t sigsetsize);
 asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
 		siginfo_t __user *uinfo);
-asmlinkage long sys_kill(int pid, int sig);
-asmlinkage long sys_tgkill(int tgid, int pid, int sig);
-asmlinkage long sys_tkill(int pid, int sig);
-asmlinkage long sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user=
 *uinfo);
+asmlinkage long sys_kill(pid_t pid, int sig);
+asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig);
+asmlinkage long sys_tkill(pid_t pid, int sig);
+asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __us=
er *uinfo);
 asmlinkage long sys_sgetmask(void);
 asmlinkage long sys_ssetmask(int newmask);
 asmlinkage long sys_signal(int sig, __sighandler_t handler);
_

Patches currently in -mm which might be from mail@renenyffenegger.ch ar=
e

use-pid_t-instead-of-int.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
