Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F289433A4
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247696; cv=none; b=JN7iTUsjVbtdr97zuM2ZO6lnDs3ZaTF/cVtzmKKf7GM4LM2/p7+FHisnX70Yr3SyVAWQBd6al33v0tqzCteAcaVdNn7IuHGOYCgLLyouVDSs4nO0+yfCiIyAB5XBJ6KlogVeOhljIH2n14TtXtb8RrHku6oNbH/vEMqddXBRI28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247696; c=relaxed/simple;
	bh=AnUKxjHaxyTtqNPF7cAvEuAG8INvnMIMaamKuuA6pFM=;
	h=Date:To:From:Subject:Message-Id; b=eu+qv7HmXJDP94vUN+jd0ijwTPA3LUsi64/2a/hA6Cwum//YklShJxG7b3ahwnu6rMzv2l93RvHbeCY+X9Vt3j8KSCMVwubT0CR0RlWTwkraWZgHTGOPRFCo8YQVyoNh2epFg+nVVLT9Qxoe7HsgNydjKDA4qhjOMqir5jlDFdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jnq3UJq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jnq3UJq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168A8C4CEC2;
	Mon,  2 Sep 2024 03:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247696;
	bh=AnUKxjHaxyTtqNPF7cAvEuAG8INvnMIMaamKuuA6pFM=;
	h=Date:To:From:Subject:From;
	b=Jnq3UJq379a/hfVudb4CZpMv7OZ7BtKQiQMbipHNsHelbJwA6COom4fTgp38Ou90S
	 lUDjHUI3e/lDGr7IrJv2RxVdf3MeQE7o5nRQ38NmakPaAH6VZESggn3/PhesDg6rAp
	 cpO8hm3bUpNBD7YF2nnthe0Q3S283cJdzlQb7cXU=
Date: Sun, 01 Sep 2024 20:28:15 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch removed from -mm tree
Message-Id: <20240902032816.168A8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_counters: initialize usage using ATOMIC_LONG_INIT() macro
has been removed from the -mm tree.  Its filename was
     mm-page_counters-initialize-usage-using-atomic_long_init-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: page_counters: initialize usage using ATOMIC_LONG_INIT() macro
Date: Fri, 26 Jul 2024 20:31:10 +0000

When a page_counter structure is initialized, there is no need to use an
atomic set operation to initialize the usage counter because at this point
the structure is not visible to anybody else.  ATOMIC_LONG_INIT() is what
should be used in such cases.

Link: https://lkml.kernel.org/r/20240726203110.1577216-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page_counter.h~mm-page_counters-initialize-usage-using-atomic_long_init-macro
+++ a/include/linux/page_counter.h
@@ -52,7 +52,7 @@ static inline void page_counter_init(str
 				     struct page_counter *parent,
 				     bool protection_support)
 {
-	atomic_long_set(&counter->usage, 0);
+	counter->usage = (atomic_long_t)ATOMIC_LONG_INIT(0);
 	counter->max = PAGE_COUNTER_MAX;
 	counter->parent = parent;
 	counter->protection_support = protection_support;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


