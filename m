Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322872;
	b=CBK8Y6DCui4eKm7NBC3KJAjf+Cr1vaNmGIyo0dFYrhJZoGLYftPY261bQEXz+0LVs9kK
	 St4QYnIj4qPnG64XpTSZqW7yyFPcU8okxvZE/1xMbyS3T5R5ilDb560zLsJQYpV2YFUl2
	 fBkQ7d2AJe56+auQ2K2do6uE2vG/LjH4OPHO0PK0OVHO2JC6lpBsR9RxB2fSlDvdimIxJ
	 QO/GMrAgcBd4gt7mcqsoPxrHhvXfbciuZI/WgcPP2op5BDjdo5glVwTN13ZfIoVkHBMeU
	 3N6hWxrnuNInKnJi2OeUWCQKrkgnjULaU5WfTqJibKBN61A/dSMx/htBFxlpAdZ+kyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322872;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=phUBY2B4eivGF21ooteg2cYGYfSO7b7dhpKP2MuA2pk=;
	b=sS9EN+hGOy6QLTYcTmWOgMK3BEoXY56Zg64wz3Iu0lLOGSDapS+ZIwMaE5GDyvJJbnOu
	 pC764hJs5WRs9Txi90YNVQ1BrMQHSlQAcayETW8I2XA1pTFxWLvdi9JXuR7aQIh/lZ0sQ
	 78ko1+2P1RwcxrF20x8JHm2OXjKz5XRolXYVuA3PDUApdtx3SjDUYGMbrqGXDAjcPtIEW
	 Ssh1YSuk7VtygsRCCBAbKykWJVxrd8nmzQWpjzZwD7thUPLeGM9DZTA1muAtxilgLNffT
	 uLPjtRCEGnqE7o1mKnGPzQmRj7/bGBA8zS00YEmh/fhhNdf7pTqpdG9YRaEc69MDycQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VvuVAPah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41745606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VvuVAPah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988C01F000C1;
	Fri, 30 Oct 2026 01:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793322871;
	bh=phUBY2B4eivGF21ooteg2cYGYfSO7b7dhpKP2MuA2pk=;
	h=Date:To:From:Subject;
	b=VvuVAPahz/VkpjQCBnySt7Qy4pihzV23InH0lh6MnQL6QTz63NGGyGW9vY4SkeDh4
	 Ia+gq79lQa1ruUQlm9Uyc57G5Eo9gjtFU3dCN06YBa9oMY2JRO6SG0aO/aGdt2NAIZ
	 9TmV6Sm51PuOZWacLJgRlm/SM7FmcRoSX2Mex+BU=
Date: Thu, 29 Oct 2026 18:14:31 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,
	weixugc@google.com,shakeel.butt@linux.dev,rlmenge@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hargar@linux.microsoft.com,hannes@cmpxchg.org,david@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,apais@microsoft.com,sidchintamaneni@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec.patch added to mm-new branch
Message-Id: <20261030011431.988C01F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
has been added to the -mm mm-new branch.  Its filename is
     mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
Date: Mon, 26 Oct 2026 20:23:12 +0000

Patch series "mm: multi-gen LRU: replace get_lruvec() with
mem_cgroup_lruvec()", v2.

This series cleans up MGLRU's get_lruvec() helper in mm/vmscan.c.

Patch 1 updates get_lruvec() to delegate to mem_cgroup_lruvec() rather
than returning &pgdat->__lruvec directly when memcg is disabled on the
kernel command line.

Patch 2 removes get_lruvec() completely and replaces all 15 call sites
with mem_cgroup_lruvec().


This patch (of 2):

Andrew Morton noted that get_lruvec() has the same pattern as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=memory), it returns &pgdat->__lruvec directly instead of
going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.

In practice all callers of get_lruvec() run after kswapd_init() has
already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
this is not a runtime bug. Have get_lruvec() delegate to
mem_cgroup_lruvec() directly.

Link: https://lore.kernel.org/20261026202313.63122-1-sidchintamaneni@gmail.com
Link: https://lore.kernel.org/20261026202313.63122-2-sidchintamaneni@gmail.com
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <apais@microsoft.com>
Cc: <rlmenge@gmail.com>
---

 mm/vmscan.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec
+++ a/mm/vmscan.c
@@ -2866,20 +2866,9 @@ static struct lruvec *get_lruvec(struct
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 
-#ifdef CONFIG_MEMCG
-	if (memcg) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
+	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
 
-		/* see the comment in mem_cgroup_lruvec() */
-		if (!lruvec->pgdat)
-			lruvec->pgdat = pgdat;
-
-		return lruvec;
-	}
-#endif
-	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
-
-	return &pgdat->__lruvec;
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from sidchintamaneni@gmail.com are

mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec.patch
mm-multi-gen-lru-remove-get_lruvec.patch

