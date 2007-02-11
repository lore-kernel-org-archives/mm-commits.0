From: akpm@linux-foundation.org
Subject: - buffer-memorder-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:45 -0800
Message-ID: <200702112254.l1BMsjlT016266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895AbXBKW4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, cmm@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     buffer: memorder fix
has been removed from the -mm tree.  Its filename was
     buffer-memorder-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: buffer: memorder fix
From: Nick Piggin <npiggin@suse.de>

unlock_buffer(), like unlock_page(), must not clear the lock without
ensuring that the critical section is closed.


Mingming later sent the same patch, saying:

We are running SDET benchmark and saw double free issue for ext3 extended
attributes block, which complains the same xattr block already being freed (in
ext3_xattr_release_block()).  The problem could also been triggered by
multiple threads loop untar/rm a kernel tree.

The race is caused by missing a memory barrier at unlock_buffer() before the
lock bit being cleared, resulting in possible concurrent h_refcounter update. 
That causes a reference counter leak, then later leads to the double free that
we have seen.

Inside unlock_buffer(), there is a memory barrier is placed *after* the lock
bit is being cleared, however, there is no memory barrier *before* the bit is
cleared.  On some arch the h_refcount update instruction and the clear bit
instruction could be reordered, thus leave the critical section re-entered.

The race is like this: For example, if the h_refcount is initialized as 1,

cpu 0:                                   cpu1
--------------------------------------   -----------------------------------
lock_buffer() /* test_and_set_bit */
clear_buffer_locked(bh);             
                                        lock_buffer() /* test_and_set_bit */
h_refcount = h_refcount+1; /* = 2*/     h_refcount = h_refcount + 1; /*= 2 */
                                        clear_buffer_locked(bh);
....                                    ......


We lost a h_refcount here.  We need a memory barrier before the buffer head
lock bit being cleared to force the order of the two writes.  Please apply.


Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/buffer.c~buffer-memorder-fix fs/buffer.c
--- a/fs/buffer.c~buffer-memorder-fix
+++ a/fs/buffer.c
@@ -78,6 +78,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
+	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
add-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
mm-mincore-anon.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
inotify-read-return-val-fix.patch
sched-avoid-div-in-rebalance_tick.patch
