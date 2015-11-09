From: akpm@linux-foundation.org
Subject: [merged] nilfs2-refactor-nilfs_palloc_find_available_slot.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:02 -0800
Message-ID: <5640fe4e.oshTkg8Oa6ydC5hC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: refactor nilfs_palloc_find_available_slot()
has been removed from the -mm tree.  Its filename was
     nilfs2-refactor-nilfs_palloc_find_available_slot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: refactor nilfs_palloc_find_available_slot()

The current implementation of nilfs_palloc_find_available_slot() function
is overkill.  The underlying bit search routine is well optimized, so this
uses it more simply in nilfs_palloc_find_available_slot().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   48 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-refactor-nilfs_palloc_find_available_slot fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-refactor-nilfs_palloc_find_available_slot
+++ a/fs/nilfs2/alloc.c
@@ -335,39 +335,33 @@ void *nilfs_palloc_block_get_entry(const
  */
 static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
-					    int bsize,
+					    unsigned bsize,
 					    spinlock_t *lock)
 {
-	int curr, pos, end, i;
+	int pos, end = bsize;
 
-	if (target > 0) {
-		end = (target + BITS_PER_LONG - 1) & ~(BITS_PER_LONG - 1);
-		if (end > bsize)
-			end = bsize;
-		pos = nilfs_find_next_zero_bit(bitmap, end, target);
-		if (pos < end && !nilfs_set_bit_atomic(lock, pos, bitmap))
-			return pos;
-	} else {
-		end = 0;
+	if (likely(target < bsize)) {
+		pos = target;
+		do {
+			pos = nilfs_find_next_zero_bit(bitmap, end, pos);
+			if (pos >= end)
+				break;
+			if (!nilfs_set_bit_atomic(lock, pos, bitmap))
+				return pos;
+		} while (++pos < end);
+
+		end = target;
 	}
 
-	for (i = 0, curr = end;
-	     i < bsize;
-	     i += BITS_PER_LONG, curr += BITS_PER_LONG) {
-		/* wrap around */
-		if (curr >= bsize)
-			curr = 0;
-		while (*((unsigned long *)bitmap + curr / BITS_PER_LONG)
-		       != ~0UL) {
-			end = curr + BITS_PER_LONG;
-			if (end > bsize)
-				end = bsize;
-			pos = nilfs_find_next_zero_bit(bitmap, end, curr);
-			if (pos < end &&
-			    !nilfs_set_bit_atomic(lock, pos, bitmap))
-				return pos;
-		}
+	/* wrap around */
+	for (pos = 0; pos < end; pos++) {
+		pos = nilfs_find_next_zero_bit(bitmap, end, pos);
+		if (pos >= end)
+			break;
+		if (!nilfs_set_bit_atomic(lock, pos, bitmap))
+			return pos;
 	}
+
 	return -ENOSPC;
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


