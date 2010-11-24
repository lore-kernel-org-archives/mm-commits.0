From: akpm@linux-foundation.org
Subject: + decompressors-check-for-read-errors-in-decompress_unlzmac.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:42:00 -0800
Message-ID: <201011242242.oAOMg11G008321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552Ab0KXWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:42:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: check for read errors in decompress_unlzma.c
has been added to the -mm tree.  Its filename is
     decompressors-check-for-read-errors-in-decompress_unlzmac.patch

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
Subject: Decompressors: check for read errors in decompress_unlzma.c
From: Lasse Collin <lasse.collin@tukaani.org>

Return value of rc->fill() is checked in rc_read() and error() is called
when needed, but then the code continues as if nothing had happened.

rc_read() is a void function and it's on the top of performance critical
call stacks, so propagating the error code via return values doesn't sound
like the best fix.  It seems better to check rc->buffer_size (which holds
the return value of rc->fill()) in the main loop.  It does nothing bad
that the code runs a little with unknown data after a failed rc->fill().

This fixes an infinite loop in initramfs decompression if the
LZMA-compressed initramfs image is corrupt.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c      |    3 +++
 lib/decompress_unlzma.c.orig |    4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN lib/decompress_unlzma.c~decompressors-check-for-read-errors-in-decompress_unlzmac lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-check-for-read-errors-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c
@@ -631,6 +631,8 @@ STATIC inline int INIT unlzma(unsigned c
 			if (cst.rep0 == 0)
 				break;
 		}
+		if (rc.buffer_size <= 0)
+			goto exit_3;
 	}
 
 	if (posp)
@@ -638,6 +640,7 @@ STATIC inline int INIT unlzma(unsigned c
 	if (wr.flush)
 		wr.flush(wr.buffer, wr.buffer_pos);
 	ret = 0;
+exit_3:
 	large_free(p);
 exit_2:
 	if (!output)
diff -puN lib/decompress_unlzma.c.orig~decompressors-check-for-read-errors-in-decompress_unlzmac lib/decompress_unlzma.c.orig
--- a/lib/decompress_unlzma.c.orig~decompressors-check-for-read-errors-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c.orig
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

