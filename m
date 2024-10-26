Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1769E170A1B
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729983687; cv=none; b=VvrUr6A+mysXpq38pGKsehYU75iljcBAhD4PAme15MCCPr96N6tHPgjcluI0JNkTBdGI424dBQq960ux+m/GAvbOqzn9AUe4Py5U3kVF7kZZtQaW1m/tbg8tjWAHKNfG06giOUUMDaYuMslHjUWAEYCVN2Teomrp92Z28SQsVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729983687; c=relaxed/simple;
	bh=EkN2C7aUQgcecKw+ulhT6SD2JaYiIFYCyxd2rd7biaI=;
	h=Date:To:From:Subject:Message-Id; b=qJMLRLnHvAQJx7XQ5Ifcm9KzYYqUSQOOqHR3RDXluZ7jFWy5H2J1XaNFohgqGAICZ6w3YCJpIem09lTG+2bvfXc98quGbAqkPVdcbkTDMUQF3e6s4j0i8zc26p0aWE8Hwgz59oUGL7za8EaUxeIR2kYuLoMam6lMiZqU04Qyirg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iA/KFLTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iA/KFLTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4AAC4CEC6;
	Sat, 26 Oct 2024 23:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729983686;
	bh=EkN2C7aUQgcecKw+ulhT6SD2JaYiIFYCyxd2rd7biaI=;
	h=Date:To:From:Subject:From;
	b=iA/KFLTloOwTtWS4gPz0Bc3P2AkgHD0X0LQmMFPktr5cOEa4btYs3zusgbAAOHETB
	 0J0vfezmNfh7KXwlFyWeywe0qUs8QgkGtVfd1LPLVERkp8jSleE41btZZsk7UUAMSs
	 XDIkg4A9+p3m7vDoG+KVXbWCxj+dmfOrV99IaZs4=
Date: Sat, 26 Oct 2024 16:01:25 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,songmuchun@bytedance.com,roman.gushchin@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-workingset-remove-folio_memcg_rcu-usage.patch added to mm-unstable branch
Message-Id: <20241026230126.7B4AAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: workingset: remove folio_memcg_rcu usage
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-workingset-remove-folio_memcg_rcu-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-workingset-remove-folio_memcg_rcu-usage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: workingset: remove folio_memcg_rcu usage
Date: Sat, 26 Oct 2024 09:37:07 -0700

The function workingset_activation() is called from folio_mark_accessed()
with the guarantee that the given folio can not be freed under us in
workingset_activation().  In addition, the association of the folio and
its memcg can not be broken here because charge migration is no more. 
There is no need to use folio_memcg_rcu.  Simply use folio_memcg_charged()
because that is what this function cares about.

Link: https://lkml.kernel.org/r/20241026163707.2479526-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   35 -----------------------------------
 mm/workingset.c            |   14 ++------------
 2 files changed, 2 insertions(+), 47 deletions(-)

--- a/include/linux/memcontrol.h~memcg-workingset-remove-folio_memcg_rcu-usage
+++ a/include/linux/memcontrol.h
@@ -443,35 +443,6 @@ static inline bool folio_memcg_charged(s
 	return __folio_memcg(folio) != NULL;
 }
 
-/**
- * folio_memcg_rcu - Locklessly get the memory cgroup associated with a folio.
- * @folio: Pointer to the folio.
- *
- * This function assumes that the folio is known to have a
- * proper memory cgroup pointer. It's not safe to call this function
- * against some type of folios, e.g. slab folios or ex-slab folios.
- *
- * Return: A pointer to the memory cgroup associated with the folio,
- * or NULL.
- */
-static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
-{
-	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
-
-	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
-
-	if (memcg_data & MEMCG_DATA_KMEM) {
-		struct obj_cgroup *objcg;
-
-		objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-		return obj_cgroup_memcg(objcg);
-	}
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-}
-
 /*
  * folio_memcg_check - Get the memory cgroup associated with a folio.
  * @folio: Pointer to the folio.
@@ -1084,12 +1055,6 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
-static inline struct mem_cgroup *folio_memcg_rcu(struct folio *folio)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return NULL;
-}
-
 static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
 	return NULL;
--- a/mm/workingset.c~memcg-workingset-remove-folio_memcg_rcu-usage
+++ a/mm/workingset.c
@@ -591,22 +591,12 @@ void workingset_refault(struct folio *fo
  */
 void workingset_activation(struct folio *folio)
 {
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
 	/*
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
-	 *
-	 * XXX: See workingset_refault() - this should return
-	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	memcg = folio_memcg_rcu(folio);
-	if (!mem_cgroup_disabled() && !memcg)
-		goto out;
-	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
-out:
-	rcu_read_unlock();
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
 }
 
 /*
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch
memcg-workingset-remove-folio_memcg_rcu-usage.patch

