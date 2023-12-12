Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2E1210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vttHTVlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112B9C433C7;
	Tue, 12 Dec 2023 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702406861;
	bh=OXLYQhGuKUJgGsV9rRVzEJEYX1Tkunp8f+cbCSkIlYg=;
	h=Date:To:From:Subject:From;
	b=vttHTVlfsKn7ab4fN9pzGU8wX9RHURWRgXCETkNmRhVsCZBnLbG3FpS6RpKni40z0
	 WtOLPY5+keZhCN5nm1j/NbcV/5CteGvzy1hZGiePpyrMe16PORwDQt7A5My/kSIdK4
	 kIxdifHT7OerxgTM++1z/z8EuznLvtQkZzaRadwY=
Date: Tue, 12 Dec 2023 10:47:40 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-make-shrinking-memcg-aware-fix-2.patch removed from -mm tree
Message-Id: <20231212184741.112B9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: make shrinking memcg-aware (fix 2)
has been removed from the -mm tree.  Its filename was
     zswap-make-shrinking-memcg-aware-fix-2.patch

This patch was dropped because it was folded into zswap-make-shrinking-memcg-aware.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: make shrinking memcg-aware (fix 2)
Date: Tue, 5 Dec 2023 19:06:27 -0800

Drop the pool's reference at the end of the writeback step.  Apply on top
of the first fixlet:

https://lore.kernel.org/linux-mm/20231130203522.GC543908@cmpxchg.org/T/#m6ba8efd2205486b1b333a29f5a890563b45c7a7e

Link: https://lkml.kernel.org/r/20231206030627.4155634-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
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
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~zswap-make-shrinking-memcg-aware-fix-2
+++ a/mm/zswap.c
@@ -859,6 +859,7 @@ static void shrink_worker(struct work_st
 resched:
 		cond_resched();
 	} while (!zswap_can_accept());
+	zswap_pool_put(pool);
 }
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-make-shrinking-memcg-aware.patch
mm-memcg-add-per-memcg-zswap-writeback-stat-fix.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch
zswap-memcontrol-implement-zswap-writeback-disabling.patch

