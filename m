From: akpm@linux-foundation.org
Subject: + include-linux-msdos_fsh-cleanup-include-linux-msdos_fsh-for-userspace.patch added to -mm tree
Date: Mon, 30 Jun 2008 13:44:35 -0700
Message-ID: <200806302044.m5UKiZLv024543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbYF3Upi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 16:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, fseidel@suse.de, hirofumi@mail.parknet.co.jp, onur@pardus.org.tr


The patch titled
     include/linux/msdos_fs.h: cleanup include/linux/msdos_fs.h for use=
rspace
has been added to the -mm tree.  Its filename is
     include-linux-msdos_fsh-cleanup-include-linux-msdos_fsh-for-usersp=
ace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: include/linux/msdos_fs.h: cleanup include/linux/msdos_fs.h for=
 userspace
=46rom: S.Caglar Onur <caglar@pardus.org.tr>

include/linux/msdos_fs.h header should use __u## rather than u## types
else any userspace code (like syslinux) includes that header fails to
compile like following;

[...]
gcc -Wp,-MT,bootsect_bin.o,-MMD,.bootsect_bin.o.d -W -Wall -D_FILE_OFFS=
ET_BITS=3D64 -g -Os -I. -I.. -I../libinstaller -c -o bootsect_bin.o ../=
bootsect_bin.c
gcc -Wp,-MT,ldlinux_bin.o,-MMD,.ldlinux_bin.o.d -W -Wall -D_FILE_OFFSET=
_BITS=3D64 -g -Os -I. -I.. -I../libinstaller -c -o ldlinux_bin.o ../ldl=
inux_bin.c
In file included from syslinux.c:52:
/usr/include/linux/msdos_fs.h:61: error: expected ')' before 'media'
[...]

Noticed by Onur K=C3=BC=C3=A7=C3=BCk <onur@pardus.org.tr>

Cc: Frank Seidel <fseidel@suse.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Onur K=C3=BC=C3=A7=C3=BCk <onur@pardus.org.tr>
Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msdos_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/msdos_fs.h~include-linux-msdos_fsh-cleanup-incl=
ude-linux-msdos_fsh-for-userspace include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~include-linux-msdos_fsh-cleanup-include-=
linux-msdos_fsh-for-userspace
+++ a/include/linux/msdos_fs.h
@@ -328,7 +328,7 @@ static inline void fatwchar_to16(__u8 *d
 }
=20
 /* media of boot sector */
-static inline int fat_valid_media(u8 media)
+static inline int fat_valid_media(__u8 media)
 {
 	return 0xf8 <=3D media || media =3D=3D 0xf0;
 }
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

include-linux-msdos_fsh-cleanup-include-linux-msdos_fsh-for-userspace.p=
atch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
