From: akpm@linux-foundation.org
Subject: + um-drivers-xtermc-fix-a-file-descriptor-leak.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:34 -0700
Message-ID: <201108292135.p7TLZYQf030254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab1H2VgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:36:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.neuschaefer@gmx.net, richard@nod.at


The patch titled
     um: drivers/xterm.c: fix a file descriptor leak
has been added to the -mm tree.  Its filename is
     um-drivers-xtermc-fix-a-file-descriptor-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: um: drivers/xterm.c: fix a file descriptor leak
=46rom: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>

I could use out_close1, but that seems to be the code path to close the=
 fd
returned by os_create_unix_socket, and using it to close the fd returne=
d
by mkstemp might lead to some confusion, so I don't do it.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/xterm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/xterm.c~um-drivers-xtermc-fix-a-file-descript=
or-leak arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~um-drivers-xtermc-fix-a-file-descriptor-l=
eak
+++ a/arch/um/drivers/xterm.c
@@ -123,6 +123,7 @@ static int xterm_open(int input, int out
 		err =3D -errno;
 		printk(UM_KERN_ERR "xterm_open : unlink failed, errno =3D %d\n",
 		       errno);
+		close(fd);
 		return err;
 	}
 	close(fd);
_

Patches currently in -mm which might be from j.neuschaefer@gmx.net are

um-drivers-xtermc-fix-a-file-descriptor-leak.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
