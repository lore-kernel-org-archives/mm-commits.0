Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60B17BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935008; cv=none; b=Es6wChK7rOmoo1Qa8Cc09R5dNcritfKG8bSmWlPC+kUYUksJT4JGvMzGpf+bUggX6EmckP7e44ABm8Vbpg99zxyZ7Pbel5Dy1xq2Pa8PSU74riZuJQhYzr4waIQ8QYxLMEZzxe0KK/PH/fnKfe81JLFA9zCqc+3eiLJHtnt6heI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935008; c=relaxed/simple;
	bh=yF3FkAxnSLaA/LYBKjhBmGlvXTp67R9PkT099R/rV2k=;
	h=Date:To:From:Subject:Message-Id; b=bsa013zEmSnu/aPSzfizsF0rPj8MlQmUmi6wIeeAVOyD5sbqufPlik9nssRCRJGwL7q1CPhaHq8ARf73xQSFyRHZNg0iOvyLqqyt2dHFHmCVtwfyDpkcD/Cln/S/2/pKgz8SlvOs5DIMjm4hY5mi/noqbQCu2Q2bH0jlRlyVIKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aCcus7Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aCcus7Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC4CC4CEE4;
	Sun, 11 May 2025 03:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935008;
	bh=yF3FkAxnSLaA/LYBKjhBmGlvXTp67R9PkT099R/rV2k=;
	h=Date:To:From:Subject:From;
	b=aCcus7GhfJ+gwults8PPnOEddOEWi5B8JYT/AvsciNwSRyHte+EYY81g1jhDPVtgl
	 nt81Z7BQ6Re8DNx4uRQgP9PCT9I3QAeZ8I2OV1q1rj0fMviRVqGO6daCY+HVkojtjr
	 ipJx43qFMNVYxIxXQYf5U+6xtjf0DFEtInN+fUBM=
Date: Sat, 10 May 2025 20:43:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-multi-memcg-percpu-charge-cache-fix-3.patch removed from -mm tree
Message-Id: <20250511034327.EFC4CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-multi-memcg-percpu-charge-cache-fix-3
has been removed from the -mm tree.  Its filename was
     memcg-multi-memcg-percpu-charge-cache-fix-3.patch

This patch was dropped because it was folded into memcg-multi-memcg-percpu-charge-cache.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg-multi-memcg-percpu-charge-cache-fix-3
Date: Tue, 29 Apr 2025 02:40:07 -0700 (PDT)

Fix 2 has been giving me lots of memcg OOM kills not seen before: it's
better to stock nr_pages than the uninitialized stock_pages.

Link: https://lkml.kernel.org/r/d542d18f-1caa-6fea-e2c3-3555c87bcf64@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>	
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-3
+++ a/mm/memcontrol.c
@@ -1950,7 +1950,7 @@ static void refill_stock(struct mem_cgro
 		}
 		css_get(&memcg->css);
 		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		WRITE_ONCE(stock->nr_pages[i], nr_pages);
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
_

Patches currently in -mm which might be from hughd@google.com are

memcg-multi-memcg-percpu-charge-cache.patch

