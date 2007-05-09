From: akpm@linux-foundation.org
Subject: - revoke-core-code-break-cow-fixes.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:55 -0700
Message-ID: <200705090955.l499tt1c020536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbXEIJ4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     revoke: break cow fixes
has been removed from the -mm tree.  Its filename was
     revoke-core-code-break-cow-fixes.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: break cow fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, __revoke_break_cow() only needs to do
down_read() and we must use vma_pages() for get_user_pages().

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-break-cow-fixes fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-break-cow-fixes
+++ a/fs/revoke.c
@@ -185,7 +185,7 @@ static int __revoke_break_cow(struct tas
 	struct vm_area_struct *vma;
 	int err = 0;
 
-	down_write(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
 		int ret;
 
@@ -196,14 +196,13 @@ static int __revoke_break_cow(struct tas
 			continue;
 
 		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
-				     vma->vm_end-vma->vm_start, 1, 1, NULL,
-				     NULL);
+				     vma_pages(vma), 1, 1, NULL, NULL);
 		if (ret < 0) {
 			err = ret;
 			break;
 		}
 	}
-	up_write(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return err;
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
