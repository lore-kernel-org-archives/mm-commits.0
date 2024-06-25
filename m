Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B251913C691
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291687; cv=none; b=OaGwofDLKezgozIQJQx4ccwNyqQzPkApd3YqkF/qBaA41g8OnHgQD/oCfmM1tR/uDa0FhyrFUupSKYn7KYXpLRp693KwJYHrUpIt0dNRRuiIL/kYyYfjnMd35VpkMsPL+5AgAadLuZ8yFrksWmRYNnyPCXvfqVOpAbiUWmgARhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291687; c=relaxed/simple;
	bh=iKUhlNK3zGVMpoMlTeuh4inlFnJ9NqNdgFTp7QcY6z8=;
	h=Date:To:From:Subject:Message-Id; b=mruF3pbI0KlMC18AEbr/W5JGTGUB3ZFC6ruKHROxwyAy+uotPewuhXa88Y5LsUh3wyM3GIsiqTg3Qqb2QdLSpF1WI9xXnY7pxJygITZdwCad5v5NLjQm+uGf9buGsZrfaaeaccjm/3NCOKwgKvDYmJPEqem23YRpFsrKil14HQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rhRSuSu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rhRSuSu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA4EC32782;
	Tue, 25 Jun 2024 05:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291687;
	bh=iKUhlNK3zGVMpoMlTeuh4inlFnJ9NqNdgFTp7QcY6z8=;
	h=Date:To:From:Subject:From;
	b=rhRSuSu0IrVlMgD/ywGpaifo6WE8+N/PK8Z0iCN9thnz0Q824APJLiB65A/avJjf/
	 046tx94UbBqK8k6r5YCP91sgPRjjG6a4jVhTdsh8uqlVoWf12EDYMoyW3CePNnFl2l
	 6HI+0Ev/TFAWupvNZ9WpDW/yoZK6xW7eAB2bJIDE=
Date: Mon, 24 Jun 2024 22:01:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch removed from -mm tree
Message-Id: <20240625050127.3FA4EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
has been removed from the -mm tree.  Its filename was
     mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
Date: Tue, 11 Jun 2024 02:45:14 +0000

In preparation for introducing a similar function, rename
is_zswap_enabled() to use zswap_* prefix like other zswap functions.

Link: https://lkml.kernel.org/r/20240611024516.1375191-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/memcontrol.c       |    2 +-
 mm/zswap.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/include/linux/zswap.h
@@ -35,7 +35,7 @@ void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
-bool is_zswap_enabled(void);
+bool zswap_is_enabled(void);
 #else
 
 struct zswap_lruvec_state {};
@@ -60,7 +60,7 @@ static inline void zswap_memcg_offline_c
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
 
-static inline bool is_zswap_enabled(void)
+static inline bool zswap_is_enabled(void)
 {
 	return false;
 }
--- a/mm/memcontrol.c~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/mm/memcontrol.c
@@ -8433,7 +8433,7 @@ void obj_cgroup_uncharge_zswap(struct ob
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
-	return !is_zswap_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
+	return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
 }
 
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
--- a/mm/zswap.c~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/mm/zswap.c
@@ -131,7 +131,7 @@ static bool zswap_shrinker_enabled = IS_
 		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
 module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
 
-bool is_zswap_enabled(void)
+bool zswap_is_enabled(void)
 {
 	return zswap_enabled;
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are


