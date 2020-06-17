From: akpm@linux-foundation.org
Subject: + mm-do_swap_page-fix-up-the-error-code-instantiation.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 13:01:37 -0700
Message-ID: <20200617200137.Ibmq9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgFQUBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 16:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shakeelb@google.com, kirill@shutemov.name, js1304@gmail.com, hughd@google.com, hannes@cmpxchg.org, guro@fb.com, alex.shi@linux.alibaba.com, mhocko@suse.com


The patch titled
     Subject: mm: do_swap_page(): fix up the error code
has been added to the -mm tree.  Its filename is
     mm-do_swap_page-fix-up-the-error-code-instantiation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do_swap_page-fix-up-the-error-code-instantiation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do_swap_page-fix-up-the-error-code-instantiation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: do_swap_page(): fix up the error code

do_swap_page() returns error codes from the VM_FAULT* space.  try_charge()
might return -ENOMEM, though, and then do_swap_page() simply returns 0
which means a success.

We almost never return ENOMEM for GFP_KERNEL single page charge.  Except
for async OOM handling (oom_disabled v1).  So this needs translation to
VM_FAULT_OOM otherwise the the page fault path will not notify the
userspace and wait for an action.

Link: http://lkml.kernel.org/r/20200617090238.GL9499@dhcp22.suse.cz
Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-do_swap_page-fix-up-the-error-code-instantiation
+++ a/mm/memory.c
@@ -3140,8 +3140,10 @@ vm_fault_t do_swap_page(struct vm_fault
 				err = mem_cgroup_charge(page, vma->vm_mm,
 							GFP_KERNEL);
 				ClearPageSwapCache(page);
-				if (err)
+				if (err) {
+					ret = VM_FAULT_OOM;
 					goto out_page;
+				}
 
 				lru_cache_add(page);
 				swap_readpage(page, true);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-do_swap_page-fix-up-the-error-code-instantiation.patch
