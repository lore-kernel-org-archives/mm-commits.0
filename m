From: akpm@linux-foundation.org
Subject: + mm-mlock-remove-lru_add_drain_all.patch added to -mm tree
Date: Fri, 20 Oct 2017 15:15:23 -0700
Message-ID: <59ea757b.Oy0y7CGtYhf55LY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbdJTWPZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2017 18:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, bsingharora@gmail.com, gthelen@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mingo@kernel.org, vbabka@suse.cz, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: remove lru_add_drain_all()
has been added to the -mm tree.  Its filename is
     mm-mlock-remove-lru_add_drain_all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-remove-lru_add_drain_all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-remove-lru_add_drain_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: mlock: remove lru_add_drain_all()

lru_add_drain_all() is not required by mlock() and it will drain
everything that has been cached at the time mlock is called.  And that is
not really related to the memory which will be faulted in (and cached) and
mlocked by the syscall itself.

If anything lru_add_drain_all() should be called _after_ pages have been
mlocked and faulted in but even that is not strictly needed because those
pages would get to the appropriate LRUs lazily during the reclaim path. 
Moreover follow_page_pte (gup) will drain the local pcp LRU cache.

On larger machines the overhead of lru_add_drain_all() in mlock() can be
significant when mlocking data already in memory.  We have observed high
latency in mlock() due to lru_add_drain_all() when the users were mlocking
in memory tmpfs files.

[mhocko@suse.com: changelog fix]
Link: http://lkml.kernel.org/r/20171019222507.2894-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mlock.c~mm-mlock-remove-lru_add_drain_all mm/mlock.c
--- a/mm/mlock.c~mm-mlock-remove-lru_add_drain_all
+++ a/mm/mlock.c
@@ -669,8 +669,6 @@ static __must_check int do_mlock(unsigne
 	if (!can_do_mlock())
 		return -EPERM;
 
-	lru_add_drain_all();	/* flush pagevec */
-
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
@@ -797,9 +795,6 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		return -EPERM;
 
-	if (flags & MCL_CURRENT)
-		lru_add_drain_all();	/* flush pagevec */
