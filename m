From: akpm@linux-foundation.org
Subject: + mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch added to -mm tree
Date: Thu, 09 Jun 2011 16:43:32 -0700
Message-ID: <201106092343.p59NhXNC008673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab1FIXni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 19:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquini@linux.com, aarcange@redhat.com, cl@linux.com, rja@sgi.com


The patch titled
     mm: fix negative commitlimit when gigantic hugepages are allocated
has been added to the -mm tree.  Its filename is
     mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch

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
Subject: mm: fix negative commitlimit when gigantic hugepages are allocated
From: Rafael Aquini <aquini@linux.com>

When 1GB hugepages are allocated on a system, free(1) reports less
available memory than what really is installed in the box.  Also, if the
total size of hugepages allocated on a system is over half of the total
memory size, CommitLimit becomes a negative number.

The problem is that gigantic hugepages (order > MAX_ORDER) can only be
allocated at boot with bootmem, thus its frames are not accounted to
'totalram_pages'.  However, they are accounted to hugetlb_total_pages()

What happens to turn CommitLimit into a negative number is this
calculation, in fs/proc/meminfo.c:

        allowed = ((totalram_pages - hugetlb_total_pages())
                * sysctl_overcommit_ratio / 100) + total_swap_pages;

A similar calculation occurs in __vm_enough_memory() in mm/mmap.c.

Also, every vm statistic which depends on 'totalram_pages' will render
confusing values, as if system were 'missing' some part of its memory.

Reported-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Rafael Aquini <aquini@linux.com>
Acked-by: Russ Anderson <rja@sgi.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/hugetlb.c~mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated
+++ a/mm/hugetlb.c
@@ -1111,6 +1111,14 @@ static void __init gather_bootmem_preall
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
 		prep_new_huge_page(h, page, page_to_nid(page));
+
+		/* if we had gigantic hugepages allocated at boot time,
+		 * we need to reinstate the 'stolen' pages to totalram_pages,
+		 * in order to fix confusing memory reports from free(1)
+		 * and another side-effects, like CommitLimit going negative.
+		 */
+		if (h->order > (MAX_ORDER - 1))
+			totalram_pages += 1 << h->order;
 	}
 }
 
_

Patches currently in -mm which might be from aquini@linux.com are

mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix.patch

