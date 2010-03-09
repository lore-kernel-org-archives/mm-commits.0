From: akpm@linux-foundation.org
Subject: + coredump-plug-a-memory-leak-situation-on-dump_seek.patch added to -mm tree
Date: Tue, 09 Mar 2010 11:38:52 -0800
Message-ID: <201003091938.o29JcrHq000712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab0CITjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:39:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, amwang@redhat.com, kosaki.motohiro@jp.fujitsu.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     coredump: plug a memory leak situation on dump_seek()
has been added to the -mm tree.  Its filename is
     coredump-plug-a-memory-leak-situation-on-dump_seek.patch

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
Subject: coredump: plug a memory leak situation on dump_seek()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

After having started writing the coredump, if filesystem reports an err=
or
anytime while writing part of the core file, we would leak a memory pag=
e
when bailing out.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/coredump.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/coredump.h~coredump-plug-a-memory-leak-situatio=
n-on-dump_seek include/linux/coredump.h
--- a/include/linux/coredump.h~coredump-plug-a-memory-leak-situation-on=
-dump_seek
+++ a/include/linux/coredump.h
@@ -16,6 +16,8 @@ static inline int dump_write(struct file
=20
 static inline int dump_seek(struct file *file, loff_t off)
 {
+	int ret =3D 1;
+
 	if (file->f_op->llseek && file->f_op->llseek !=3D no_llseek) {
 		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
@@ -29,13 +31,15 @@ static inline int dump_seek(struct file=20
=20
 			if (n > PAGE_SIZE)
 				n =3D PAGE_SIZE;
-			if (!dump_write(file, buf, n))
-				return 0;
+			if (!dump_write(file, buf, n)) {
+				ret =3D 0;
+				break;
+			}
 			off -=3D n;
 		}
 		free_page((unsigned long)buf);
 	}
-	return 1;
+	return ret;
 }
=20
 #endif /* _LINUX_COREDUMP_H */
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch
coredump-plug-a-memory-leak-situation-on-dump_seek.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
