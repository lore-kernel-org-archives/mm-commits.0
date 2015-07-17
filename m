From: akpm@linux-foundation.org
Subject: [folded-merged] hexdump-fix-for-non-aligned-buffers-v6.patch
 removed from -mm tree
Date: Fri, 17 Jul 2015 16:20:26 -0700
Message-ID: <55a98dba.X0JjqmGbfAlcyDd4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbbGQXU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jul 2015 19:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmijail@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump-fix-for-non-aligned-buffers-v6
has been removed from the -mm tree.  Its filename was
     hexdump-fix-for-non-aligned-buffers-v6.patch

This patch was dropped because it was folded into hexdump-fix-for-non-a=
ligned-buffers.patch

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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
