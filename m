From: akpm@linux-foundation.org
Subject: - avoid-negative-and-full-width-shifts-in-radix-treec.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:47 -0700
Message-ID: <200710180659.l9I6xlTj031022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbXJRHA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firefly@vax64.dk, clameter@sgi.com, hch@infradead.org, macro@linux-mips.org, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, schwab@suse.de, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     avoid negative (and full-width) shifts in radix-tree.c
has been removed from the -mm tree.  Its filename was
     avoid-negative-and-full-width-shifts-in-radix-treec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avoid negative (and full-width) shifts in radix-tree.c
From: Peter Lund <firefly@vax64.dk>

Negative shifts are not allowed in C (the result is undefined).  Same thing
with full-width shifts.

It works on most platforms but not on the VAX with gcc 4.0.1 (it results in an
"operand reserved" fault).

Shifting by more than the width of the value on the left is also not
allowed.  I think the extra '>> 1' tacked on at the end in the original
code was an attempt to work around that.  Getting rid of that is an extra
feature of this patch.

Here's the chapter and verse, taken from the final draft of the C99
standard ("6.5.7 Bitwise shift operators", paragraph 3):

  "The integer promotions are performed on each of the operands. The
  type of the result is that of the promoted left operand. If the
  value of the right operand is negative or is greater than or equal
  to the width of the promoted left operand, the behavior is
  undefined."

Thank you to Jan-Benedict Glaw, Christoph Hellwig, Maciej Rozycki, Pekka
Enberg, Andreas Schwab, and Christoph Lameter for review.  Special thanks
to Andreas for spotting that my fix only removed half the undefined
behaviour.

Signed-off-by: Peter Lund <firefly@vax64.dk>
Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andreas Schwab <schwab@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN lib/radix-tree.c~avoid-negative-and-full-width-shifts-in-radix-treec lib/radix-tree.c
--- a/lib/radix-tree.c~avoid-negative-and-full-width-shifts-in-radix-treec
+++ a/lib/radix-tree.c
@@ -1049,12 +1049,14 @@ radix_tree_node_ctor(struct kmem_cache *
 
 static __init unsigned long __maxindex(unsigned int height)
 {
-	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
+	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
+	int shift = RADIX_TREE_INDEX_BITS - width;
 
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
-	return index;
+	if (shift < 0)
+		return ~0UL;
+	if (shift >= BITS_PER_LONG)
+		return 0UL;
+	return ~0UL >> shift;
 }
 
 static __init void radix_tree_init_maxindex(void)
_

Patches currently in -mm which might be from firefly@vax64.dk are

origin.patch
