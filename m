From: akpm@linux-foundation.org
Subject: + decompressors-check-for-write-errors-in-decompress_unlzoc.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:16:58 -0800
Message-ID: <201011242216.oAOMGxmD007244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827Ab0KXWSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: check for write errors in decompress_unlzo.c
has been added to the -mm tree.  Its filename is
     decompressors-check-for-write-errors-in-decompress_unlzoc.patch

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
Subject: Decompressors: check for write errors in decompress_unlzo.c
From: Lasse Collin <lasse.collin@tukaani.org>

The return value of flush() is not checked in unlzo().  This means that
the decompressor won't stop even if the caller doesn't want more data. 
This can happen e.g.  with a corrupt LZO-compressed initramfs image.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c      |    4 ++--
 lib/decompress_unlzo.c.orig |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/decompress_unlzo.c~decompressors-check-for-write-errors-in-decompress_unlzoc lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~decompressors-check-for-write-errors-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c
@@ -187,8 +187,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 			}
 		}
 
-		if (flush)
-			flush(out_buf, dst_len);
+		if (flush && flush(out_buf, dst_len) != dst_len)
+			goto exit_2;
 		if (output)
 			out_buf += dst_len;
 		if (posp)
diff -puN lib/decompress_unlzo.c.orig~decompressors-check-for-write-errors-in-decompress_unlzoc lib/decompress_unlzo.c.orig
--- a/lib/decompress_unlzo.c.orig~decompressors-check-for-write-errors-in-decompress_unlzoc
+++ a/lib/decompress_unlzo.c.orig
@@ -187,8 +187,8 @@ STATIC inline int INIT unlzo(u8 *input, 
 			}
 		}
 
-		if (flush && flush(out_buf, dst_len) != dst_len)
-			goto exit_2;
+		if (flush)
+			flush(out_buf, dst_len);
 		if (output)
 			out_buf += dst_len;
 		if (posp)
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

