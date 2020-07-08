From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch added to
 -mm tree
Date: Wed, 08 Jul 2020 14:48:37 -0700
Message-ID: <20200708214837._Z_p3muvk%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHVsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 17:48:38 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grandmaster@al2klimov.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: VFAT/FAT/MSDOS FILESYSTEM: Replace HTTP links with HTTPS ones=
=0D=0A=
has been added to the -mm tree.  Its filename is
     vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfat-fat-msdos-filesystem-repl=
ace-http-links-with-https-ones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfat-fat-msdos-filesystem-repl=
ace-http-links-with-https-ones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: "Alexander A. Klimov" <grandmaster@al2klimov.de>=0D=0A=
Subject: VFAT/FAT/MSDOS FILESYSTEM: Replace HTTP links with HTTPS ones=0D=
=0A=
=0D=0A=
Rationale:=0D=0A=
Reduces attack surface on kernel devs opening the links for MITM=0D=0A=
as HTTPS traffic is much harder to manipulate.=0D=0A=
=0D=0A=
Deterministic algorithm:=0D=0A=
For each file:=0D=0A=
  If not .svg:=0D=0A=
    For each line:=0D=0A=
      If doesn't contain `=08xmlns=08`:=0D=0A=
        For each link, `=08http://[^# 	=0D=0A=
]*(?:\w|/)`:=0D=0A=
	  If neither `=08gnu\.org/license`, nor `=08mozilla\.org/MPL=08`:=0D=0A=
            If both the HTTP and HTTPS versions=0D=0A=
            return 200 OK and serve the same content:=0D=0A=
              Replace HTTP with HTTPS.=0D=0A=
=0D=0A=
Link: http://lkml.kernel.org/r/20200708200409.22293-1-grandmaster@al2klimov=
.de=0D=0A=
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>=0D=0A=
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>=0D=0A=
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/Kconfig~vfat-fat-msdos-filesystem-replace-http-links-with-http=
s-ones
+++ a/fs/fat/Kconfig
@@ -41,7 +41,7 @@ config MSDOS_FS
 	  they are compressed; to access compressed MSDOS partitions under
 	  Linux, you can either use the DOS emulator DOSEMU, described in the
 	  DOSEMU-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, or try dmsdosfs in
+	  <https://www.tldp.org/docs.html#howto>, or try dmsdosfs in
 	  <ftp://ibiblio.org/pub/Linux/system/filesystems/dosfs/>. If you
 	  intend to use dosemu with a non-compressed MSDOS partition, say Y
 	  here) and MSDOS floppies. This means that file access becomes
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch
