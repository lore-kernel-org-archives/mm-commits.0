Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED88F309EE3
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 23:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771630071; cv=none; b=edOtEQG7aN0tJ5yJzL+YSbRcMbCMKQN+BqDmGbq1/9YBIgdMmCgbs5gKLmj+C/czpL0mQjKgszY4eNrVXmFxbcq0lDJvDsaoHAnft21jzrfqN06JptbRCk2NNfe3IqJjJePMkWB8g0lLPPLdcq3nRmMuEh8DZ3vE4onia0zgFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771630071; c=relaxed/simple;
	bh=Elxfu4xGllXv0V5dtDIAw+uzLYe4vFWzFcA5gvoJppw=;
	h=Date:To:From:Subject:Message-Id; b=lRXNdnoMh028mXTsM9gIENOUldVIi8TOMKK+Pq02e/13BwQjQnrlAqFO+sysf2s3Bl6k8ByghEJ6QjNNi20Aw5YQUWdhRKnCIhVCy2JZgR51N01kFM7Uqo5WOPgo027aLyCxxnEg21j2nd8ByAhoqsga5IdsiawhC6vIyOZaDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObKTOqTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObKTOqTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648C0C116C6;
	Fri, 20 Feb 2026 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771630070;
	bh=Elxfu4xGllXv0V5dtDIAw+uzLYe4vFWzFcA5gvoJppw=;
	h=Date:To:From:Subject:From;
	b=ObKTOqTdcJbs0C0QPYgzpekseNiwlpGERmy/Jpw3P7RzM9ZoPB7f+M3X6j416R9RA
	 lOBa8QGCxe2E8enYSQt0n08ps6+aFM4UpNKCPdSSBJZ+wsdDKx5s46sgfeip22WRzF
	 Yyihn140xvs2pk+Yf0UOFzssqSy8y8s8Fyo+ozws=
Date: Fri, 20 Feb 2026 15:27:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch added to mm-new branch
Message-Id: <20260220232750.648C0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_notifiers: use hlist_for_each_entry_srcu() for SRCU list traversal
has been added to the -mm mm-new branch.  Its filename is
     mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Li RongQing <lirongqing@baidu.com>
Subject: mm/mmu_notifiers: use hlist_for_each_entry_srcu() for SRCU list traversal
Date: Wed, 4 Feb 2026 03:09:37 -0500

The mmu_notifier_subscriptions list is protected by SRCU.  While the
current code uses hlist_for_each_entry_rcu() with an explicit SRCU lockdep
check, it is more appropriate to use the dedicated
hlist_for_each_entry_srcu() macro.

This change aligns the code with the preferred kernel API for
SRCU-protected lists, improving code clarity and ensuring that the
synchronization method is explicitly documented by the iterator name
itself.

Link: https://lkml.kernel.org/r/20260204080937.2472-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal
+++ a/mm/mmu_notifier.c
@@ -309,7 +309,7 @@ static void mn_hlist_release(struct mmu_
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu))
 		/*
 		 * If ->release runs before mmu_notifier_unregister it must be
@@ -372,7 +372,7 @@ int __mmu_notifier_clear_flush_young(str
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_flush_young)
@@ -392,7 +392,7 @@ int __mmu_notifier_clear_young(struct mm
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_young)
@@ -411,7 +411,7 @@ int __mmu_notifier_test_young(struct mm_
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->test_young) {
@@ -466,7 +466,7 @@ static int mn_hlist_invalidate_range_sta
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		const struct mmu_notifier_ops *ops = subscription->ops;
 
@@ -504,7 +504,7 @@ static int mn_hlist_invalidate_range_sta
 		 * notifiers and one or more failed start, any that succeeded
 		 * start are expecting their end to be called.  Do so now.
 		 */
-		hlist_for_each_entry_rcu(subscription, &subscriptions->list,
+		hlist_for_each_entry_srcu(subscription, &subscriptions->list,
 					 hlist, srcu_read_lock_held(&srcu)) {
 			if (!subscription->ops->invalidate_range_end)
 				continue;
@@ -542,7 +542,7 @@ mn_hlist_invalidate_end(struct mmu_notif
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->invalidate_range_end) {
 			if (!mmu_notifier_range_blockable(range))
@@ -577,7 +577,7 @@ void __mmu_notifier_arch_invalidate_seco
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->arch_invalidate_secondary_tlbs)
@@ -714,7 +714,7 @@ find_get_mmu_notifier(struct mm_struct *
 	struct mmu_notifier *subscription;
 
 	spin_lock(&mm->notifier_subscriptions->lock);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 lockdep_is_held(&mm->notifier_subscriptions->lock)) {
 		if (subscription->ops != ops)
_

Patches currently in -mm which might be from lirongqing@baidu.com are

mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch

