From: akpm@linux-foundation.org
Subject: + inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one.patch added to -mm tree
Date: Thu, 04 Mar 2010 12:35:55 -0800
Message-ID: <201003042035.o24KZtdn028356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390Ab0CDUgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 15:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joakim.tjernlund@transmode.se, Joakim.Tjernlund@transmode.se


The patch titled
     inflate_fast: sout is already a short so ptr arith was off by one.
has been added to the -mm tree.  Its filename is
     inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one.patch

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

zlib-make-new-optimized-inflate-endian-independent.patch
inflate_fast-sout-is-already-a-short-so-ptr-arith-was-off-by-one.patch

