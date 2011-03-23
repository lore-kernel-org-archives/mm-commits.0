From: akpm@linux-foundation.org
Subject: [merged] mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:34:05 -0700
Message-ID: <201103232037.p2NKbf3h028256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933346Ab1CWUzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gleb@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: allow GUP to fail instead of waiting on a page
has been removed from the -mm tree.  Its filename was
     mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allow GUP to fail instead of waiting on a page
From: Gleb Natapov <gleb@redhat.com>

GUP user may want to try to acquire a reference to a page if it is already
in memory, but not if IO, to bring it in, is needed.  For example KVM may
tell vcpu to schedule another guest process if current one is trying to
access swapped out page.  Meanwhile, the page will be swapped in and the
guest process, that depends on it, will be able to run again.

This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
FOLL_NOWAIT follow_page flags.  FAULT_FLAG_RETRY_NOWAIT, when used in
conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
instead.

[akpm@linux-foundation.org: improve FOLL_NOWAIT comment]
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/filemap.c       |    6 ++++--
 mm/memory.c        |    5 ++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-allow-gup-to-fail-instead-of-waiting-on-a-page include/linux/mm.h
--- a/include/linux/mm.h~mm-allow-gup-to-fail-instead-of-waiting-on-a-page
+++ a/include/linux/mm.h
@@ -151,6 +151,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 #define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
 #define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
+#define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
@@ -1545,6 +1546,8 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
+				 * and return without waiting upon it */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
diff -puN mm/filemap.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page mm/filemap.c
--- a/mm/filemap.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page
+++ a/mm/filemap.c
@@ -621,8 +621,10 @@ int __lock_page_or_retry(struct page *pa
 		__lock_page(page);
 		return 1;
 	} else {
-		up_read(&mm->mmap_sem);
-		wait_on_page_locked(page);
+		if (!(flags & FAULT_FLAG_RETRY_NOWAIT)) {
+			up_read(&mm->mmap_sem);
+			wait_on_page_locked(page);
+		}
 		return 0;
 	}
 }
diff -puN mm/memory.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page mm/memory.c
--- a/mm/memory.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page
+++ a/mm/memory.c
@@ -1569,6 +1569,8 @@ int __get_user_pages(struct task_struct 
 					fault_flags |= FAULT_FLAG_WRITE;
 				if (nonblocking)
 					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+				if (foll_flags & FOLL_NOWAIT)
+					fault_flags |= (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT);
 
 				ret = handle_mm_fault(mm, vma, start,
 							fault_flags);
@@ -1595,7 +1597,8 @@ int __get_user_pages(struct task_struct 
 					tsk->min_flt++;
 
 				if (ret & VM_FAULT_RETRY) {
-					*nonblocking = 0;
+					if (nonblocking)
+						*nonblocking = 0;
 					return i;
 				}
 
_

Patches currently in -mm which might be from gleb@redhat.com are

origin.patch

