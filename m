From: akpm@linux-foundation.org
Subject: + fs-buffer-lock-use-lock-bitops.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:29:57 -0700
Message-ID: <200808182329.m7INTvVv019441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbYHRXaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: buffer lock use lock bitops
has been added to the -mm tree.  Its filename is
     fs-buffer-lock-use-lock-bitops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mm-dirty-page-tracking-race-fix.patch
mm-dirty-page-tracking-race-fix-fix.patch
mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch
mm-xip-ext2-fix-block-allocation-race.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

