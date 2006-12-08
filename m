From: akpm@osdl.org
Subject: + read_zero_pagealigned-locking-fix.patch added to -mm tree
Date: Fri, 08 Dec 2006 15:52:06 -0800
Message-ID: <200612082352.kB8Nq67D009609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947511AbWLHXwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 18:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, Ramiro.Voicu@cern.ch


The patch titled
     read_zero_pagealigned() locking fix
has been added to the -mm tree.  Its filename is
     read_zero_pagealigned-locking-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: read_zero_pagealigned() locking fix
From: Hugh Dickins <hugh@veritas.com>

It looks like reading /dev/zero has been using zeromap_page_range unsafely
for years.

First it zaps existing ptes, then it inserts the zero page ptes - but only
while holding mmap_sem for read: could be racing against another thread
doing the same, or against ordinary faulting.  Now, it may well be that the
program is buggy to be racing against itself in this way (which would fit
with why this hasn't been observed before - buggy programs are exceedingly
rare, aren't they ;-?) but of course it shouldn't trigger a kernel BUG (or
leak, which preceded the BUG).

Will hopefully fix http://bugzilla.kernel.org/show_bug.cgi?id=7645, but Ramiro
hasn't got back to us yet.

Cc: Ramiro Voicu: <Ramiro.Voicu@cern.ch>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mem.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/mem.c~read_zero_pagealigned-locking-fix drivers/char/mem.c
--- a/drivers/char/mem.c~read_zero_pagealigned-locking-fix
+++ a/drivers/char/mem.c
@@ -631,7 +631,7 @@ static inline size_t read_zero_pagealign
 
 	mm = current->mm;
 	/* Oops, this was forgotten before. -ben */
-	down_read(&mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 
 	/* For private mappings, just map in zero pages. */
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
@@ -646,7 +646,7 @@ static inline size_t read_zero_pagealign
 			count = size;
 
 		zap_page_range(vma, addr, count, NULL);
-        	zeromap_page_range(vma, addr, count, PAGE_COPY);
+		zeromap_page_range(vma, addr, count, PAGE_COPY);
 
 		size -= count;
 		buf += count;
@@ -655,7 +655,7 @@ static inline size_t read_zero_pagealign
 			goto out_up;
 	}
 
-	up_read(&mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 	
 	/* The shared case is hard. Let's do the conventional zeroing. */ 
 	do {
@@ -669,7 +669,7 @@ static inline size_t read_zero_pagealign
 
 	return size;
 out_up:
-	up_read(&mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 	return size;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
read_zero_pagealigned-locking-fix.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch

