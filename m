From: akpm@linux-foundation.org
Subject: + genksyms-parser-fix-the-__attribute__-rule.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:51:42 -0700
Message-ID: <200807290351.m6T3pgkG012698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYG2DxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 23:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@suse.de, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     genksyms: parser: fix the __attribute__ rule
has been added to the -mm tree.  Its filename is
     genksyms-parser-fix-the-__attribute__-rule.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genksyms: parser: fix the __attribute__ rule
From: Andreas Gruenbacher <agruen@suse.de>

We are having two kinds of problems with genksyms today: fake checksum
changes without actual ABI changes, and changes which we would rather like
to ignore (such as an additional field at the end of a structure that
modules are not supposed to touch, for example).

I have thought about ways to improve genksyms and compute checksums
differently to avoid those problems, but in the end I don't see a
fundamentally better way.  So here are some genksyms patches for at least
making the checksums more easily manageable, if we cannot fully fix them.

In addition to the bugfixes (the first two patches), this allows genksyms
to track checksum changes and report why a checksum changed (third patch),
and to selectively ignore changes (fourth patch).


This patch:

Gcc __attribute__ definitions may occur repeatedly, e.g.,

	static int foo __attribute__((__used__))
		       __attribute__((aligned (16)));

The genksyms parser does not understand this, and generates a syntax error.
Fix this case.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/genksyms/parse.y |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/genksyms/parse.y~genksyms-parser-fix-the-__attribute__-rule scripts/genksyms/parse.y
--- a/scripts/genksyms/parse.y~genksyms-parser-fix-the-__attribute__-rule
+++ a/scripts/genksyms/parse.y
@@ -446,7 +446,7 @@ member_bitfield_declarator:
 
 attribute_opt:
 	/* empty */					{ $$ = NULL; }
-	| ATTRIBUTE_PHRASE
+	| attribute_opt ATTRIBUTE_PHRASE
 	;
 
 asm_definition:
_

Patches currently in -mm which might be from agruen@suse.de are

genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
git-unionfs.patch

