From: akpm@linux-foundation.org
Subject: + arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch added to -mm tree
Date: Fri, 09 Sep 2011 16:24:48 -0700
Message-ID: <201109092324.p89NOmtA012723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1IIXYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 19:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     arch/x86/mm/pageattr.c: quiet sparse noise; local functions should=
 be static
has been added to the -mm tree.  Its filename is
     arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be=
-static.patch

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
Subject: arch/x86/mm/pageattr.c: quiet sparse noise; local functions sh=
ould be static
=46rom: H Hartley Sweeten <hartleys@visionengravers.com>

Local functions should be marked static. =C2=A0This quiets the followin=
g
sparse noise:

warning: symbol '_set_memory_array' was not declared. Should it be stat=
ic?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/pageattr.c~arch-x86-mm-pageattrc-quiet-sparse-noi=
se-local-functions-should-be-static arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~arch-x86-mm-pageattrc-quiet-sparse-noise-l=
ocal-functions-should-be-static
+++ a/arch/x86/mm/pageattr.c
@@ -998,7 +998,7 @@ out_err:
 }
 EXPORT_SYMBOL(set_memory_uc);
=20
-int _set_memory_array(unsigned long *addr, int addrinarray,
+static int _set_memory_array(unsigned long *addr, int addrinarray,
 		unsigned long new_type)
 {
 	int i, j;
_

Patches currently in -mm which might be from hartleys@visionengravers.c=
om are

arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-po=
inter.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-stat=
ic.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
