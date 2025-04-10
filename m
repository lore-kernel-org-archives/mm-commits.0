Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D125634
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 23:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744328995; cv=none; b=fZ+6c99zuNTTIY7I1CgpBriFQs0ND1oJQX6QXxU9P1+k0EovU4m9vAfXPt4b3CgtOMtqOBlfuInhzEmbbVu9Mq6u1n5iLvQD9mljzFdQf/pis6l2fYjFvJPXZ7b4bDIC9Z+3uqIxH6cQuNi0j/PfSGt4IZHJpx3QHZ4f4JEgsTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744328995; c=relaxed/simple;
	bh=PJafjWeQ62rulDKdHUm2F4nxxv3jmYDf4F7ZSzVrTzw=;
	h=Date:To:From:Subject:Message-Id; b=bcoOId55Fi77xDNYnkip9KphxkyWj88nB6K03xvjv1nNZ/KB2Tsidfdu+4WY3D4JviOt+Jv1a2S8JFnfBjYTOpj3sAAAH27sT9GJvLS43d3TBtqf4x96NvqrsfrWaUcqf/UhVaIN6XNky97RNr+EIbOLQ+Gx46fAcrEP68k7gQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZBS5AGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZBS5AGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392BEC4CEDD;
	Thu, 10 Apr 2025 23:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744328995;
	bh=PJafjWeQ62rulDKdHUm2F4nxxv3jmYDf4F7ZSzVrTzw=;
	h=Date:To:From:Subject:From;
	b=SZBS5AGpt2pWgn2E7irDLQJDovFpLZhUqRcNPixxyiyzpi3aDL+58owlqz3htQY6z
	 bR1WwRc0YMnLU0RVshwNemta5rKAZslWratagq7orIDH2Wlt7QsuNzx2ncUyVMIAiD
	 EmacRjqTj/4y9FPxdEGZ3pycmnCB31fjYRNlRs/I=
Date: Thu, 10 Apr 2025 16:49:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhocko@suse.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,harry.yoo@oracle.com,hannes@cmpxchg.org,cl@linux.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-subsection-for-the-page-allocator.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410234955.392BEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add MM subsection for the page allocator
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-subsection-for-the-page-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-subsection-for-the-page-allocator.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: add MM subsection for the page allocator
Date: Thu, 10 Apr 2025 11:00:23 +0200

Add a subsection for the page allocator, including compaction as it's
crucial for high-order allocations and works together with the
anti-fragmentation features.  Add reviewers (including myself) who
voluteered.

Link: https://lkml.kernel.org/r/20250410090021.72296-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Brendan Jackman <jackmanb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-subsection-for-the-page-allocator
+++ a/MAINTAINERS
@@ -15511,6 +15511,21 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - PAGE ALLOCATOR
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+R:	Brendan Jackman <jackmanb@google.com>
+R:	Johannes Weiner <hannes@cmpxchg.org>
+R:	Zi Yan <ziy@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/compaction.c
+F:	mm/page_alloc.c
+F:	include/linux/gfp.h
+F:	include/linux/compaction.h
+
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-update-slab-allocator-maintainers.patch
maintainers-add-mm-subsection-for-the-page-allocator.patch
memcg-combine-slab-obj-stock-charging-and-accounting.patch

