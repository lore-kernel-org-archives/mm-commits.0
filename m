From: akpm@linux-foundation.org
Subject: [merged] decompressors-check-for-read-errors-in-decompress_unlzmac.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:23 -0800
Message-ID: <201101132013.p0DKD4bY030358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822Ab1AMU0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:26:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: check for read errors in decompress_unlzma.c
has been removed from the -mm tree.  Its filename was
     decompressors-check-for-read-errors-in-decompress_unlzmac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 lib/decompress_unlzma.c |    3 +++
 1 file changed, 3 insertions(+)

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
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

