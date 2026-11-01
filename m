Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793568480;
	b=EpXzVdiyqF/NZL59dTEFdwbxJrUaAZa1dtnNYLPA+bdjyo9Y2/zZgD2/EuGAaCN0g/57
	 Jkoq34yVgPTQsCJVKawrJeaW0tdVG7zNE5cydydt5hTwqQLPD3Nzcznxxajm5crZN38iF
	 UAxhgXddesxdnrc6lHbfghFTQbb0YrE48H9kVqGwYeKZ3w7ISg6/kPMvqCHLNcNE9kHCX
	 nquEGTvo8vQnfyUqggqbmf4jXquZco6+5kA26ieH4F+SX2GlVeDEz6nRgJPPcq317F+nY
	 lBHoa4C3EdP7u/6KgVjBRIvSZJWBPd1ZGrhYVr8yr7uhVi6/7TtjoDxWWCsjli2hQlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793568480;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=p6DWVa05MgtlxYNgFYpPjCtdphQ1eJ2eDrjmkGiiigg=;
	b=o3BigHKPpt5mnAh33BUO6UYQyLYy2TC8bmH0IDoCI1TpuEye5XKenQl5HPdpHXTW730p
	 2XiKS0GlPSL64rELHiiWQelu00SYvjmAgGwYQPBmSJpsCxgNIltHNnUP7jN3I1VvUJEa0
	 QNcXSCyN+HiV6YHADblBwiOFpsKgb+Z8QofA1dHEpfO4apmWfaNOQxDVkuRbhMeyoXtut
	 XBLX03qVszkwsd2+SSlX2SadkSpBSIK/jSTiswF882k4yp4+w324DKAbYLkG/2OgMcREe
	 75PWZK1ORwVzmwTyyj3HH8/mp0vHtLipy9cDs8s5l9b+qw2wT3AoeiXDsP6+AOz97Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y2j6dJXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E81F606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 21:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y2j6dJXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30DD1F00919;
	Sun,  1 Nov 2026 21:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793568479;
	bh=p6DWVa05MgtlxYNgFYpPjCtdphQ1eJ2eDrjmkGiiigg=;
	h=Date:To:From:Subject;
	b=y2j6dJXq79V4Pcueu178wmv9aoNoFeGsVyttvFIJxrDdz6L2lQ9H6P02wBByd9qEb
	 YgUcQHN5LoPbgUcDDP1RDVMhVNwTjKxLr8UCF7olGIBcfacBL8ZK3HeLyY59Q2eraN
	 oxCCQzrXBu/NrP1GS6BzbkuX4BKEW9ooxhmk2vk4=
Date: Sun, 01 Nov 2026 13:27:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,
	rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,
	gourry@gourry.net,david@kernel.org,cl@gentwo.org,brendan.jackman@linux.dev,
	vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101212759.C30DD1F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add Johannes as the page allocator co-maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add Johannes as the page allocator co-maintainer
Date: Sun, 01 Nov 2026 17:34:48 +0100

Patch series "MAINTAINERS updates for page and slab allocators".

Following David's updates [1], perform similar updates for page and slab
allocators to indicate the MM process transition for these
subcomponents. Importantly, add Johannes as a page allocator
co-maintainer.


This patch (of 2):

Johannes is a long-time expert and reviewer for the page allocator and
has agreed to step up to a co-maintainer role, so do that. Thanks!

Additionally, page allocator is joining the MM transition, following the
MM core updates from David [2].

Patches will be collected in the mm/page_alloc git tree and integrated
via the mm/linux integration tree. To signify the change from Andrew's
mm tree, remove Andrew as M: - get_maintainers will continue CCing him
on most patches via the catch-all MM entry. David prefers not being
added for mail volume reasons.

Link: https://lore.kernel.org/20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org
Link: https://lore.kernel.org/20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org
Link: https://lore.kernel.org/all/20261030-maintainers-v1-0-97278f8a5f54@kernel.org/ [1]
Link: https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/ [2]
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-johannes-as-the-page-allocator-co-maintainer
+++ a/MAINTAINERS
@@ -17703,15 +17703,15 @@ F:	include/uapi/linux/oom.h
 F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <brendan.jackman@linux.dev>
-R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git page_alloc/for-next
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch
maintainers-move-slab-allocator-under-memory-management.patch

