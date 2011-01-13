From: akpm@linux-foundation.org
Subject: [merged] decompressors-fix-header-validation-in-decompress_unlzmac.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:21 -0800
Message-ID: <201101132013.p0DKD2wo030355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933798Ab1AMUZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:25:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: fix header validation in decompress_unlzma.c
has been removed from the -mm tree.  Its filename was
     decompressors-fix-header-validation-in-decompress_unlzmac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 lib/decompress_unlzma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

