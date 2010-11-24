From: akpm@linux-foundation.org
Subject: + decompressors-fix-header-validation-in-decompress_unlzmac.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:41:57 -0800
Message-ID: <201011242241.oAOMfv7l008316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab0KXWma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: fix header validation in decompress_unlzma.c
has been added to the -mm tree.  Its filename is
     decompressors-fix-header-validation-in-decompress_unlzmac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: fix header validation in decompress_unlzma.c
From: Lasse Collin <lasse.collin@tukaani.org>

Validation of header.pos calls error() but doesn't make the function
return to indicate an error to the caller.  Instead the decoding is
attempted with invalid header.pos.  This fixes it.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c      |    4 +++-
 lib/decompress_unlzma.c.orig |    4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/decompress_unlzma.c~decompressors-fix-header-validation-in-decompress_unlzmac lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-fix-header-validation-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c
@@ -574,8 +574,10 @@ STATIC inline int INIT unlzma(unsigned c
 		((unsigned char *)&header)[i] = *rc.ptr++;
 	}
 
-	if (header.pos >= (9 * 5 * 5))
+	if (header.pos >= (9 * 5 * 5)) {
 		error("bad header");
+		goto exit_1;
+	}
 
 	mi = 0;
 	lc = header.pos;
diff -puN lib/decompress_unlzma.c.orig~decompressors-fix-header-validation-in-decompress_unlzmac lib/decompress_unlzma.c.orig
--- a/lib/decompress_unlzma.c.orig~decompressors-fix-header-validation-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c.orig
@@ -574,10 +574,8 @@ STATIC inline int INIT unlzma(unsigned c
 		((unsigned char *)&header)[i] = *rc.ptr++;
 	}
 
-	if (header.pos >= (9 * 5 * 5)) {
+	if (header.pos >= (9 * 5 * 5))
 		error("bad header");
-		goto exit_1;
-	}
 
 	mi = 0;
 	lc = header.pos;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

