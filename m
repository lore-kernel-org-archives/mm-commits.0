From: akpm@linux-foundation.org
Subject: + nilfs2-refactor-nilfs_palloc_find_available_slot.patch added to -mm tree
Date: Tue, 22 Sep 2015 13:25:14 -0700
Message-ID: <5601b92a.JaY1Bm5Y/7tGGsN+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934337AbbIVUZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 16:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: refactor nilfs_palloc_find_available_slot()
has been added to the -mm tree.  Its filename is
     nilfs2-refactor-nilfs_palloc_find_available_slot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-refactor-nilfs_palloc_find_available_slot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-refactor-nilfs_palloc_find_available_slot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-use-nilfs_warning-in-allocator-implementation.patch
nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
nilfs2-refactor-nilfs_palloc_find_available_slot.patch
nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch
nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch

