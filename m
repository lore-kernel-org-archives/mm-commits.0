Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991CE332918
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782354529; cv=none; b=Ho/DK8dhkYNTV4U1qyA1Gyivvan4XOULy15HjWB+NmYF48acGxov01V8ZbzSZ80kY5JeltAdSf9y36nuol0Z0vPXuvOn589B9dKpiv0LTfV/xPpnotSqDrtiWH5ObMEF6rxSJd2G5Xxg41ejEkCH5zx6yXGAPuR6fgfte61kAvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782354529; c=relaxed/simple;
	bh=520qqfS/UWZ402e+OwPMtSVAx31fhYeg9FoLrO+Q56Q=;
	h=Date:To:From:Subject:Message-Id; b=MzT91j/RXyXb/xHd9K7sUJPYYzGKdJzQGpgczb4uCGlSgEuMpDb3gEd55Du4H9zh+cRZcDGUhqPwtavLS6ecLAyENWa5xgKKYHNDMiYPob4k/hKLemBrvOQnCKEFL43B3EgwX2fffuNguiU6x7rOCJjyWxERYCwEifkpK0aX2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ehfZuCuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ehfZuCuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575471F000E9;
	Thu, 25 Jun 2026 02:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782354528;
	bh=F9k4gZajve8AGW8f1xC8s4VNJZGywCuqZRnu+LR8gx0=;
	h=Date:To:From:Subject;
	b=ehfZuCuAYngAhU2UuwDyKP2b/GKVtNmlh9TSpqSQB/R7KCUBjwsnbw5OH6ekVurGM
	 ZqNok26ZWp53Ks0c/jl0DNEQGfTKMNcr5XefUHUGQfyrX6uYwF2waTeWkbuXj3nMcu
	 vU66hxQbprwZLnjBcgRWYuBKyyDmr4H8Z8N98kh8=
Date: Wed, 24 Jun 2026 19:28:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ben.dooks@codethink.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch added to mm-new branch
Message-Id: <20260625022848.575471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch

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
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
Date: Thu, 18 Jun 2026 11:06:14 +0100

vm_numa_stat_key is only exported if CONFIG_NUMA is set, so avoid the
following warning by guarding it in an #ifdef on CONFIG_NUMA:

mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?

Link: https://lore.kernel.org/20260618100614.1321950-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n
+++ a/mm/page_alloc.c
@@ -165,7 +165,9 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+#ifdef CONFIG_NUMA
 DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
+#endif
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are

mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch

