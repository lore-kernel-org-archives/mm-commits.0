From: akpm@linux-foundation.org
Subject: +
 mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch
 added to -mm tree
Date: Thu, 07 Jul 2016 17:20:22 -0700
Message-ID: <577ef1c6.4s+KP5Bsdx+kyJhm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbcGHAUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2016 20:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix
has been added to the -mm tree.  Its filename is
     mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix

Link: http://lkml.kernel.org/r/20160707194024.GA26580@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix
+++ a/include/linux/mm.h
@@ -975,6 +975,7 @@ static inline struct mem_cgroup *page_me
 }
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	return READ_ONCE(page->mem_cgroup);
 }
 #else
@@ -984,6 +985,7 @@ static inline struct mem_cgroup *page_me
 }
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	return NULL;
 }
 #endif
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-fix-idr-leak-for-the-first-cgroup-root.patch
cgroup-remove-unnecessary-0-check-from-css_from_id.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs.patch
mm-memcontrol-fix-cgroup-creation-failure-after-many-small-jobs-fix.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

