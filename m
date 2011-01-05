From: akpm@linux-foundation.org
Subject: + decompressors-check-input-size-in-decompress_inflatec.patch added to -mm tree
Date: Tue, 04 Jan 2011 16:56:46 -0800
Message-ID: <201101050056.p050ukfB001664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab1AEA6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     decompressors: check input size in decompress_inflate.c
has been added to the -mm tree.  Its filename is
     decompressors-check-input-size-in-decompress_inflatec.patch

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
Subject: decompressors: check input size in decompress_inflate.c
From: Lasse Collin <lasse.collin@tukaani.org>

Check for end of the input buffer when skipping over the filename field in
the .gz file header.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_inflate.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN lib/decompress_inflate.c~decompressors-check-input-size-in-decompress_inflatec lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~decompressors-check-input-size-in-decompress_inflatec
+++ a/lib/decompress_inflate.c
@@ -98,13 +98,22 @@ STATIC int INIT gunzip(unsigned char *bu
 	 * possible asciz filename)
 	 */
 	strm->next_in = zbuf + 10;
+	strm->avail_in = len - 10;
 	/* skip over asciz filename */
 	if (zbuf[3] & 0x8) {
-		while (strm->next_in[0])
-			strm->next_in++;
-		strm->next_in++;
+		do {
+			/*
+			 * If the filename doesn't fit into the buffer,
+			 * the file is very probably corrupt. Don't try
+			 * to read more data.
+			 */
+			if (strm->avail_in == 0) {
+				error("header error");
+				goto gunzip_5;
+			}
+			--strm->avail_in;
+		} while (*strm->next_in++);
 	}
-	strm->avail_in = len - (strm->next_in - zbuf);
 
 	strm->next_out = out_buf;
 	strm->avail_out = out_len;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
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
decompressors-add-xz-decompressor-module.patch
decompressors-add-boot-time-xz-support.patch
decompressors-add-boot-time-xz-support-update.patch
x86-support-xz-compressed-kernel.patch
decompressors-check-input-size-in-decompress_inflatec.patch

