From: akpm@linux-foundation.org
Subject: + mmap-fix-and-tidy-up-overcommit-page-arithmetic.patch added to -mm tree
Date: Wed, 13 Jul 2011 14:44:18 -0700
Message-ID: <201107132144.p6DLiIBU004746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221Ab1GMVow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 17:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.fink@palm.com, hughd@google.com, minchan.kim@gmail.com


The patch titled
     mmap: fix and tidy up overcommit page arithmetic
has been added to the -mm tree.  Its filename is
     mmap-fix-and-tidy-up-overcommit-page-arithmetic.patch

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
Subject: mmap: fix and tidy up overcommit page arithmetic
From: Dmitry Fink <dmitry.fink@palm.com>

- shmem pages are not immediately available, but they are not
  potentially available either, even if we swap them out, they will just
  relocate from memory into swap, total amount of immediate and
  potentially available memory is not going to be affected, so we
  shouldn't count them as potentially free in the first place.

- nr_free_pages() is not an expensive operation anymore, there is no
  need to split the decision making in two halves and repeat code.

Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |   34 +++++++++++++---------------------
 mm/nommu.c |   34 +++++++++++++---------------------
 2 files changed, 26 insertions(+), 42 deletions(-)

diff -puN mm/mmap.c~mmap-fix-and-tidy-up-overcommit-page-arithmetic mm/mmap.c
--- a/mm/mmap.c~mmap-fix-and-tidy-up-overcommit-page-arithmetic
+++ a/mm/mmap.c
@@ -122,9 +122,17 @@ int __vm_enough_memory(struct mm_struct 
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		unsigned long n;
+		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_FILE_PAGES);
+
+		/*
+		 * shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system.
+		 */
+		free -= global_page_state(NR_SHMEM);
 
-		free = global_page_state(NR_FILE_PAGES);
 		free += nr_swap_pages;
 
 		/*
@@ -136,34 +144,18 @@ int __vm_enough_memory(struct mm_struct 
 		free += global_page_state(NR_SLAB_RECLAIMABLE);
 
 		/*
-		 * Leave the last 3% for root
-		 */
-		if (!cap_sys_admin)
-			free -= free / 32;
-
-		if (free > pages)
-			return 0;
-
-		/*
-		 * nr_free_pages() is very expensive on large systems,
-		 * only call if we're about to fail.
-		 */
-		n = nr_free_pages();
-
-		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
 		 */
-		if (n <= totalreserve_pages)
+		if (free <= totalreserve_pages)
 			goto error;
 		else
-			n -= totalreserve_pages;
+			free -= totalreserve_pages;
 
 		/*
 		 * Leave the last 3% for root
 		 */
 		if (!cap_sys_admin)
-			n -= n / 32;
-		free += n;
+			free -= free / 32;
 
 		if (free > pages)
 			return 0;
diff -puN mm/nommu.c~mmap-fix-and-tidy-up-overcommit-page-arithmetic mm/nommu.c
--- a/mm/nommu.c~mmap-fix-and-tidy-up-overcommit-page-arithmetic
+++ a/mm/nommu.c
@@ -1884,9 +1884,17 @@ int __vm_enough_memory(struct mm_struct 
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		unsigned long n;
+		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_FILE_PAGES);
+
+		/*
+		 * shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system.
+		 */
+		free -= global_page_state(NR_SHMEM);
 
-		free = global_page_state(NR_FILE_PAGES);
 		free += nr_swap_pages;
 
 		/*
@@ -1898,34 +1906,18 @@ int __vm_enough_memory(struct mm_struct 
 		free += global_page_state(NR_SLAB_RECLAIMABLE);
 
 		/*
-		 * Leave the last 3% for root
-		 */
-		if (!cap_sys_admin)
-			free -= free / 32;
-
-		if (free > pages)
-			return 0;
-
-		/*
-		 * nr_free_pages() is very expensive on large systems,
-		 * only call if we're about to fail.
-		 */
-		n = nr_free_pages();
-
-		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
 		 */
-		if (n <= totalreserve_pages)
+		if (free <= totalreserve_pages)
 			goto error;
 		else
-			n -= totalreserve_pages;
+			free -= totalreserve_pages;
 
 		/*
 		 * Leave the last 3% for root
 		 */
 		if (!cap_sys_admin)
-			n -= n / 32;
-		free += n;
+			free -= free / 32;
 
 		if (free > pages)
 			return 0;
_

Patches currently in -mm which might be from dmitry.fink@palm.com are

mmap-fix-and-tidy-up-overcommit-page-arithmetic.patch

