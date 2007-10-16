From: akpm@linux-foundation.org
Subject: - fs-fix-data-loss-on-error.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:15 -0700
Message-ID: <200710162032.l9GKWF4j014581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934737AbXJPVhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix data-loss on error
has been removed from the -mm tree.  Its filename was
     fs-fix-data-loss-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix data-loss on error
From: Nick Piggin <npiggin@suse.de>

New buffers against uptodate pages are simply be marked uptodate, while the
buffer_new bit remains set.  This causes error-case code to zero out parts of
those buffers because it thinks they contain stale data: wrong, they are
actually uptodate so this is a data loss situation.

Fix this by actually clearning buffer_new and marking the buffer dirty.  It
makes sense to always clear buffer_new before setting a buffer uptodate.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/buffer.c~fs-fix-data-loss-on-error fs/buffer.c
--- a/fs/buffer.c~fs-fix-data-loss-on-error
+++ a/fs/buffer.c
@@ -1813,7 +1813,9 @@ static int __block_prepare_write(struct 
 				unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
 				if (PageUptodate(page)) {
+					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
+					mark_buffer_dirty(bh);
 					continue;
 				}
 				if (block_end > to || block_start < from) {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
