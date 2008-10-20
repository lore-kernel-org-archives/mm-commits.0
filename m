From: akpm@linux-foundation.org
Subject: - fs-buffer-lock-use-lock-bitops.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:37 -0700
Message-ID: <200810202033.m9KKXbTs010671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbYJTUeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: buffer lock use lock bitops
has been removed from the -mm tree.  Its filename was
     fs-buffer-lock-use-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: buffer lock use lock bitops
From: Nick Piggin <npiggin@suse.de>

trylock_buffer and unlock_buffer open and close a critical section. 
Hence, we can use the lock bitops to get the desired memory ordering.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    3 +--
 include/linux/buffer_head.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~fs-buffer-lock-use-lock-bitops fs/buffer.c
--- a/fs/buffer.c~fs-buffer-lock-use-lock-bitops
+++ a/fs/buffer.c
@@ -76,8 +76,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void unlock_buffer(struct buffer_head *bh)
 {
-	smp_mb__before_clear_bit();
-	clear_buffer_locked(bh);
+	clear_bit_unlock(BH_Lock, &bh->b_state);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
diff -puN include/linux/buffer_head.h~fs-buffer-lock-use-lock-bitops include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-buffer-lock-use-lock-bitops
+++ a/include/linux/buffer_head.h
@@ -322,7 +322,7 @@ static inline void wait_on_buffer(struct
 
 static inline int trylock_buffer(struct buffer_head *bh)
 {
-	return likely(!test_and_set_bit(BH_Lock, &bh->b_state));
+	return likely(!test_and_set_bit_lock(BH_Lock, &bh->b_state));
 }
 
 static inline void lock_buffer(struct buffer_head *bh)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

