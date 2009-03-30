From: akpm@linux-foundation.org
Subject: + xtensa-make-startup-code-discardable.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:45:05 -0700
Message-ID: <200903302345.n2UNj5PI027465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbZC3Xs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, chris@zankel.net


The patch titled
     xtensa: make startup code discardable
has been added to the -mm tree.  Its filename is
     xtensa-make-startup-code-discardable.patch

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
Subject: xtensa: make startup code discardable
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

Move it from .text to .init.text to get rid of it after boot and
prevent illegal section references.

Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/head.S~xtensa-make-startup-code-discardabl=
e arch/xtensa/kernel/head.S
--- a/arch/xtensa/kernel/head.S~xtensa-make-startup-code-discardable
+++ a/arch/xtensa/kernel/head.S
@@ -53,7 +53,7 @@ _start:	_j	2f
 2:	l32r	a0, 1b
 	jx	a0
=20
-	.text
+	.section .init.text, "ax"
 	.align 4
 _startup:
=20
_

Patches currently in -mm which might be from dg@emlix.com are

linux-next.patch
xtensa-make-startup-code-discardable.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
