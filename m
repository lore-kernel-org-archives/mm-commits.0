Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5523D13D503
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770519; cv=none; b=g1jCCyiF3DJQXNykoV2xkFN677INHGdiABgkPV19WkPaFKzDqGKSGlNK27bDU4nsjtV4UQiL2WF5nszIh2o3AJdyZ5Myo4fKpqn83Jn9L4LZOz4X9bYvCsC1Uyd9NeFeDFKAJdJtyMB8Csmc9LP18d0r71BzAvjMGMrxpmC34yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770519; c=relaxed/simple;
	bh=VHSgd3PDlR/nyHdoSfOg14OEPy7vkA4IWEy0mQh/RRg=;
	h=Date:To:From:Subject:Message-Id; b=bDpP2ZTUA33UqsvI8inZTz+nvSMHD6nQOIUo+OdhCNH3wy4T5PKcaGQE01+CJrLwS/pS0ROuXYlcgZY1gQLaEM1MG9/oI4M7tPwrMQmFyQaQNPT8gyQ/yeDft44i6QQL6NnuFdzfKvfDF3Y/YT2RyQK4BFWjUPZJNdiVCSNwE0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/JZeRq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/JZeRq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3CCC4AF0A;
	Tue, 23 Jul 2024 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721770518;
	bh=VHSgd3PDlR/nyHdoSfOg14OEPy7vkA4IWEy0mQh/RRg=;
	h=Date:To:From:Subject:From;
	b=k/JZeRq3ESFAnqKBQhjfKnuK87BP5KNABS2bSxRksP9lXvcxo+VKu2EXsEGgJ0R/h
	 TVdCscGK9jV5dXHO34FWu521HAwRFy7lp5C/oH4TZjPQzHj/pu/M4xSZpXcLjjt1Km
	 dtduOSKaNtshVXbHc5gkw+JIXlxdwV7O1jP4a+ZI=
Date: Tue, 23 Jul 2024 14:35:18 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch added to mm-hotfixes-unstable branch
Message-Id: <20240723213518.DA3CCC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: add cacheline padding after lruvec in mem_cgroup_per_node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-memcg-add-cacheline-padding-after-lruvec-in-mem_cgroup_per_node.patch

