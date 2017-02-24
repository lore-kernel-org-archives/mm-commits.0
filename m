From: akpm@linux-foundation.org
Subject: [folded-merged] find_bit-micro-optimise-find_next__bit-v2.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:43:48 -0800
Message-ID: <58b0b724.RG3BlghzpZjrMqgT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, linux@rasmusvillemoes.dk, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: find_bit-micro-optimise-find_next__bit-v2
has been removed from the -mm tree.  Its filename was
     find_bit-micro-optimise-find_next__bit-v2.patch

This patch was dropped because it was folded into find_bit-micro-optimise-find_next__bit.patch

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: find_bit-micro-optimise-find_next__bit-v2

Link: http://lkml.kernel.org/r/1483709016-1834-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit.c       |    2 +-
 tools/lib/find_bit.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2 lib/find_bit.c
--- a/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2
+++ a/lib/find_bit.c
@@ -151,7 +151,7 @@ static unsigned long _find_next_bit_le(c
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
diff -puN tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2 tools/lib/find_bit.c
--- a/tools/lib/find_bit.c~find_bit-micro-optimise-find_next__bit-v2
+++ a/tools/lib/find_bit.c
@@ -34,7 +34,7 @@ static unsigned long _find_next_bit(cons
 {
 	unsigned long tmp;
 
-	if (!nbits || start >= nbits)
+	if (unlikely(start >= nbits))
 		return nbits;
 
 	tmp = addr[start / BITS_PER_LONG] ^ invert;
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

find_bit-micro-optimise-find_next__bit.patch
checkpatch-add-another-old-address-for-the-fsf.patch

