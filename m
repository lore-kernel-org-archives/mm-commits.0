Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB23BFC1F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 20:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026296; cv=none; b=H0lsubJdLWGs56RAGiMuUBSPIxqj5XWx9BPSOI/CdSbvFW33DvIxJnO+geTuAeom50s6EUkdrk7KwXmaVyHEseB2i2OjakgCRCXxYPPeEtfyikYWK/30pl+xug5N7vAl3pkZM8ZsIWSMEKrFRirDM7gR5wB+zOeucNyA20Y5GuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026296; c=relaxed/simple;
	bh=pv5X9kK41d8k6/Pi4Y9XN6M/F4jFFinaz+Q6Otvp4HA=;
	h=Date:To:From:Subject:Message-Id; b=dEq6e1CxvZvstq4zhlySV1QOTzbjKJc6vuYmtqUF4ccFqAYWt+DFMGWSCe4v+2QTi/UdxdssHJ0YWGe9NBdYvMsHeDDzaxwJOZn9+KWvFNTDUDNM5zZfkarrn5m/7rR50MzTAn4JEZEOA6dee+wsxYfXYPmVfpqQlOInEY2z2Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIaUh20y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIaUh20y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8841AC32782;
	Fri, 26 Jul 2024 20:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026295;
	bh=pv5X9kK41d8k6/Pi4Y9XN6M/F4jFFinaz+Q6Otvp4HA=;
	h=Date:To:From:Subject:From;
	b=GIaUh20y9b2QY7zy9ibQ3LvX6jgnaEhwC7kyB5CoWscwoIz9J6BQbAzzS3mW4889J
	 JAH7UAWiHaMirPBv4jWi5SXQre/JquU27P8+bP5liFoetWrcs3C7Uz4mWoh+qXkY+r
	 mHHlnCyKGTeV8b6IXDv99QyK5hevEiYVRVYwm25s=
Date: Fri, 26 Jul 2024 13:38:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch removed from -mm tree
Message-Id: <20240726203815.8841AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add cacheline padding after lruvec in mem_cgroup_per_node
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: add cacheline padding after lruvec in mem_cgroup_per_node
Date: Tue, 23 Jul 2024 17:12:44 +0000

Oliver Sand reported a performance regression caused by commit
98c9daf5ae6b ("mm: memcg: guard memcg1-specific members of struct
mem_cgroup_per_node"), which puts some fields of the mem_cgroup_per_node
structure under the CONFIG_MEMCG_V1 config option.  Apparently it causes a
false cache sharing between lruvec and lru_zone_size members of the
structure.  Fix it by adding an explicit padding after the lruvec member.

Even though the padding is not required with CONFIG_MEMCG_V1 set, it seems
like the introduced memory overhead is not significant enough to warrant
another divergence in the mem_cgroup_per_node layout, so the padding is
added unconditionally.

Link: https://lkml.kernel.org/r/20240723171244.747521-1-roman.gushchin@linux.dev
Fixes: 98c9daf5ae6b ("mm: memcg: guard memcg1-specific members of struct mem_cgroup_per_node")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407121335.31a10cb6-oliver.sang@intel.com
Tested-by: Oliver Sang <oliver.sang@intel.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/memcontrol.h~mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -109,6 +109,7 @@ struct mem_cgroup_per_node {
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
+	CACHELINE_PADDING(_pad2_);
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 };
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


