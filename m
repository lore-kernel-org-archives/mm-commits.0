Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B9973477
	for <mm-commits@vger.kernel.org>; Sun, 28 Jul 2024 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722200245; cv=none; b=PH3OqiyIdAswz5yyXzxW8GzQ8cs9vlRw4/g6drC5hR4jylLjBb/mB29tnhjyWpmv28hTEgbJJ9HltZUN8AyTy0K0yzRV1iK1NlKuFzCXjsYojLjNMgLxLv4U3ebq66rlpQN55aM9w/drGSU2G/9FTC17wD1qFUzbvNNEfLnY/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722200245; c=relaxed/simple;
	bh=Pb4FS0uaK9DgBAJ6ZljO34QMqpUSn3fiGIlS+ieSQNw=;
	h=Date:To:From:Subject:Message-Id; b=kvqDP96/2zF5X30Fl1Et5GwEf9XPIsVA4hnCv6Jp3tCl8xuYOFsU/EF2a8GaSzIHwkntKu6j1Lq4v5Gpnzx8dZyH/FlsO9Q/DmD3Qscq1g189LdDdExNhYIo2xZd7YbVwDaN24kV6kNz/k3cOPjjg8LsiUR3Oo3niCg1cIepfmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=so7qoQ+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="so7qoQ+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F380C116B1;
	Sun, 28 Jul 2024 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722200245;
	bh=Pb4FS0uaK9DgBAJ6ZljO34QMqpUSn3fiGIlS+ieSQNw=;
	h=Date:To:From:Subject:From;
	b=so7qoQ+EKvqRWmUY+4rb4ReGGTh3pWQLi8CljxHSHl5cOt+AfhOMtAYFXm8fv7WhM
	 IKKOqbsNJbQT2r3JTtjC2Hj7fDsLBlGKp2GwnE8S8rdmfZQ/SgNxpsRw17/s3igV/I
	 MwKRJcKptfqL9BoErKkhlPmqFa/HUxXlPL7NFH10=
Date: Sun, 28 Jul 2024 13:57:24 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-dont-call-propagate_protected_usage-needlessly.patch added to mm-unstable branch
Message-Id: <20240728205725.0F380C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: don't call propagate_protected_usage() needlessly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-dont-call-propagate_protected_usage-needlessly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-dont-call-propagate_protected_usage-needlessly.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: don't call propagate_protected_usage() needlessly
Date: Fri, 26 Jul 2024 20:31:08 +0000

Patch series "mm: memcg: page counters optimizations", v3.

This patchset contains 3 independent small optimizations of page counters.


This patch (of 3):

Memory protection (min/low) requires a constant tracking of protected
memory usage.  propagate_protected_usage() is called on each page counters
update and does a number of operations even in cases when the actual
memory protection functionality is not supported (e.g.  hugetlb cgroups or
memcg swap counters).

It's obviously inefficient and leads to a waste of CPU cycles.  It can be
addressed by calling propagate_protected_usage() only for the counters
which do support memory guarantees.  As of now it's only memcg->memory -
the unified memory memcg counter.

Link: https://lkml.kernel.org/r/20240726203110.1577216-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    8 +++++++-
 mm/hugetlb_cgroup.c          |    4 ++--
 mm/memcontrol.c              |   16 ++++++++--------
 mm/page_counter.c            |   16 +++++++++++++---
 4 files changed, 30 insertions(+), 14 deletions(-)

