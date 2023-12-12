Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB17210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTQIJ9P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAC7C433C7;
	Tue, 12 Dec 2023 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702406859;
	bh=R1pi4QWi3sDSihu3ScQzT5OlgKdxL/TRYIlii/42Zjk=;
	h=Date:To:From:Subject:From;
	b=PTQIJ9P80Chbbd3dX3x7dLFi+WhBOk1NQ8HyGs9c/ki3dG9hmZZJRZPg1otAp8Oqs
	 5Ej/NrpXjFSkzF/JF6hJFaKnYbEcTgdsbwiNw7Ftv/Y+aPyJu42kqoB90Vrlpit6Aa
	 fqR4GB0Rv3I0WQcT8EivAckEP7UBF9iGVJ/ZQ+wA=
Date: Tue, 12 Dec 2023 10:47:38 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-make-shrinking-memcg-aware-fix.patch removed from -mm tree
Message-Id: <20231212184739.8EAC7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: make shrinking memcg-aware (fix)
has been removed from the -mm tree.  Its filename was
     zswap-make-shrinking-memcg-aware-fix.patch

This patch was dropped because it was folded into zswap-make-shrinking-memcg-aware.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: make shrinking memcg-aware (fix)
Date: Tue, 5 Dec 2023 11:54:19 -0800

Use the correct function for the onlineness check for the memcg selection,
and use mem_cgroup_iter_break() to break the iteration.

Link: https://lkml.kernel.org/r/20231205195419.2563217-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix
+++ a/mm/zswap.c
@@ -834,9 +834,9 @@ static void shrink_worker(struct work_st
 			goto resched;
 		}
 
-		if (!mem_cgroup_online(memcg)) {
+		if (!mem_cgroup_tryget_online(memcg)) {
 			/* drop the reference from mem_cgroup_iter() */
-			mem_cgroup_put(memcg);
+			mem_cgroup_iter_break(NULL, memcg);
 			pool->next_shrink = NULL;
 			spin_unlock(&zswap_pools_lock);
 
@@ -985,7 +985,7 @@ static void zswap_pool_destroy(struct zs
 	list_lru_destroy(&pool->list_lru);
 
 	spin_lock(&zswap_pools_lock);
-	mem_cgroup_put(pool->next_shrink);
+	mem_cgroup_iter_break(NULL, pool->next_shrink);
 	pool->next_shrink = NULL;
 	spin_unlock(&zswap_pools_lock);
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-make-shrinking-memcg-aware.patch
zswap-make-shrinking-memcg-aware-fix-2.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch
zswap-memcontrol-implement-zswap-writeback-disabling.patch

