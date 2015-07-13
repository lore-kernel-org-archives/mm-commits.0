From: akpm@linux-foundation.org
Subject: + hexdump-fix-for-non-aligned-buffers.patch added to -mm tree
Date: Mon, 13 Jul 2015 16:15:58 -0700
Message-ID: <55a446ae.Bamgzx0rOW8UGegM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbGMXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmijail@gmail.com, andriy.shevchenko@linux.intel.com, dhowells@redhat.com, geert@linux-m68k.org, joe@perches.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: fix for non-aligned buffers
has been added to the -mm tree.  Its filename is
     hexdump-fix-for-non-aligned-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-fix-for-non-aligne=
d-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-fix-for-non-aligne=
d-buffers.patch

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
Subject: hexdump: fix for non-aligned buffers

An hexdump with a buf not aligned to the groupsize causes
non-naturally-aligned memory accesses.  This was causing a kernel panic=
 on
the processor BlackFin BF527, when such an unaligned buffer was fed by =
the
function ubifs_scanned_corruption in fs/ubifs/scan.c .

To fix this, change accesses to the contents of the buffer so they go
through get_unaligned().  This change should be harmless to unaligned-
access-capable architectures, and any performance hit should be anyway
dwarfed by the snprintf() processing time.

Signed-off-by: Horacio Mijail Ant=F3n Quiles <hmijail@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/hexdump.c~hexdump-fix-for-non-aligned-buffers lib/hexdump=
=2Ec
--- a/lib/hexdump.c~hexdump-fix-for-non-aligned-buffers
+++ a/lib/hexdump.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <asm/unaligned.h>
=20
 const char hex_asc[] =3D "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
@@ -139,7 +140,8 @@ int hex_dump_to_buffer(const void *buf,
 		for (j =3D 0; j < ngroups; j++) {
 			ret =3D snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%16.16llx", j ? " " : "",
-				       (unsigned long long)*(ptr8 + j));
+				       (unsigned long long)
+					       get_unaligned(ptr8 + j));
 			if (ret >=3D linebuflen - lx)
 				goto overflow1;
 			lx +=3D ret;
@@ -150,7 +152,7 @@ int hex_dump_to_buffer(const void *buf,
 		for (j =3D 0; j < ngroups; j++) {
 			ret =3D snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%8.8x", j ? " " : "",
-				       *(ptr4 + j));
+				       get_unaligned(ptr4 + j));
 			if (ret >=3D linebuflen - lx)
 				goto overflow1;
 			lx +=3D ret;
@@ -161,7 +163,7 @@ int hex_dump_to_buffer(const void *buf,
 		for (j =3D 0; j < ngroups; j++) {
 			ret =3D snprintf(linebuf + lx, linebuflen - lx,
 				       "%s%4.4x", j ? " " : "",
-				       *(ptr2 + j));
+				       get_unaligned(ptr2 + j));
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