--- a/include/linux/page_counter.h~mm-memcg-dont-call-propagate_protected_usage-needlessly
+++ a/include/linux/page_counter.h
@@ -32,6 +32,7 @@ struct page_counter {
 	/* Keep all the read most fields in a separete cacheline. */
 	CACHELINE_PADDING(_pad2_);
 
+	bool protection_support;
 	unsigned long min;
 	unsigned long low;
 	unsigned long high;
@@ -45,12 +46,17 @@ struct page_counter {
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
 #endif
 
+/*
+ * Protection is supported only for the first counter (with id 0).
+ */
 static inline void page_counter_init(struct page_counter *counter,
-				     struct page_counter *parent)
+				     struct page_counter *parent,
+				     bool protection_support)
 {
 	atomic_long_set(&counter->usage, 0);
 	counter->max = PAGE_COUNTER_MAX;
 	counter->parent = parent;
+	counter->protection_support = protection_support;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
--- a/mm/hugetlb_cgroup.c~mm-memcg-dont-call-propagate_protected_usage-needlessly
+++ a/mm/hugetlb_cgroup.c
@@ -114,10 +114,10 @@ static void hugetlb_cgroup_init(struct h
 		}
 		page_counter_init(hugetlb_cgroup_counter_from_cgroup(h_cgroup,
 								     idx),
-				  fault_parent);
+				  fault_parent, false);
 		page_counter_init(
 			hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx),
-			rsvd_parent);
+			rsvd_parent, false);
 
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
--- a/mm/memcontrol.c~mm-memcg-dont-call-propagate_protected_usage-needlessly
+++ a/mm/memcontrol.c
@@ -3585,21 +3585,21 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
-		page_counter_init(&memcg->memory, &parent->memory);
-		page_counter_init(&memcg->swap, &parent->swap);
+		page_counter_init(&memcg->memory, &parent->memory, true);
+		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
-		page_counter_init(&memcg->kmem, &parent->kmem);
-		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
+		page_counter_init(&memcg->kmem, &parent->kmem, false);
+		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
 #endif
 	} else {
 		init_memcg_stats();
 		init_memcg_events();
-		page_counter_init(&memcg->memory, NULL);
-		page_counter_init(&memcg->swap, NULL);
+		page_counter_init(&memcg->memory, NULL, true);
+		page_counter_init(&memcg->swap, NULL, false);
 #ifdef CONFIG_MEMCG_V1
-		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcpmem, NULL);
+		page_counter_init(&memcg->kmem, NULL, false);
+		page_counter_init(&memcg->tcpmem, NULL, false);
 #endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
--- a/mm/page_counter.c~mm-memcg-dont-call-propagate_protected_usage-needlessly
+++ a/mm/page_counter.c
@@ -13,6 +13,11 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
+static bool track_protection(struct page_counter *c)
+{
+	return c->protection_support;
+}
+
 static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
@@ -57,7 +62,8 @@ void page_counter_cancel(struct page_cou
 		new = 0;
 		atomic_long_set(&counter->usage, new);
 	}
-	propagate_protected_usage(counter, new);
+	if (track_protection(counter))
+		propagate_protected_usage(counter, new);
 }
 
 /**
@@ -70,12 +76,14 @@ void page_counter_cancel(struct page_cou
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
+	bool protection = track_protection(counter);
 
 	for (c = counter; c; c = c->parent) {
 		long new;
 
 		new = atomic_long_add_return(nr_pages, &c->usage);
-		propagate_protected_usage(c, new);
+		if (protection)
+			propagate_protected_usage(c, new);
 		/*
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
@@ -112,6 +120,7 @@ bool page_counter_try_charge(struct page
 			     struct page_counter **fail)
 {
 	struct page_counter *c;
+	bool protection = track_protection(counter);
 
 	for (c = counter; c; c = c->parent) {
 		long new;
@@ -141,7 +150,8 @@ bool page_counter_try_charge(struct page
 			*fail = c;
 			goto failed;
 		}
-		propagate_protected_usage(c, new);
+		if (protection)
+			propagate_protected_usage(c, new);
 
 		/* see comment on page_counter_charge */
 		if (new > READ_ONCE(c->local_watermark)) {
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-dont-call-propagate_protected_usage-needlessly.patch
mm-page_counters-put-page_counter_calculate_protection-under-config_memcg.patch
mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

