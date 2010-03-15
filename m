From: akpm@linux-foundation.org
Subject: [merged] inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:51 -0400
Message-ID: <201003150705.o2F75Om9017086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759730Ab0COHFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joakim.tjernlund@transmode.se, Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     inflate_fast: sout is already a short so ptr arith was off by one.
has been removed from the -mm tree.  Its filename was
     inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inflate_fast: sout is already a short so ptr arith was off by one.
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>

inflate_fast() can do either POST INC or PRE INC on its pointers walking
the memory to decompress.  Default is PRE INC.

The sout pointer offset was miscalculated in one case as the calculation
assumed sout was a char * This breaks inflate_fast() iff configured to do
POST INC.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/zlib_inflate/inffast.c~inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one
+++ a/lib/zlib_inflate/inffast.c
@@ -286,7 +286,7 @@ void inflate_fast(z_streamp strm, unsign
 		    } else { /* dist == 1 or dist == 2 */
 			unsigned short pat16;
 
-			pat16 = *(sout-2+2*OFF);
+			pat16 = *(sout-1+OFF);
 			if (dist == 1) {
 				union uu mm;
 				/* copy one char pattern to both bytes */
_

Patches currently in -mm which might be from joakim.tjernlund@transmode.se are

origin.patch

