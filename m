From: akpm@linux-foundation.org
Subject: [merged] decompressors-validate-match-distance-in-decompress_unlzmac.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:28 -0800
Message-ID: <201101132013.p0DKD9i0030364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757391Ab1AMUOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     Decompressors: validate match distance in decompress_unlzma.c
has been removed from the -mm tree.  Its filename was
     decompressors-validate-match-distance-in-decompress_unlzmac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Decompressors: validate match distance in decompress_unlzma.c
From: Lasse Collin <lasse.collin@tukaani.org>

Validate the newly decoded distance (rep0) in process_bit1().  This is to
detect corrupt LZMA data quickly.  The old code can run for long time
producing garbage until it hits the end of the input.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/decompress_unlzma.c~decompressors-validate-match-distance-in-decompress_unlzmac lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-validate-match-distance-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c
@@ -522,6 +522,9 @@ static inline int INIT process_bit1(stru
 			cst->rep0 = pos_slot;
 		if (++(cst->rep0) == 0)
 			return 0;
+		if (cst->rep0 > wr->header->dict_size
+				|| cst->rep0 > get_pos(wr))
+			return -1;
 	}
 
 	len += LZMA_MATCH_MIN_LEN;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

