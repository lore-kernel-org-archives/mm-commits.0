From: akpm@linux-foundation.org
Subject: [merged]
 expand_downwards-dont-require-the-gap-if-vm_prev.patch removed from -mm
 tree
Date: Tue, 11 Jul 2017 12:24:57 -0700
Message-ID: <20170711192457.-FyxrkAtk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932365AbdGKTY6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, lwoodman@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, oleg@redhat.com, torvalds@linux-foundation.org


The patch titled
     Subject: mm/mmap.c: expand_downwards: don't require the gap if !vm_prev
has been removed from the -mm tree.  Its filename was
     expand_downwards-dont-require-the-gap-if-vm_prev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/mmap.c: expand_downwards: don't require the gap if !vm_prev

expand_stack(vma) fails if address < stack_guard_gap even if there is no
vma->vm_prev.  I don't think this makes sense, and we didn't do this
before the recent commit 1be7107fbe18 ("mm: larger stack guard gap,
between vmas").  We do not need a gap in this case, any address is fine as
long as security_mmap_addr() doesn't object.

This also simplifies the code, we know that address >= prev->vm_end and
thus underflow is not possible.

Link: http://lkml.kernel.org/r/20170628175258.GA24881@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/mmap.c~expand_downwards-dont-require-the-gap-if-vm_prev mm/mmap.c
--- a/mm/mmap.c~expand_downwards-dont-require-the-gap-if-vm_prev
+++ a/mm/mmap.c
@@ -2316,7 +2316,6 @@ int expand_downwards(struct vm_area_stru
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	unsigned long gap_addr;
 	int error;
 
 	address &= PAGE_MASK;
@@ -2325,15 +2324,12 @@ int expand_downwards(struct vm_area_stru
 		return error;
 
 	/* Enforce stack_guard_gap */
-	gap_addr = address - stack_guard_gap;
-	if (gap_addr > address)
-		return -ENOMEM;
 	prev = vma->vm_prev;
-	if (prev && prev->vm_end > gap_addr &&
+	/* Check that both stack segments have the same anon_vma? */
+	if (prev && !(prev->vm_flags & VM_GROWSDOWN) &&
 			(prev->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
-		if (!(prev->vm_flags & VM_GROWSDOWN))
+		if (address - prev->vm_end < stack_guard_gap)
 			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
 	}
 
 	/* We must make sure the anon_vma is allocated. */
_

Patches currently in -mm which might be from oleg@redhat.com are


