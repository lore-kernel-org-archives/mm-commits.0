Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE94B364058
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388576; cv=none; b=p7RdQnwcOaN5AuMtCWLTt0dr7rMKRjo+Z9VHg0qiNgrTLHOXnI5kss3JWhgiiWZhgtWnDws53nnmhkjIQI1FgKttW6HiA9RgI14xwWTSw2n4zvl3q//KbwofierlMl7ownf9+oJkz+ho4fmWrfWsGVfLniBE6oMIa3R7DU/Gh4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388576; c=relaxed/simple;
	bh=D66mFzzf6rVfvxeUH+t/83qMyNO3RiqyyE1fX54TKQw=;
	h=Date:To:From:Subject:Message-Id; b=RKLZod/dCoYEg6lbGUhKKCbCjzkD6tRmRDsIGmeJpsNHABfIyPLMciPwVW8rw/putrSWFl5Xta77Wa4e2i3sDSp514//WOfAtglUPyfN/87UBR9sKoUQ2IVrcFh6vl6mGbI+chsHpz8VsoKHPBfnQ+TZNI2u6Bt4e1zGdKnyI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tsrFv1YQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tsrFv1YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D92C19424;
	Tue, 24 Mar 2026 21:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388576;
	bh=D66mFzzf6rVfvxeUH+t/83qMyNO3RiqyyE1fX54TKQw=;
	h=Date:To:From:Subject:From;
	b=tsrFv1YQZYgLN6/ZaBphigzqDY5m2T8kLOlClZitFIAL+aK4yR4sjDM/F740yltoG
	 kmpaKKIRp7/pGDdJBvXO97tsKc8L7qmimmnd4cYNk/T5l+z3pXDnreLEMjUhfo9/nl
	 L0aGyXzwNfdwffNqxbW4awRx1wRfcj/4Xh5I68AQ=
Date: Tue, 24 Mar 2026 14:42:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch removed from -mm tree
Message-Id: <20260324214256.B7D92C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_notifiers: use hlist_for_each_entry_srcu() for SRCU list traversal
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifiers-use-hlist_for_each_entry_srcu-for-srcu-list-traversal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -713,7 +713,7 @@ find_get_mmu_notifier(struct mm_struct *
 	struct mmu_notifier *subscription;
 
 	spin_lock(&mm->notifier_subscriptions->lock);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 lockdep_is_held(&mm->notifier_subscriptions->lock)) {
 		if (subscription->ops != ops)
_

Patches currently in -mm which might be from lirongqing@baidu.com are


