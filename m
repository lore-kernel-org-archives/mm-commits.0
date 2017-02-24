From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:40:27 -0800
Message-ID: <58b0b65b.71kb3bZQwUVHNOa9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbdBXWk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mgorman@techsingularity.net, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/autonuma: don't mark pte saved write in case of dirty_accountable
has been removed from the -mm tree.  Its filename was
     mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3-fix.patch

This patch was dropped because it was folded into mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/autonuma: don't mark pte saved write in case of dirty_accountable

We never request for protection update with ditry_accountable set and
prot_numa set.  Hence mark the pte with mkwrite instead mk_savedwrite.

Found this when running stress-ng test with debug check enabled.  This
trigger the VM_BUG_ON in pte_mk_savedwrite()

Fixes: http://ozlabs.org/~akpm/mmots/broken-out/mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

Link: http://lkml.kernel.org/r/1487942884-16517-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mprotect.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3-fix mm/mprotect.c
--- a/mm/mprotect.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3-fix
+++ a/mm/mprotect.c
@@ -105,7 +105,7 @@ static unsigned long change_pte_range(st
 			if (dirty_accountable && pte_dirty(ptent) &&
 					(pte_soft_dirty(ptent) ||
 					 !(vma->vm_flags & VM_SOFTDIRTY))) {
-				ptent = pte_mk_savedwrite(ptent);
+				ptent = pte_mkwrite(ptent);
 			}
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
 			pages++;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch
mm-gup-check-for-protnone-only-if-it-is-a-pte-entry.patch
mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

