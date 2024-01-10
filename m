Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE94C601
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r6tP4bM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224D7C433F1;
	Wed, 10 Jan 2024 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902995;
	bh=zIGgAdUkD32HCm1xa7fiA4YqNsR9/H2X+Cebk/dHELw=;
	h=Date:To:From:Subject:From;
	b=r6tP4bM4izo51iOcbGiIkh67ab6+xEL8t1vp77VxChCIIP7s7GurGsEsdOn+K58Bz
	 Gx6fYUKjzT+8UzbOKWjlGhFDwTsx67SUVS75q2vwvx0ojJx77r/0WBRy15RLRkTvIk
	 rgf1nj/7nhsUAjlM2U9U0kO1AXzf0zso3aDRHKUI=
Date: Wed, 10 Jan 2024 08:09:54 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,haifeng.xu@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch added to mm-unstable branch
Message-Id: <20240110160955.224D7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: disable memcg_aware when cgroup.memory is set to "nokmem"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm: list_lru: disable memcg_aware when cgroup.memory is set to "nokmem"
Date: Thu, 28 Dec 2023 06:27:14 +0000

Actually, when using a boot time kernel option "cgroup.memory=nokmem", all
lru items are inserted to list_lru_node.  But for those users who invoke
list_lru_init_memcg() to initialize list_lru, list_lru_memcg_aware()
returns true.  And this brings unneeded operations related to memcg.

To make things more convenient, let's disable memcg_aware when
cgroup.memory is set to "nokmem".

Link: https://lkml.kernel.org/r/20231228062715.338672-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/list_lru.c~mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem
+++ a/mm/list_lru.c
@@ -567,6 +567,9 @@ int __list_lru_init(struct list_lru *lru
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
+
+	if (mem_cgroup_kmem_disabled())
+		memcg_aware = false;
 #endif
 
 	lru->node = kcalloc(nr_node_ids, sizeof(*lru->node), GFP_KERNEL);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch
mm-list_lru-remove-unused-macro-list_lru_init_key.patch

