From: akpm@linux-foundation.org
Subject: + vsprintf-reduce-code-size-by-avoiding-extra-check.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:31:59 -0800
Message-ID: <200912042232.nB4MVxw6011096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266AbZLDWcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:32:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com


The patch titled
     vsprintf: reduce code size by avoiding extra check
has been added to the -mm tree.  Its filename is
     vsprintf-reduce-code-size-by-avoiding-extra-check.patch

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

linux-next.patch
vsprintf-factorize-null-string.patch
vsprintf-pre-calculate-final-string-length-for-later-use.patch
vsprintf-give-it-some-care-to-please-checkpatchpl.patch
vsprintf-use-tolower-whenever-possible.patch
vsprintf-reduce-code-size-by-avoiding-extra-check.patch
vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-ones.p=
atch
vsprintf-factor-out-skip_space-code-in-a-separate-function.patch
vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch
ctype-constify-read-only-_ctype-string.patch
string-factorize-skip_spaces-and-export-it-to-be-generally-available.pa=
tch
string-on-strstrip-first-remove-leading-spaces-before-running-over-str.=
patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-functi=
on.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
