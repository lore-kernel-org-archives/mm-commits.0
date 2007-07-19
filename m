From: akpm@linux-foundation.org
Subject: - ocfs2-release-page-lock-before-calling-page_mkwrite.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:23 -0700
Message-ID: <200707191959.l6JJxN40019360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXGSUEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.fasheh@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ocfs2: release page lock before calling ->page_mkwrite
has been removed from the -mm tree.  Its filename was
     ocfs2-release-page-lock-before-calling-page_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: release page lock before calling ->page_mkwrite
From: Mark Fasheh <mark.fasheh@oracle.com>

__do_fault() was calling ->page_mkwrite() with the page lock held, which
violates the locking rules for that callback.  Release and retake the page
lock around the callback to avoid deadlocking file systems which manually
take it.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~ocfs2-release-page-lock-before-calling-page_mkwrite mm/memory.c
--- a/mm/memory.c~ocfs2-release-page-lock-before-calling-page_mkwrite
+++ a/mm/memory.c
@@ -2369,11 +2369,14 @@ static int __do_fault(struct mm_struct *
 			 * address space wants to know that the page is about
 			 * to become writable
 			 */
-			if (vma->vm_ops->page_mkwrite &&
-			    vma->vm_ops->page_mkwrite(vma, page) < 0) {
-				fdata.type = VM_FAULT_SIGBUS;
-				anon = 1; /* no anon but release faulted_page */
-				goto out;
+			if (vma->vm_ops->page_mkwrite) {
+				unlock_page(page);
+				if (vma->vm_ops->page_mkwrite(vma, page) < 0) {
+					fdata.type = VM_FAULT_SIGBUS;
+					anon = 1; /* no anon but release faulted_page */
+					goto out_unlocked;
+				}
+				lock_page(page);
 			}
 		}
 
@@ -2425,6 +2428,7 @@ static int __do_fault(struct mm_struct *
 
 out:
 	unlock_page(faulted_page);
+out_unlocked:
 	if (anon)
 		page_cache_release(faulted_page);
 	else if (dirty_page) {
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

origin.patch
git-ocfs2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
