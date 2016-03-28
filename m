From: akpm@linux-foundation.org
Subject: +
 wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch added to
 -mm tree
Date: Mon, 28 Mar 2016 15:51:32 -0700
Message-ID: <56f9b574.Y+ae6eg9xYnL45hE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbcC1Wve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 18:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, dvyukov@google.com, jan.kratochvil@redhat.com, mtk.manpages@gmail.com, palves@redhat.com, roland@hack.frob.com, syzkaller@googlegroups.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: wait: allow sys_waitid() to accept __WNOTHREAD/__WCLONE/__WALL
has been added to the -mm tree.  Its filename is
     wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: allow sys_waitid() to accept __WNOTHREAD/__WCLONE/__WALL

I see no reason why waitid() can't support other linux-specific flags
allowed in sys_wait4().

In particular this change can help if we reconsider the previous change
("wait/ptrace: assume __WALL if the child is traced") which adds the
"automagical" __WALL for debugger.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: <syzkaller@googlegroups.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall kernel/exit.c
--- a/kernel/exit.c~wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall
+++ a/kernel/exit.c
@@ -1535,7 +1535,8 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 	enum pid_type type;
 	long ret;
 
-	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
+	if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED|
+			__WNOTHREAD|__WCLONE|__WALL))
 		return -EINVAL;
 	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
 		return -EINVAL;
_

Patches currently in -mm which might be from oleg@redhat.com are

wait-ptrace-assume-__wall-if-the-child-is-traced.patch
wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch

