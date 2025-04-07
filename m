Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA3B665
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987588; cv=none; b=XkObsi8wQcLfhSRod90ZoElAm03CuIIE/KXjCDThschGDXpVcnSl0fA80+hjcPplSS43kEJkL0j4J3Q08cBFohF3U+DVzlSbaNPcjNtcLCMA17YsLcQ36iF5q+Jby659bM/2dYnzGgGrvYcfA/HZGwCeLD8S7M6eIgb6zvFI7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987588; c=relaxed/simple;
	bh=p+9hQcRAm2wf8YRj4a6jEpT05tKd/CjdI48dlaN2CWU=;
	h=Date:To:From:Subject:Message-Id; b=StiGKK4iu0myh2I83RwWBBiWqkHUb9cVGURbUAid3tLZXkxoHf3ZFoTJ2M6aoMLIzrfl/yuxyb0v+mzUZhCyFYCiXJpJ0SzRTTTkC6eH72TVbCFZWiFLyPPc3oYCAhk0311v2QoCVj3bYHCxwF/ilkxzFY+B/fmf3qqd4snl3mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRr66CUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRr66CUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05729C4CEEA;
	Mon,  7 Apr 2025 00:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987588;
	bh=p+9hQcRAm2wf8YRj4a6jEpT05tKd/CjdI48dlaN2CWU=;
	h=Date:To:From:Subject:From;
	b=WRr66CUrk8f6FnxiubdAClSvCHsnMdZmi4QDo/Y2JWpET5jbqXP8loghz0nP/9tAB
	 F6J6t63fhZbXmBp4hBT+B/ztKLuy7a5EH3IAOSsilU7YlK1uSObhEAWykxCezlZMr+
	 HdkEidLykLG575SSdroe2ILgkG2M4FaxZP2DKjkQ=
Date: Sun, 06 Apr 2025 17:59:47 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch removed from -mm tree
Message-Id: <20250407005948.05729C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: don't generate low/min events if either low/min or elow/emin is 0
has been removed from the -mm tree.  Its filename was
     memcg-dont-generate-low-min-events-if-either-low-min-or-elow-emin-is-0.patch

This patch was dropped because an updated version will be issued

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


