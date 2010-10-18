From: akpm@linux-foundation.org
Subject: + hostfs-fix-uml-crash.patch added to -mm tree
Date: Mon, 18 Oct 2010 11:37:53 -0700
Message-ID: <201010181837.o9IIb7av026956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757609Ab0JRSjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 14:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, hch@lst.de, jdike@addtoit.com, toralf.foerster@gmx.de, viro@zeniv.linux.org.uk


The patch titled
     hostfs: fix UML crash
has been added to the -mm tree.  Its filename is
     hostfs-fix-uml-crash.patch

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
Subject: hostfs: fix UML crash
=46rom: Richard Weinberger <richard@nod.at>

365b1818 ("add f_flags to struct statfs(64)") resized f_spare within
struct statfs.  hostfs accesses f_spare directly and needs an update.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Tested-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hostfs/hostfs_user.c~hostfs-fix-uml-crash fs/hostfs/hostfs=
_user.c
--- a/fs/hostfs/hostfs_user.c~hostfs-fix-uml-crash
+++ a/fs/hostfs/hostfs_user.c
@@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_ou
 	spare_out[1] =3D buf.f_spare[1];
 	spare_out[2] =3D buf.f_spare[2];
 	spare_out[3] =3D buf.f_spare[3];
-	spare_out[4] =3D buf.f_spare[4];
+
 	return 0;
 }
_

Patches currently in -mm which might be from richard@nod.at are

hostfs-fix-uml-crash.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
