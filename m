From: akpm@linux-foundation.org
Subject: + mm-make-the-try_to_munlock-void-function-fix.patch added to -mm tree
Date: Tue, 11 Apr 2017 14:01:28 -0700
Message-ID: <58ed4428.GtW7QrX7LaLNZWDS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753521AbdDKVB3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 17:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, alexander.levin@verizon.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove PG_Mlocked VM_BUG_ON check
has been added to the -mm tree.  Its filename is
     mm-make-the-try_to_munlock-void-function-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-the-try_to_munlock-void-function-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-the-try_to_munlock-void-function-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove PG_Mlocked VM_BUG_ON check

Caller of try_to_munlock doesn't guarantee he pass the page with clearing
PG_mlocked.  Look at __munlock_pagevec which doesn't hold any PG_lock so
anybody can set PG_mlocked under us.  Remove bogus PageMlocked check in
try_to_munlock.

Link: http://lkml.kernel.org/r/20170411025615.GA6545@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <alexander.levin@verizon.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/rmap.c~mm-make-the-try_to_munlock-void-function-fix mm/rmap.c
--- a/mm/rmap.c~mm-make-the-try_to_munlock-void-function-fix
+++ a/mm/rmap.c
@@ -1565,7 +1565,6 @@ void try_to_munlock(struct page *page)
 	};
 
 	VM_BUG_ON_PAGE(!PageLocked(page) || PageLRU(page), page);
-	VM_BUG_ON_PAGE(PageMlocked(page), page);
 	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
 	rmap_walk(page, &rwc);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch

