From: akpm@linux-foundation.org
Subject: +
 mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch added
 to -mm tree
Date: Wed, 18 Feb 2015 12:55:54 -0800
Message-ID: <54e4fc5a.t3xdJG3RR4ldWtAu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbBRUzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move gup() -> posix mlock() error conversion out of __mm_populate
has been added to the -mm tree.  Its filename is
     mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: move gup() -> posix mlock() error conversion out of __mm_populate

This is praparation to moving mm_populate()-related code out of
mm/mlock.c.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate mm/mlock.c
--- a/mm/mlock.c~mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate
+++ a/mm/mlock.c
@@ -712,7 +712,6 @@ int __mm_populate(unsigned long start, u
 				ret = 0;
 				continue;	/* continue at next VMA */
 			}
-			ret = __mlock_posix_error_return(ret);
 			break;
 		}
 		nend = nstart + ret * PAGE_SIZE;
@@ -750,9 +749,13 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 		error = do_mlock(start, len, 1);
 
 	up_write(&current->mm->mmap_sem);
-	if (!error)
-		error = __mm_populate(start, len, 0);
-	return error;
+	if (error)
+		return error;
+
+	error = __mm_populate(start, len, 0);
+	if (error)
+		return __mlock_posix_error_return(error);
+	return 0;
 }
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch

