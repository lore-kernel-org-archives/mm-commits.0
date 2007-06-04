From: akpm@linux-foundation.org
Subject: + ocfs2-release-page-lock-before-calling-page_mkwrite.patch added to -mm tree
Date: Mon, 04 Jun 2007 12:57:44 -0700
Message-ID: <200706041957.l54JviXD012465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758308AbXFDT5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 15:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.fasheh@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     ocfs2: release page lock before calling ->page_mkwrite
has been added to the -mm tree.  Its filename is
     ocfs2-release-page-lock-before-calling-page_mkwrite.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~ocfs2-release-page-lock-before-calling-page_mkwrite mm/memory.c
--- a/mm/memory.c~ocfs2-release-page-lock-before-calling-page_mkwrite
+++ a/mm/memory.c
@@ -2377,11 +2377,14 @@ static int __do_fault(struct mm_struct *
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
 
@@ -2433,6 +2436,7 @@ static int __do_fault(struct mm_struct *
 
 out:
 	unlock_page(faulted_page);
+out_unlocked:
 	if (anon)
 		page_cache_release(faulted_page);
 	else if (dirty_page) {
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

ocfs2-release-page-lock-before-calling-page_mkwrite.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
