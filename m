From: akpm@linux-foundation.org
Subject: + proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean.patch added to -mm tree
Date: Tue, 14 Sep 2010 11:38:05 -0700
Message-ID: <201009141838.o8EIc5Zl011470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab0INSis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 14:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, balbir@in.ibm.com, matz@novell.com, mpm@selenic.com, rguenther@suse.de, stable@kernel.org


The patch titled
     /proc/pid/smaps: after swapout/swapin private dirty mappings are reported clean
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean.patch

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
Subject: /proc/pid/smaps: after swapout/swapin private dirty mappings are reported clean
From: Nikanth Karthikesan <knikanth@suse.de>

/proc/$pid/smaps broken: After swapout/swapin private dirty mappings
become clean.

When a page with private file mapping becomes dirty, the vma will be in
both i_mmap tree and anon_vma list.  The /proc/$pid/smaps will account
these pages as dirty and backed by the file.

But when those dirty pages gets swapped out, and when they are read back
from swap, they would be marked as clean, as it should be, as they are
part of swap cache now.

But the /proc/$pid/smaps would report the vma as a mapping of a file and
it is clean.  The pages are actually in same state i.e., dirty with
respect to file still, but which was once reported as dirty is now being
reported as clean to user-space.

This confuses tools like gdb which uses this information.  Those tools
think that those pages were never modified and it creates problem when
they create dumps.

The file mapping of the vma also cannot be broken as pages never read
earlier, will still have to come from the file.  Just that those dirty
pages have become clean anonymous pages.

So instead when a file backed vma has anonymous pages report them as dirty
pages.  As those pages are dirty with respect to the backing file.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Cc: Richard Guenther <rguenther@suse.de>
Cc: Michael Matz <matz@novell.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean
+++ a/fs/proc/task_mmu.c
@@ -369,7 +369,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 				mss->shared_clean += PAGE_SIZE;
 			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
 		} else {
-			if (pte_dirty(ptent))
+			/*
+			 * File-backed pages, now anonymous are dirty
+			 * with respect to the file.
+			 */
+			if (pte_dirty(ptent) || (vma->vm_file && PageAnon(page)))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch

