From: akpm@linux-foundation.org
Subject: + binfmt_elf-plug-a-memory-leak-situation-on-dump_seek.patch added to -mm tree
Date: Tue, 02 Mar 2010 12:43:06 -0800
Message-ID: <201003022043.o22Kh6IR028511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab0CBUnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 15:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com


The patch titled
     binfmt_elf: plug a memory leak situation on dump_seek()
has been added to the -mm tree.  Its filename is
     binfmt_elf-plug-a-memory-leak-situation-on-dump_seek.patch

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
Subject: binfmt_elf: plug a memory leak situation on dump_seek()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

-ENOCHANELOG

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-plug-a-memory-leak-situation-on-du=
mp_seek fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-plug-a-memory-leak-situation-on-dump_s=
eek
+++ a/fs/binfmt_elf.c
@@ -1096,6 +1096,8 @@ static int dump_write(struct file *file,
=20
 static int dump_seek(struct file *file, loff_t off)
 {
+	int ret =3D 1;
+
 	if (file->f_op->llseek && file->f_op->llseek !=3D no_llseek) {
 		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
@@ -1107,13 +1109,15 @@ static int dump_seek(struct file *file,=20
 			unsigned long n =3D off;
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
 /*
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch
mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.patch
mqueue-remove-unneeded-info-messages-initialization.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpa=
tch-fixes.patch
mqueue-simplify-do_open-error-handling.patch
mqueue-only-set-error-codes-if-they-are-really-necessary.patch
mqueue-fix-typo-failues-failures.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
binfmt_elf-plug-a-memory-leak-situation-on-dump_seek.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
