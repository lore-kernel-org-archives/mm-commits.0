From: akpm@linux-foundation.org
Subject: + mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch added to -mm tree
Date: Tue, 01 Feb 2011 16:42:51 -0800
Message-ID: <201102020042.p120gp6h008038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab1BBAnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 19:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gleb@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     mm: allow GUP to fail instead of waiting on a page
has been added to the -mm tree.  Its filename is
     mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/filemap.c       |    6 ++++--
 mm/memory.c        |    5 ++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

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
@@ -1536,6 +1537,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_NOWAIT	0x20	/* return if disk transfer is needed */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 
diff -puN mm/filemap.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page mm/filemap.c
--- a/mm/filemap.c~mm-allow-gup-to-fail-instead-of-waiting-on-a-page
+++ a/mm/filemap.c
@@ -632,8 +632,10 @@ int __lock_page_or_retry(struct page *pa
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
@@ -1520,6 +1520,8 @@ int __get_user_pages(struct task_struct 
 					fault_flags |= FAULT_FLAG_WRITE;
 				if (nonblocking)
 					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+				if (foll_flags & FOLL_NOWAIT)
+					fault_flags |= (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT);
 
 				ret = handle_mm_fault(mm, vma, start,
 							fault_flags);
@@ -1539,7 +1541,8 @@ int __get_user_pages(struct task_struct 
 					tsk->min_flt++;
 
 				if (ret & VM_FAULT_RETRY) {
-					*nonblocking = 0;
+					if (nonblocking)
+						*nonblocking = 0;
 					return i;
 				}
 
_

Patches currently in -mm which might be from gleb@redhat.com are

mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch

