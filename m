From: akpm@linux-foundation.org
Subject: + mmap-avoid-unnecessary-anon_vma-lock.patch added to -mm tree
Date: Tue, 29 Mar 2011 15:35:32 -0700
Message-ID: <201103292235.p2TMZWxp009595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab1C2Wfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 18:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, andi@firstfloor.org, hughd@google.com, riel@redhat.com


The patch titled
     mmap: avoid unnecessary anon_vma lock
has been added to the -mm tree.  Its filename is
     mmap-avoid-unnecessary-anon_vma-lock.patch

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
Subject: mmap: avoid unnecessary anon_vma lock
From: Shaohua Li <shaohua.li@intel.com>

If we only change vma->vm_end, we can avoid taking anon_vma lock even if
'insert' isn't NULL, which is the case of split_vma.

As I understand it, we need the lock before because rmap must get the
'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked
to anon_vma list in __insert_vm_struct before).

But now this isn't true any more.  The 'insert' VMA is already linked to
anon_vma list in __split_vma(with anon_vma_clone()) instead of
__insert_vm_struct.  There is no race rmap can't get required VMAs.  So
the anon_vma lock is unnecessary, and this can reduce one locking in brk
case and improve scalability.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock mm/mmap.c
--- a/mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock
+++ a/mm/mmap.c
@@ -605,7 +605,7 @@ again:			remove_next = 1 + (end > next->
 	 * lock may be shared between many sibling processes.  Skipping
 	 * the lock for brk adjustments makes a difference sometimes.
 	 */
-	if (vma->anon_vma && (insert || importer || start != vma->vm_start)) {
+	if (vma->anon_vma && (importer || start != vma->vm_start)) {
 		anon_vma = vma->anon_vma;
 		anon_vma_lock(anon_vma);
 	}
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

