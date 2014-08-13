From: akpm@linux-foundation.org
Subject: +
 hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch
 added to -mm tree
Date: Wed, 13 Aug 2014 14:39:19 -0700
Message-ID: <53ebdb07.1jkYyBdTSrg2jxeu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:51316 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaHMVjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 17:39:20 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so95778obc.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 14:39:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked

spin_lock may be an empty struct for !SMP configurations and so
arch_spin_is_locked may return unconditional 0 and trigger the VM_BUG_ON
even when the lock is held.

Replace spin_is_locked by lockdep_assert_held.  We will not BUG anymore
but it is questionable whether crashing makes a lot of sense in the
uncharge path.  Uncharge happens after the last page reference was
released so nobody should touch the page and the function doesn't update
any shared state except for res counter which uses synchronization of its
own.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked
+++ a/mm/hugetlb_cgroup.c
@@ -217,7 +217,7 @@ void hugetlb_cgroup_uncharge_page(int id
 
 	if (hugetlb_cgroup_disabled())
 		return;
-	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
+	lockdep_assert_held(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(page);
 	if (unlikely(!h_cg))
 		return;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-hugetlb_cgroup-align-hugetlb-cgroup-limit-to-hugepage-size.patch
hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch

