From: akpm@linux-foundation.org
Subject: + hexdump-fix-for-non-aligned-buffers-v6.patch added to -mm tree
Date: Tue, 14 Jul 2015 16:54:32 -0700
Message-ID: <55a5a138.Q2bmDG4qD5X4CNBO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbGNXyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmijail@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump-fix-for-non-aligned-buffers-v6
has been added to the -mm tree.  Its filename is
     hexdump-fix-for-non-aligned-buffers-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-fix-for-non-aligne=
d-buffers-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-fix-for-non-aligne=
d-buffers-v6.patch

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
=46rom: Horacio Mijail Anton Quiles <hmijail@gmail.com>
Subject: hexdump-fix-for-non-aligned-buffers-v6

 - Removed unnecessary cast of u64 to unsigned long long, since
     currently they are equivalent (per Geer Uytterhoeven's indication)


Signed-off-by: Horacio Mijail Ant=F3n Quiles <hmijail@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/hexdump.c~hexdump-fix-for-non-aligned-buffers-v6 lib/hexd=
ump.c
--- a/lib/hexdump.c~hexdump-fix-for-non-aligned-buffers-v6
+++ a/lib/hexdump.c
@@ -140,8 +140,7 @@ int hex_dump_to_buffer(const void *buf,
 		for (j =3D 0; j < ngroups; j++) {
 			ret =3D snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%16.16llx", j ? " " : "",
-				       (unsigned long long)
-					       get_unaligned(ptr8 + j));
+				       get_unaligned(ptr8 + j));
 			if (ret >=3D linebuflen - lx)
 				goto overflow1;
 			lx +=3D ret;
_

Patches currently in -mm which might be from hmijail@gmail.com are

hexdump-fix-for-non-aligned-buffers.patch
hexdump-fix-for-non-aligned-buffers-v6.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
