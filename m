Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D6BE6C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141626; cv=none; b=EBOxqRyieqyjZhC7wUEZCbVLhdLtTz3F0sOCywKDXW8BwniW3JA7lKNy6eTfmM64s6AL1gG0fI2lYvgII60c3l/baqmfFSCm9ulTAWIVK6DJzXsiOOb/O3ZYTDNR7BWrrXnCcTV0Zgk3nQ0ZJ0eWNddAkGH0HwPE44FKem78LUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141626; c=relaxed/simple;
	bh=0+3RyBmlDm5L0Qw2kZwuH8pcW6it8DJHnJJzKEa+/V0=;
	h=Date:To:From:Subject:Message-Id; b=aVDFBABpQITyufsVLN0HTSGv5MqvYOKy1aXCFl6nKyE0v3Rh6ghu9XkJ5WRgcwJjwKLs1gMAyejz5UZsrvKvI0T2kNuMiAYw+rtrL7xnDcg35fcyeU1hfn7JrZwa5+E+Zr8KGvIcb10r9bDkEdAKYPYXcqRi3GZw6MCSpj/zCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZValsM+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZValsM+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C5C3277B;
	Fri,  5 Jul 2024 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141626;
	bh=0+3RyBmlDm5L0Qw2kZwuH8pcW6it8DJHnJJzKEa+/V0=;
	h=Date:To:From:Subject:From;
	b=ZValsM+ZhIyLr3kwj20qDUnfQ/suCr0i0/Ziuy0VBEMqm5HE5gutdwKpg8kfSzvu1
	 WK3qRFp2PiMZaCGW+hh12ULesxI32nUfGeTb2BKURAsPakEQFUHIABHCxvaWUwNgVq
	 Gd75nVr0U/2BIqupr1861KCA0sBFg7qrAPKglV7c=
Date: Thu, 04 Jul 2024 18:07:05 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch removed from -mm tree
Message-Id: <20240705010706.4A2C5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node
has been removed from the -mm tree.  Its filename was
     mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node
Date: Fri, 28 Jun 2024 21:03:15 +0000

Put memcg1-specific members of struct mem_cgroup_per_node under the
CONFIG_MEMCG_V1 config option.

Link: https://lkml.kernel.org/r/20240628210317.272856-8-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -92,6 +92,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
+#ifdef CONFIG_MEMCG_V1
 	/*
 	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
 	 * and update often fields to avoid false sharing. Once v1 stuff is
@@ -102,6 +103,7 @@ struct mem_cgroup_per_node {
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

