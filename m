From: akpm@linux-foundation.org
Subject: [merged] eventpoll-fix-uninitialized-variable-in-epoll_ctl.patch
 removed from -mm tree
Date: Fri, 12 Sep 2014 13:13:00 -0700
Message-ID: <541353cc.RjQXkzK/UK0Qqu/F%akpm__35976.1976906613$1410552803$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaILUNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, arve@android.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: eventpoll: fix uninitialized variable in epoll_ctl
has been removed from the -mm tree.  Its filename was
     eventpoll-fix-uninitialized-variable-in-epoll_ctl.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: eventpoll: fix uninitialized variable in epoll_ctl

When calling epoll_ctl with operation EPOLL_CTL_DEL, structure epds is =
not
initialized but ep_take_care_of_epollwakeup reads its event field.  Whe=
n
this unintialized field has EPOLLWAKEUP bit set, a capability check is
done for CAP_BLOCK_SUSPEND in ep_take_care_of_epollwakeup.  This produc=
es
unexpected messages in the audit log, such as (on a system running
SELinux):

    type=3DAVC msg=3Daudit(1408212798.866:410): avc:  denied
    { block_suspend } for  pid=3D7754 comm=3D"dbus-daemon" capability=3D=
36
    scontext=3Dunconfined_u:unconfined_r:unconfined_t
    tcontext=3Dunconfined_u:unconfined_r:unconfined_t
    tclass=3Dcapability2 permissive=3D1

    type=3DSYSCALL msg=3Daudit(1408212798.866:410): arch=3Dc000003e sys=
call=3D233
    success=3Dyes exit=3D0 a0=3D3 a1=3D2 a2=3D9 a3=3D7fffd4d66ec0 items=
=3D0 ppid=3D1
    pid=3D7754 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 =
egid=3D0 sgid=3D0
    fsgid=3D0 tty=3D(none) ses=3D3 comm=3D"dbus-daemon"
    exe=3D"/usr/bin/dbus-daemon"
    subj=3Dunconfined_u:unconfined_r:unconfined_t key=3D(null)

("arch=3Dc000003e syscall=3D233 a1=3D2" means "epoll_ctl(op=3DEPOLL_CTL=
_DEL)")

Remove use of epds in epoll_ctl when op =3D=3D EPOLL_CTL_DEL.

=46ixes: 4d7e30d98939 ("epoll: Add a flag, EPOLLWAKEUP, to prevent susp=
end while epoll events are ready")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~eventpoll-fix-uninitialized-variable-in-epoll_=
ctl fs/eventpoll.c
--- a/fs/eventpoll.c~eventpoll-fix-uninitialized-variable-in-epoll_ctl
+++ a/fs/eventpoll.c
@@ -1852,7 +1852,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 		goto error_tgt_fput;
=20
 	/* Check if EPOLLWAKEUP is allowed */
-	ep_take_care_of_epollwakeup(&epds);
+	if (ep_op_has_event(op))
+		ep_take_care_of_epollwakeup(&epds);
=20
 	/*
 	 * We have to check that the file structure underneath the file descr=
iptor
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.or=
g are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
