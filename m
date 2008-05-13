From: akpm@linux-foundation.org
Subject: + multi-statement-if-seems-to-be-missing-braces.patch added to -mm tree
Date: Tue, 13 May 2008 13:18:28 -0700
Message-ID: <200805132018.m4DKISVx030085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762616AbYEMUTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 16:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi


The patch titled
     mips: multi-statement if() seems to be missing braces
has been added to the -mm tree.  Its filename is
     multi-statement-if-seems-to-be-missing-braces.patch

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
Subject: mips: multi-statement if() seems to be missing braces
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

In case this is a genuine bug, somebody else more familiar with that st=
uff
should evaluate it's effects (I just found it by some shell pipeline an=
d
it seems suspicious looking).

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-mips/pgtable.h~multi-statement-if-seems-to-be-mis=
sing-braces include/asm-mips/pgtable.h
--- a/include/asm-mips/pgtable.h~multi-statement-if-seems-to-be-missing=
-braces
+++ a/include/asm-mips/pgtable.h
@@ -239,9 +239,10 @@ static inline pte_t pte_mkdirty(pte_t pt
 static inline pte_t pte_mkyoung(pte_t pte)
 {
 	pte.pte_low |=3D _PAGE_ACCESSED;
-	if (pte.pte_low & _PAGE_READ)
+	if (pte.pte_low & _PAGE_READ) {
 		pte.pte_low  |=3D _PAGE_SILENT_READ;
 		pte.pte_high |=3D _PAGE_SILENT_READ;
+	}
 	return pte;
 }
 #else
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

multi-statement-if-seems-to-be-missing-braces.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
