From: akpm@linux-foundation.org
Subject: + mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch added to -mm tree
Date: Mon, 19 Oct 2015 14:13:30 -0700
Message-ID: <56255cfa.pOOj12Y2EH95sgd2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbbJSVNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not inc NR_PAGETABLE if ptlock_init failed
has been added to the -mm tree.  Its filename is
     mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: do not inc NR_PAGETABLE if ptlock_init failed

If ALLOC_SPLIT_PTLOCKS is defined, ptlock_init may fail, in which case we
shouldn't increment NR_PAGETABLE.

Since small allocations, such as ptlock, normally do not fail (currently
they can fail if kmemcg is used though), this patch does not really fix
anything and should be considered as a code cleanup.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-do-not-inc-nr_pagetable-if-ptlock_init-failed include/linux/mm.h
--- a/include/linux/mm.h~mm-do-not-inc-nr_pagetable-if-ptlock_init-failed
+++ a/include/linux/mm.h
@@ -1606,8 +1606,10 @@ static inline void pgtable_init(void)
 
 static inline bool pgtable_page_ctor(struct page *page)
 {
+	if (!ptlock_init(page))
+		return false;
 	inc_zone_page_state(page, NR_PAGETABLE);
-	return ptlock_init(page);
+	return true;
 }
 
 static inline void pgtable_page_dtor(struct page *page)
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

slab_common-rename-cache-create-destroy-helpers.patch
slab_common-clear-pointers-to-per-memcg-caches-on-destroy.patch
slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch
memcg-simplify-charging-kmem-pages.patch
memcg-unify-slab-and-other-kmem-pages-charging.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

