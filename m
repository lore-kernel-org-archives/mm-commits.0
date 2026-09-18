Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8CC3911DF
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753656; cv=none; b=Bs7IMKjbpsIBnlpDV4VS9g0vQ+Q+uqC2I5XSvUpElv48Yq/o8/9uzqqG3ajrrRv2KMUY5c7rodN6jnUfy1n2aiI5QOXu49OHKanEsDL87vd/kcihdhjblHIxpXYTVWzJ4u/K7QrilISzioyLH3bqXjKClTnMGR7Fjr6th/WK3AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753656; c=relaxed/simple;
	bh=+QaFMzRZvtcjzEKQ77eKLVR3y9MwHxehOiPGGLUzTfQ=;
	h=Date:To:From:Subject:Message-Id; b=cRimlAg/WaXaRDhUKsP8cqQ2mKt5kwRWy45pPdZFsqAWfV8Mf95uVEJGJ6uMqSnQVZyFFcpOKJ93lzkBbJ1gYwby4rnsYy9uGjOlbsa+DzDk2rmZc7VYkFqcH5l1WsSyWAoRptrIKco4kDlpxV66Qa1aHuCV3AG8tN2yr0z3hxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zlit5iLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zlit5iLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70FD1F00899;
	Fri, 18 Sep 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789753645;
	bh=TcjMgtprDEYEhwHUR1uCfXmSwUAm2APOlQiXJGcdQX4=;
	h=Date:To:From:Subject;
	b=Zlit5iLRiwHoALuAwJZshTA+0qsHBmWU6BIZdwq0ew1ulW2pFgZS+S8jvZwqiLZSG
	 ShbJXK+TvXFXTfSBaCZQdvGO473eoe0yHeio3PyxBW0MC6sJ1UA8qtF5119moekJV+
	 bTrT+FGN9zWRS9gI8wTBP9GGNvOImf3TkuN2e2nE=
Date: Fri, 18 Sep 2026 10:47:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch added to mm-hotfixes-unstable branch
Message-Id: <20260918174725.B70FD1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 18:34:26 +0200

Gregory is extremely familiar with NUMA placement handling and volunteer
to help co-maintain the numa placement bits.  So add him as a
co-maintainer.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement
+++ a/MAINTAINERS
@@ -17299,10 +17299,10 @@ F:	mm/numa_memblks.c
 MEMORY MANAGEMENT - NUMA PLACEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
+M:	Gregory Price <gourry@gourry.net>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
-R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch

