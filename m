Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECFA2DFA3A
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334220; cv=none; b=KBQ1rB1REsxWUL1Sgiad7Gr60H8QjXNovlSV1jPLiLXXfMj8csrxtrnhYq8iccdUt8ooYHF/w9yBD5tjFWb0bVNGc2Qr+2jdNuRd+pVHBTYKdi5Bt8Grpf8Uhv6D/ryBoB347wpzBACFZ55gu9Ve12BCPigul0v4EJv8mEVQf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334220; c=relaxed/simple;
	bh=7RQ1mGbGq4HcXEmeoNIf77BtHafcQM0AjzdcqwlBXkI=;
	h=Date:To:From:Subject:Message-Id; b=u/1SYB03+IZxaqOUgijhlJgaAz1H4ezWl5eFOEe03ozRwntQ1wxh3Y96hDAYuMPbj7Jq6T1eQYwPIpPx9ViQ21yTYIH3+X8M5yW1+TmCE0SzuAUy+7/hy2NMFtB00KZzC7C1PrVuLL8cbVsbhaK/04zbus/315dA4EnQLmJz5mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Wup20Mz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Wup20Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F191F0089B;
	Wed,  7 Oct 2026 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334219;
	bh=4H1gpXPn75LOCkMK5VXmg2dW/0Y2EUIZ/qas2fSlIfM=;
	h=Date:To:From:Subject;
	b=1Wup20MzrksE8g5rytMKTkr9OkeHWdkjHSMpOdmLZwxx9jo1hg2gI9TqBSL94NAiK
	 z1I6FZQvkAVsChh1HQIkC/HAACyqQTCKHIZKnWLg4hD3OyWTdmWFCaIpaiE+Z/yUSQ
	 VOK3cMmICPOQZcxxjKWxWi1Hincmy+0NiAAax84k=
Date: Tue, 06 Oct 2026 17:50:18 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-the-soft-limit-reclaim-tracepoints.patch removed from -mm tree
Message-Id: <20261007005019.11F191F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove the soft limit reclaim tracepoints
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-soft-limit-reclaim-tracepoints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the soft limit reclaim tracepoints
Date: Wed, 2 Sep 2026 10:43:06 -0700

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Link: https://lore.kernel.org/20260902174311.1772372-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
---

 include/trace/events/vmscan.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/trace/events/vmscan.h~memcg-remove-the-soft-limit-reclaim-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -258,13 +251,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_en
 
 	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed, memcg)
-);
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
 	TP_ARGS(nr_reclaimed, memcg)
 );
 #endif /* CONFIG_MEMCG */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

