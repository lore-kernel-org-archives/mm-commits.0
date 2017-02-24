From: akpm@linux-foundation.org
Subject: [patch 109/124] lib/find_bit.c: micro-optimise find_next_*_bit
Date: Fri, 24 Feb 2017 15:00:58 -0800
Message-ID: <58b0bb2a.Ozc6MV/1eF8ZEJFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdBXXA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, linux@rasmusvillemoes.dk, ynorov@caviumnetworks.com

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: lib/find_bit.c: micro-optimise find_next_*_bit

This saves 32 bytes on my x86-64 build, mostly due to alignment
considerations and sharing more code between find_next_bit and
find_next_zero_bit, but it does save a couple of instructions.

There's really two parts to this commit.  First, the first half of the
test: (!nbits || start >= nbits) is trivially a subset of the second half,
since nbits and start are both unsigned.  Second, while looking at the
disassembly, I noticed that GCC was predicting the branch taken.  Since
this is a failure case, it's clearly the less likely of the two branches,
so add an unlikely() to override GCC's heuristics.

[mawilcox@microsoft.com: v2]
  Link: http://lkml.kernel.org/r/1483709016-1834-1-git-send-email-mawilcox@linuxonhyperv.com
Link: http://lkml.kernel.org/r/1483709016-1834-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c       |    4 ++--
 tools/lib/find_bit.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/find_bit.c~find_bit-micro-optimise-find_next__bit lib/find_bit.c
--- a/lib/find_bit.c~find_bit-micro-optimise-find_next__bit
+++ a/lib/find_bit.c
@@ -33,7 +33,7 @@ static unsigned long _find_next_bit(cons
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
@@ -151,7 +151,7 @@ static unsigned long _find_next_bit_le(c
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
diff -puN tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit tools/lib/find_bit.c
--- a/tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit
+++ a/tools/lib/find_bit.c
@@ -34,7 +34,7 @@ static unsigned long _find_next_bit(cons
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
_
