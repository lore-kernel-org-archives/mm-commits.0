From: akpm@linux-foundation.org
Subject: +
 fanotify-enable-close-on-exec-on-events-fd-when-requested-in-fanotify_init.patch added to -mm tree
Date: Fri, 03 Oct 2014 12:20:06 -0700
Message-ID: <542ef6e6.DAlKMMWdpb368IsF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJCTUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:20:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, LinoSanfilippo@gmx.de, P@draigBrady.com, Valdis.Kletnieks@vt.edu, eparis@redhat.com, jack@suse.cz, mihai.dontu@gmail.com, mtk.manpages@gmail.com, rgb@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: enable close-on-exec on events' fd when request=
ed in fanotify_init()
has been added to the -mm tree.  Its filename is
     fanotify-enable-close-on-exec-on-events-fd-when-requested-in-fanot=
ify_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-enable-close-on-e=
xec-on-events-fd-when-requested-in-fanotify_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-enable-close-on-e=
xec-on-events-fd-when-requested-in-fanotify_init.patch

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
=46rom: Yann Droneaud <ydroneaud@opteya.com>
Subject: fanotify: enable close-on-exec on events' fd when requested in=
 fanotify_init()

According to commit 80af258867648 ("fanotify: groups can specify their
f_flags for new fd"), file descriptors created as part of file access
notification events inherit flags from the event_f_flags argument passe=
d
to syscall fanotify_init(2)[1].

Unfortunately O_CLOEXEC is currently silently ignored.

Indeed, event_f_flags are only given to dentry_open(), which only seems=
 to
care about O_ACCMODE and O_PATH in do_dentry_open(), O_DIRECT in
open_check_o_direct() and O_LARGEFILE in generic_file_open().

It's a pity, since, according to some lookup on various search engines =
and
http://codesearch.debian.net/, there's already some userspace code whic=
h
use O_CLOEXEC:

- in systemd's readahead[2]:

    fanotify_fd =3D fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_=
LARGEFILE|O_CLOEXEC|O_NOATIME);

- in clsync[3]:

    #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)

    int fanotify_d =3D fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);

- in examples [4] from "Filesystem monitoring in the Linux
  kernel" article[5] by Aleksander Morgado:

    if ((fanotify_fd =3D fanotify_init (FAN_CLOEXEC,
                                      O_RDONLY | O_CLOEXEC | O_LARGEFIL=
E)) < 0)

Additionally, since commit 48149e9d3a7e ("fanotify: check file flags
passed in fanotify_init").  having O_CLOEXEC as part of fanotify_init()
second argument is expressly allowed.

So it seems expected to set close-on-exec flag on the file descriptors =
if
userspace is allowed to request it with O_CLOEXEC.

But Andrew Morton raised[6] the concern that enabling now close-on-exec
might break existing applications which ask for O_CLOEXEC but expect th=
e
file descriptor to be inherited across exec().

In the other hand, as reported by Mihai Dontu[7] close-on-exec on the f=
ile
descriptor returned as part of file access notify can break application=
s
due to deadlock.  So close-on-exec is needed for most applications.

More, applications asking for close-on-exec are likely expecting it to =
be
enabled, relying on O_CLOEXEC being effective.  If not, it might weaken
their security, as noted by Jan Kara[8].

So this patch replaces call to macro get_unused_fd() by a call to funct=
ion
get_unused_fd_flags() with event_f_flags value as argument.  This way
O_CLOEXEC flag in the second argument of fanotify_init(2) syscall is
interpreted and close-on-exec get enabled when requested.

[1] http://man7.org/linux/man-pages/man2/fanotify_init.2.html
[2] http://cgit.freedesktop.org/systemd/systemd/tree/src/readahead/read=
ahead-collect.c?id=3Dv208#n294
[3] https://github.com/xaionaro/clsync/blob/v0.2.1/sync.c#L1631
    https://github.com/xaionaro/clsync/blob/v0.2.1/configuration.h#L38
[4] http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
[5] http://www.lanedo.com/2013/filesystem-monitoring-linux-kernel/
[6] http://lkml.kernel.org/r/20141001153621.65e9258e65a6167bf2e4cb50@li=
nux-foundation.org
[7] http://lkml.kernel.org/r/20141002095046.3715eb69@mdontu-l
[8] http://lkml.kernel.org/r/20141002104410.GB19748@quack.suse.cz

Link: http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.co=
m
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Tested-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mihai Don\u021bu <mihai.dontu@gmail.com>
Cc: P=E1draig Brady <P@draigBrady.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-enable-close-on-e=
xec-on-events-fd-when-requested-in-fanotify_init fs/notify/fanotify/fan=
otify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-enable-close-on-exec-=
on-events-fd-when-requested-in-fanotify_init
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -78,7 +78,7 @@ static int create_fd(struct fsnotify_gro
=20
 	pr_debug("%s: group=3D%p event=3D%p\n", __func__, group, event);
=20
-	client_fd =3D get_unused_fd();
+	client_fd =3D get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
=20
_

Patches currently in -mm which might be from ydroneaud@opteya.com are

fanotify-enable-close-on-exec-on-events-fd-when-requested-in-fanotify_i=
nit.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
