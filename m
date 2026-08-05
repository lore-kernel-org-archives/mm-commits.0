Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156A03B71AF
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896553; cv=none; b=MelfsE1rare8cr/LfBMppOy12w0QbY8FmGfeRnoSKYlZPDtTnEllTRruIy6IdvcN7JKfiKBVRYZ3Hp8oquVy2zwn+sY5I7r07CQuZJS0wtUySeSpNP8XyIjxE5/Rd2tRgRNtOyREXX+abje2N6KJ41QMgtnmLu2Ai2Ge/Kdaopc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896553; c=relaxed/simple;
	bh=vSsdmQngVWLmGgFEkCDWd0lFoUfoaDNdivfPv/l4dEs=;
	h=Date:To:From:Subject:Message-Id; b=EIdMSMEJK9UnJJ4jDl3hXlwrpdyikujtcQMLIiPHgby3Fp1Y6bOs0E5v91ZdM34TMCqYiaM6lqwQmN0y6UQhmA3OhXgzOnRDBigpugPJ0KJYj/4zKPmSPcX6YpGtiNPw8F8yREi9h0Y3IMHnr1iDorPcL1lbaCTMYhHPBFp9KaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wosZTFC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wosZTFC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EB91F000E9;
	Wed,  5 Aug 2026 02:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896551;
	bh=SgUC1qhtFolX7WtTwXSWepzwO+VtTWF41diZb9zN+Kc=;
	h=Date:To:From:Subject;
	b=wosZTFC6KjucaAruamzpgLyEj6i8q5J8E7sioUjgaPdBzpf/IXNxswBuBInGAqE2v
	 NI/SO+mKqhLMDAYMsxXJ5tA4zd+rJja0GGdZv4zEtDxSZT9hn7uT7WZN3zUBfliEGy
	 xI38qaVgPNwu84WY9k9XLbz3B53n/r1sSx3jLM0E=
Date: Tue, 04 Aug 2026 19:22:31 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch removed from -mm tree
Message-Id: <20260805022231.C2EB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: bail out proactive reclaim when memcg is dying
has been removed from the -mm tree.  Its filename was
     memcg-bail-out-proactive-reclaim-when-memcg-is-dying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: memcg: bail out proactive reclaim when memcg is dying
Date: Thu, 2 Jul 2026 20:02:29 +0800

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Link: https://lore.kernel.org/20260702120235.376752-4-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmscan.c~memcg-bail-out-proactive-reclaim-when-memcg-is-dying
+++ a/mm/vmscan.c
@@ -7912,6 +7912,10 @@ int user_proactive_reclaim(char *buf,
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg && memcg_is_dying(memcg))
+			return -EAGAIN;
+
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
 		 * hope of introducing more evictable pages.
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are


