Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11EB253B76
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744050688; cv=none; b=hxmuwO3JcyvkZbKdk0BymAWbUQRuEQ1PJDMep78h8gAbPMYG1tgrt/MnR7NcpCu1Ul0h1aL6/Uesd0TzI9h4NHvTgz/xLTrTX7JvvO3QeTrhigTlkMAYAQ5Aj7sRGWTawdPI1e6xCJL+uYFiNcaXumic3aeicGn1X32T2/HN8ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744050688; c=relaxed/simple;
	bh=WQ7O67BuTIe6ssIxh2JSx4wTeS8xfMjeioyJZh3Z9dw=;
	h=Date:To:From:Subject:Message-Id; b=iGqXqRfzOq7FxxqjYVEgmsEBhRxRqec3sbebbSPu3Ny6ZmS4yvNqvGUUNB/+2XXdVmS/E1dEJANzC6yxh78LvhWCXg6dX+rMq4OcfGxB7GoujazD0ZSczqdZor5ZFJi8By1d0WxRyLcMxFKrrkc6oJEZKlzJZZTjdCw+O5t8tNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eYvEleEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eYvEleEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4BEC4CEDD;
	Mon,  7 Apr 2025 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744050687;
	bh=WQ7O67BuTIe6ssIxh2JSx4wTeS8xfMjeioyJZh3Z9dw=;
	h=Date:To:From:Subject:From;
	b=eYvEleEN0VnWBgqOPLjgEdHsqeNncMfYxbr51h8Ebuq/hG6B2WmQrw0mvtfb3Lb+Q
	 rdXG3PCnFumg8qBaVEqpUqvHbQD59xsiUeNm25fOQ93jc9jMt58Sw+1YCcJtCWIqDS
	 6wPbHH8oPW7cfJ59gYGUrVEnj9eoYsQz38yBVcJs=
Date: Mon, 07 Apr 2025 11:31:26 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5.patch added to mm-new branch
Message-Id: <20250407183127.4D4BEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: Skip memcg with !usage in shrink_node_memcgs()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5.patch

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
Subject: mm/vmscan: Skip memcg with !usage in shrink_node_memcgs()
Date: Mon, 7 Apr 2025 12:23:15 -0400

use mem_cgroup_usage() as originally suggested by Johannes

Link: https://lkml.kernel.org/r/20250407162316.1434714-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h      |    9 +++++++++
 mm/memcontrol-v1.h |    2 --
 mm/vmscan.c        |    8 +-------
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/internal.h~mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5
+++ a/mm/internal.h
@@ -1538,6 +1538,15 @@ void __meminit __init_page_from_nid(unsi
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+#ifdef CONFIG_MEMCG
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
+#else
+static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	return 1UL;
+}
+#endif
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
--- a/mm/memcontrol-v1.h~mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5
+++ a/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
--- a/mm/vmscan.c~mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5
+++ a/mm/vmscan.c
@@ -5934,7 +5934,6 @@ static inline bool should_continue_recla
 	return inactive_lru_pages > pages_for_compaction;
 }
 
-#ifdef CONFIG_MEMCG
 static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
@@ -5973,7 +5972,7 @@ static void shrink_node_memcgs(pg_data_t
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
 		/* Skip memcg with no usage */
-		if (!page_counter_read(&memcg->memory))
+		if (!mem_cgroup_usage(memcg, false))
 			continue;
 
 		if (mem_cgroup_below_min(target_memcg, memcg)) {
@@ -6017,11 +6016,6 @@ static void shrink_node_memcgs(pg_data_t
 		}
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
 }
-#else
-static inline void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
-{
-}
-#endif /* CONFIG_MEMCG */
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
_

Patches currently in -mm which might be from longman@redhat.com are

mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs.patch
mm-vmscan-skip-memcg-with-usage-in-shrink_node_memcgs-v5.patch
selftests-memcg-increase-error-tolerance-of-child-memorycurrent-check-in-test_memcg_protection.patch

