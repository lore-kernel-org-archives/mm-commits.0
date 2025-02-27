Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B15B2309A8
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 23:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697868; cv=none; b=CcJCm4R+7c5ny4PVnvko8sh5o2kJaAPj26exXNhpeLxB3I/x0I4JtGMcZ3qfKd8uiLf9w/HpFhHKox0/PhvVrqVMEXtjpTEev4df+5lNT2w4yqKHSUpBfZLiUfPzWHZHiOdXW0xMVYdVTvYlMPjKgcPp9i9SUcyuVLnl45stNvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697868; c=relaxed/simple;
	bh=2FVKAHReRqA0LnN6BfCOkxAWMkm8+4INx2MfiixJMAM=;
	h=Date:To:From:Subject:Message-Id; b=CU8d3eMWAtFKrzp34Su5DC40W2yH/UQVj5yvYAE+72H7rQ2mfWYIa0UrFJzdG1v77j+mRZMVe4btSSZPckO9GhjdCkJFjAxndz66lg9KVxdkZSkysn8R9mMJfPpH+5S+O805xBJyPYWKQqm5wzLREHlWmzeWBdMjeYypBXOHwQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jY5Fe5hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jY5Fe5hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E10DC4CEDD;
	Thu, 27 Feb 2025 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740697867;
	bh=2FVKAHReRqA0LnN6BfCOkxAWMkm8+4INx2MfiixJMAM=;
	h=Date:To:From:Subject:From;
	b=jY5Fe5hfihF6KxkIDqTl4IteuDwVuq5fhofFk8sQbAQHcg2IrM8vGbnicImvEkCqU
	 Cd/UJ+q1vqQ+NNasPoOs6LSPtL/1Gbmkm4gQ74mGMo/ML7VVY6Qn+hO1T/ye4YxE42
	 +Y5lvk6pbpTuaCFRyhvuW9Qd6rNVImg5C6df0/tY=
Date: Thu, 27 Feb 2025 15:11:06 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lkp@intel.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch added to mm-unstable branch
Message-Id: <20250227231107.7E10DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: make the case where mlru is NULL as unlikely
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch

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

mm-list_lru-make-the-case-where-mlru-is-null-as-unlikely.patch

