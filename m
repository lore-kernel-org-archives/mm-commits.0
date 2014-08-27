From: akpm@linux-foundation.org
Subject: + eventpoll-fix-uninitialized-variable-in-epoll_ctl.patch added
 to -mm tree
Date: Wed, 27 Aug 2014 15:12:41 -0700
Message-ID: <53fe57d9.1G+2axoypJ1r6gzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37427 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaH0WMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 18:12:42 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so110476qcx.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 15:12:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, arve@android.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: eventpoll: fix uninitialized variable in epoll_ctl
has been added to the -mm tree.  Its filename is
     eventpoll-fix-uninitialized-variable-in-epoll_ctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventpoll-fix-uninitialize=
d-variable-in-epoll_ctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventpoll-fix-uninitialize=
d-variable-in-epoll_ctl.patch

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

eventpoll-fix-uninitialized-variable-in-epoll_ctl.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
