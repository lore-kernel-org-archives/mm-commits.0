From: akpm@linux-foundation.org
Subject: [merged] vsprintf-reduce-code-size-by-avoiding-extra-check.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:24 -0800
Message-ID: <200912152157.nBFLvOkO015719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761301AbZLOV5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: reduce code size by avoiding extra check
has been removed from the -mm tree.  Its filename was
     vsprintf-reduce-code-size-by-avoiding-extra-check.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: reduce code size by avoiding extra check
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

No functional change, just refactor the code so that it avoid checking
"if (hi)" two times in a sequence, taking advantage of previous check m=
ade.

It also reduces code size:
   text    data     bss     dec     hex filename
  15726       0       8   15734    3d76 vsprintf.o (ex lib/lib.a-BEFORE=
)
  15710       0       8   15718    3d66 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~vsprintf-reduce-code-size-by-avoiding-extra-ch=
eck lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-reduce-code-size-by-avoiding-extra-check
+++ a/lib/vsprintf.c
@@ -797,8 +797,9 @@ static char *ip6_compressed_string(char=20
 				p =3D pack_hex_byte(p, hi);
 			else
 				*p++ =3D hex_asc_lo(hi);
+			p =3D pack_hex_byte(p, lo);
 		}
-		if (hi || lo > 0x0f)
+		else if (lo > 0x0f)
 			p =3D pack_hex_byte(p, lo);
 		else
 			*p++ =3D hex_asc_lo(lo);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
