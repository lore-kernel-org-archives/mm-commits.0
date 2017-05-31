From: akpm@linux-foundation.org
Subject: + dax-fix-race-between-colliding-pmd-pte-entries-fix.patch added
 to -mm tree
Date: Wed, 31 May 2017 14:25:07 -0700
Message-ID: <592f34b3.GXclfz5HOgFF+USi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53862 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdEaVZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 17:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, pawel.lebioda@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: improve fix for colliding PMD & PTE entries
has been added to the -mm tree.  Its filename is
     dax-fix-race-between-colliding-pmd-pte-entries-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-race-between-colliding-pmd-pte-entries-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-race-between-colliding-pmd-pte-entries-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: improve fix for colliding PMD & PTE entries

This commit, which has not yet made it upstream but is in the -mm tree:

    dax: Fix race between colliding PMD & PTE entries

fixed a pair of race conditions where racing DAX PTE and PMD faults could
corrupt page tables.  This fix had two shortcomings which are addressed by
this patch:

1) In the PTE fault handler we only checked for a collision using
   pmd_devmap().  The pmd_devmap() check will trigger when we have raced
   with a PMD that has real DAX storage, but to account for the case where
   we collide with a huge zero page entry we also need to check for
   pmd_trans_huge().

2) In the PMD fault handler we only continued with the fault if no PMD
   at all was present (pmd_none()).  This is the case when we are faulting
   in a PMD for the first time, but there are two other cases to consider.
   The first is that we are servicing a write fault over a PMD huge zero
   page, which we detect with pmd_trans_huge().  The second is that we are
   servicing a write fault over a DAX PMD with real storage, which we
   address with pmd_devmap().

Fix both of these, and instead of manually triggering a fallback in the
PMD collision case instead be consistent with the other collision
detection code in the fault handlers and just retry.

Link: http://lkml.kernel.org/r/20170526195932.32178-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Pawel Lebioda <pawel.lebioda@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/dax.c~dax-fix-race-between-colliding-pmd-pte-entries-fix fs/dax.c
--- a/fs/dax.c~dax-fix-race-between-colliding-pmd-pte-entries-fix
+++ a/fs/dax.c
@@ -1160,7 +1160,7 @@ static int dax_iomap_pte_fault(struct vm
 	 * the PTE we need to set up.  If so just return and the fault will be
 	 * retried.
 	 */
-	if (pmd_devmap(*vmf->pmd)) {
+	if (pmd_trans_huge(*vmf->pmd) || pmd_devmap(*vmf->pmd)) {
 		vmf_ret = VM_FAULT_NOPAGE;
 		goto unlock_entry;
 	}
@@ -1411,11 +1411,14 @@ static int dax_iomap_pmd_fault(struct vm
 	/*
 	 * It is possible, particularly with mixed reads & writes to private
 	 * mappings, that we have raced with a PTE fault that overlaps with
-	 * the PMD we need to set up.  If so we just fall back to a PTE fault
-	 * ourselves.
+	 * the PMD we need to set up.  If so just return and the fault will be
+	 * retried.
 	 */
-	if (!pmd_none(*vmf->pmd))
+	if (!pmd_none(*vmf->pmd) && !pmd_trans_huge(*vmf->pmd) &&
+			!pmd_devmap(*vmf->pmd)) {
+		result = 0;
 		goto unlock_entry;
+	}
 
 	/*
 	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-avoid-spurious-bad-pmd-warning-messages.patch
dax-fix-race-between-colliding-pmd-pte-entries.patch
dax-fix-race-between-colliding-pmd-pte-entries-fix.patch

