From: akpm@linux-foundation.org
Subject: [merged] um-drivers-xtermc-fix-a-file-descriptor-leak.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:32 -0700
Message-ID: <201109151935.p8FJZWTR024915@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591Ab1IOTf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j.neuschaefer@gmx.net, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: drivers/xterm.c: fix a file descriptor leak
has been removed from the -mm tree.  Its filename was
     um-drivers-xtermc-fix-a-file-descriptor-leak.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: um: drivers/xterm.c: fix a file descriptor leak
=46rom: Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>

I could use out_close1, but that seems to be the code path to close the=
 fd
returned by os_create_unix_socket, and using it to close the fd returne=
d
by mkstemp might lead to some confusion, so I don't do it.

Signed-off-by: Jonathan Neusch=E4fer <j.neuschaefer@gmx.net>
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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
