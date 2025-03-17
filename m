Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5F218591
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188497; cv=none; b=NaCot9FDP+CLFiIbVzjvZtSyGeJ+IiQ01FRtaLeKkBbmmm4waGIqpS+UbqARMGQ4VM2xatI2FkXxxQZMG0FINDUbVsPrODcjZwdk/PUnUNuUpe/eMHqWlZr+wiyUC5BEd7impdp6ubzJjGCk4JXyFuuZSno+h0gOrBLRI8APMV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188497; c=relaxed/simple;
	bh=yY3iwNX+ei5uB95rXHHoWUMhCEgQ+O1O5sjLlDLniiM=;
	h=Date:To:From:Subject:Message-Id; b=rvynGzoJT6NEWa4vwn6RR/IYSj7tI3t93xApkKtBv9Y3bcmBXTUiF1HnmdEUAUmm71GMs51LDZfnKU29vVez/EZ7sWuMpNxPIUndPGck/JGxgoyLCt3ySdeycTh8boM2DM8t2FtoT+Nbms2+fPre98ASxnFTxH/dW9Co1BET3ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vuGxrua4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vuGxrua4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94E4C4CEEC;
	Mon, 17 Mar 2025 05:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188497;
	bh=yY3iwNX+ei5uB95rXHHoWUMhCEgQ+O1O5sjLlDLniiM=;
	h=Date:To:From:Subject:From;
	b=vuGxrua4v7KgMmi4D/B4chp9GtnCNTDt2r1qX1DfJfFH9ugwmjRP9Th7TdKVJYsYH
	 3rINsRk7Cr5nOFytx5faAqNPporuEoMKk35gnTmMFRQfjY6AfOSDKl0U9/JwxuScAS
	 ly4dNTrrBm9IM6mJU1FYS2K0uu+nbMtrmFPHKtwE=
Date: Sun, 16 Mar 2025 22:14:57 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lkp@intel.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch removed from -mm tree
Message-Id: <20250317051457.A94E4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: make the case where mlru is NULL as unlikely
has been removed from the -mm tree.  Its filename was
     mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zeng Jingxiang <linuszeng@tencent.com>
Subject: mm/list_lru: make the case where mlru is NULL as unlikely
Date: Thu, 27 Feb 2025 16:22:23 +0800

In the following memcg_list_lru_alloc() function, mlru here is almost
always NULL, so in most cases this should save a function call, mark mlru
as unlikely to optimize the code, and reusing the mlru for the next
attempt when the tree insertion fails.

        do {
                xas_lock_irqsave(&xas, flags);
                if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
                        xas_store(&xas, mlru);
                        if (!xas_error(&xas))
                                mlru = NULL;
                }
                xas_unlock_irqrestore(&xas, flags);
        } while (xas_nomem(&xas, GFP_KERNEL));
>       if (mlru)
                kfree(mlru);

Link: https://lkml.kernel.org/r/20250227082223.1173847-1-jingxiangzeng.cas@gmail.com
Signed-off-by: Zeng Jingxiang <linuszeng@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412290924.UTP7GH2Z-lkp@intel.com/
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jingxiang Zeng <linuszeng@tencent.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely
+++ a/mm/list_lru.c
@@ -510,7 +510,7 @@ int memcg_list_lru_alloc(struct mem_cgro
 			 gfp_t gfp)
 {
 	unsigned long flags;
-	struct list_lru_memcg *mlru;
+	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
@@ -535,9 +535,11 @@ int memcg_list_lru_alloc(struct mem_cgro
 			parent = parent_mem_cgroup(pos);
 		}
 
-		mlru = memcg_init_list_lru_one(lru, gfp);
-		if (!mlru)
-			return -ENOMEM;
+		if (!mlru) {
+			mlru = memcg_init_list_lru_one(lru, gfp);
+			if (!mlru)
+				return -ENOMEM;
+		}
 		xas_set(&xas, pos->kmemcg_id);
 		do {
 			xas_lock_irqsave(&xas, flags);
@@ -548,10 +550,11 @@ int memcg_list_lru_alloc(struct mem_cgro
 			}
 			xas_unlock_irqrestore(&xas, flags);
 		} while (xas_nomem(&xas, gfp));
-		if (mlru)
-			kfree(mlru);
 	} while (pos != memcg && !css_is_dying(&pos->css));
 
+	if (unlikely(mlru))
+		kfree(mlru);
+
 	return xas_error(&xas);
 }
 #else
_

Patches currently in -mm which might be from linuszeng@tencent.com are


