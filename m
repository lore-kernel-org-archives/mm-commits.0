From: akpm@linux-foundation.org
Subject: [merged] decompressors-check-input-size-in-decompress_inflatec.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:43 -0800
Message-ID: <201101132013.p0DKDORH030453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab1AMUOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     decompressors: check input size in decompress_inflate.c
has been removed from the -mm tree.  Its filename was
     decompressors-check-input-size-in-decompress_inflatec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

