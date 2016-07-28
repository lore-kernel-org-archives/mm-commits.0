From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch
 removed from -mm tree
Date: Thu, 28 Jul 2016 14:50:20 -0700
Message-ID: <579a7e1c.Qic34jJpWix/9utU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcG1VuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 17:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

This patch was dropped because it was folded into mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

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

mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch

