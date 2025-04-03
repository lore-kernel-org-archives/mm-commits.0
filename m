Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB592E3387
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 04:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743653846; cv=none; b=P+YXqw6K8H6PSouv8pK9qnXB4sxdiOYxXY1L3Pbx9VQg8gxL7bMPlFYw758n0ayRW7QvWfdJOigB24gMmTgkI5+P0dVE7vz9+Zqsg685+hLsDFGddMLvXZtfVSdZ7VToB6ss8CEHurbhBSJYRi/k65L/Br8YcNFGS6kf/HY+nDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743653846; c=relaxed/simple;
	bh=GK4WBPlB3A2ZASFICtzQZyrQpAcvZ9suD8s6hGF5A/4=;
	h=Date:To:From:Subject:Message-Id; b=beXTRaYQiBOZUQvStcb6nDxkgKMwtcoYvpF4kXE/YBiFu1jqZ5FKjL0QXDuiSuUMpfKb5ALVALkV8nIZuvsGQ9QUgxPfS7wdnwFNjM38IcHkTFNlzDtyh+DCGsirfUckceWST+Hv4HdbjTNteuTjfwPpOykvHRuGkTijKptMlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wO04iS6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wO04iS6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6D4C4CEE3;
	Thu,  3 Apr 2025 04:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743653845;
	bh=GK4WBPlB3A2ZASFICtzQZyrQpAcvZ9suD8s6hGF5A/4=;
	h=Date:To:From:Subject:From;
	b=wO04iS6InH2uM5M2UbbhzX73PojYZ+fGqzUhvfpTDMa8vt9PfMZZWYJ82jc2jjrIl
	 xDz47b98RnFeEdILUhezMuafuQRA3ICk06Tj789qw9cfm8EinLjs5wc4bMJ/DfcRRe
	 UMxbwGkr5HKwtJVwCbcpeB+1/fr6orOtfLwnVZMY=
Date: Wed, 02 Apr 2025 21:17:25 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch added to mm-new branch
Message-Id: <20250403041725.CD6D4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: don't generate low/min events if either low/min or elow/emin is 0
has been added to the -mm mm-new branch.  Its filename is
     memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch

This patch will later appear in the mm-new branch at
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
From: Waiman Long <longman@redhat.com>
Subject: memcg: don't generate low/min events if either low/min or elow/emin is 0
Date: Wed, 2 Apr 2025 23:12:12 -0400

The test_memcontrol selftest consistently fails its test_memcg_low
sub-test because of the fact that two of its test child cgroups which have
a memmory.low of 0 or an effective memory.low of 0 still have low events
generated for them since mem_cgroup_below_low() use the ">=" operator when
comparing to elow.

The simple fix of changing the operator to ">", however, changes the way
memory reclaim works quite drastically leading to other failures.  So we
can't do that without some relatively riskier changes in memory reclaim.

Another simpler alternative is to avoid reporting below_low failure if
either memory.low or its effective equivalent is 0 which is done by this
patch.

With this patch applied, the test_memcg_low sub-test finishes successfully
without failure in most cases.  Though both test_memcg_low and
test_memcg_min sub-tests may fail occasionally if the memory.current
values fall outside of the expected ranges.

To be consistent, similar change is appled to mem_cgroup_below_min()
as well.

Link: https://lkml.kernel.org/r/20250403031212.317837-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0
+++ a/include/linux/memcontrol.h
@@ -601,21 +601,31 @@ static inline bool mem_cgroup_unprotecte
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long elow;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.elow) >=
-		page_counter_read(&memcg->memory);
+	elow = READ_ONCE(memcg->memory.elow);
+	if (!elow || !READ_ONCE(memcg->memory.low))
+		return false;
+
+	return page_counter_read(&memcg->memory) <= elow;
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long emin;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.emin) >=
-		page_counter_read(&memcg->memory);
+	emin = READ_ONCE(memcg->memory.emin);
+	if (!emin || !READ_ONCE(memcg->memory.min))
+		return false;
+
+	return page_counter_read(&memcg->memory) <= emin;
 }
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
_

Patches currently in -mm which might be from longman@redhat.com are

memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch

