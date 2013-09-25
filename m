From: akpm@linux-foundation.org
Subject: +
 mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch added to -mm tree
Date: Wed, 25 Sep 2013 16:27:57 -0700
Message-ID: <5243717d.wJpjXZF42ZHTTNC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3IYX2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 19:28:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, fengguang.wu@intel.com, bob.liu@oracle.com, vbabka@suse.cz

Subject: + mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch added to -mm tree
To: vbabka@suse.cz,bob.liu@oracle.com,fengguang.wu@intel.com,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 16:27:57 -0700


The patch titled
     Subject: mm/mlock.c: prevent walking off the end of a pagetable in no-pmd configuration
has been added to the -mm tree.  Its filename is
     mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mlock.c: prevent walking off the end of a pagetable in no-pmd configuration

The function __munlock_pagevec_fill() introduced in 7a8010cd3 ("mm:
munlock: manual pte walk in fast path instead of follow_page_mask()") uses
pmd_addr_end() for restricting its operation within current page table. 
This is insufficient on architectures/configurations where pmd is folded
and pmd_addr_end() just returns the end of the full range to be walked. 
In this case, it allows pte++ to walk off the end of a page table
resulting in unpredictable behaviour.

This patch fixes the function by using pgd_addr_end() and pud_addr_end()
before pmd_addr_end(), which will yield correct page table boundary on all
configurations.  This is similar to what existing page walkers do when
walking each level of the page table.

Additionaly, the patch clarifies a comment for get_locked_pte() call in the
function.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Jörn Engel <joern@logfs.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration mm/mlock.c
--- a/mm/mlock.c~mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration
+++ a/mm/mlock.c
@@ -379,10 +379,14 @@ static unsigned long __munlock_pagevec_f
 
 	/*
 	 * Initialize pte walk starting at the already pinned page where we
-	 * are sure that there is a pte.
+	 * are sure that there is a pte, as it was pinned under the same
+	 * mmap_sem write op.
 	 */
 	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
-	end = min(end, pmd_addr_end(start, end));
+	/* Make sure we do not cross the page table boundary */
+	end = pgd_addr_end(start, end);
+	end = pud_addr_end(start, end);
+	end = pmd_addr_end(start, end);
 
 	/* The page next to the pinned page is the first we will try to get */
 	start += PAGE_SIZE;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mlockc-prevent-walking-off-the-end-of-a-pagetable-in-no-pmd-configuration.patch

