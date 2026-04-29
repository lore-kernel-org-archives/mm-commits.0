Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9F73F7889
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466465; cv=none; b=mjuD7ndyblBAjoekx/3qblBzsbVCr/WHlKwOLF0yzkWdzn82IbT2cKOnQINzbEcpmIiePNJHlgDsz9fiRWe9QAPC9/2AVNgn0G35sZDcmTPcEtD6B9jgTym9tl5J6SdKMEO9+QqmTvc9urIYr6AXGl/7jRGWiJZmGTUmSE1X+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466465; c=relaxed/simple;
	bh=rLiv8Z4u+vHdTpYvE4TN2cANSNE5EcvIWSwHKPOScAI=;
	h=Date:To:From:Subject:Message-Id; b=G3SL3rarolG9McLS5AJZOZO3pBoSCuJSXbjvuR5q/EyUpfs6df6iGFJi3iLC9L3xdZj0+kOresO8oAPYPsq0WIJHfD66p5+yAmzw+BeFaLFcYW2fQ+xme8eCBa5gJyWiofYCIx4o7IKBdm1gCQmXq/YeN+YF0im52+neIf/zhEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nW5QCkKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nW5QCkKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9059C19425;
	Wed, 29 Apr 2026 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777466465;
	bh=rLiv8Z4u+vHdTpYvE4TN2cANSNE5EcvIWSwHKPOScAI=;
	h=Date:To:From:Subject:From;
	b=nW5QCkKYUjrvoIGp/0uP+otWNV2g5tQgUr86juYI6fFWXEDqJ9nTQveGXjrrDTZM3
	 UmRIF70JxG6kFP0Yk5AHriCgHNM6S1J2vD4GWtaCZQVaiLkprMHLTw1888yDE7eHFo
	 QIc0dQDEiNrIWn7xnth0w4WnnskMOcDsat9V1+hs=
Date: Wed, 29 Apr 2026 05:41:04 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bsegall@google.com,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-kasan-tagging-for-page-allocated-page-tables.patch added to mm-new branch
Message-Id: <20260429124104.E9059C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip KASAN tagging for page-allocated page tables
has been added to the -mm mm-new branch.  Its filename is
     mm-skip-kasan-tagging-for-page-allocated-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-kasan-tagging-for-page-allocated-page-tables.patch

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: mm: skip KASAN tagging for page-allocated page tables
Date: Wed, 29 Apr 2026 15:57:04 +0530

Page tables are always accessed via the linear mapping with a match-all
tag, so HW-tag KASAN never checks them.  For page-allocated tables (PTEs
and PGDs etc), avoid the tag setup and poisoning overhead by using
__GFP_SKIP_KASAN.  SLUB-backed page tables are unchanged for now.  (They
aren't widely used and require more SLUB related skip logic.  Leave it
later.)

Link: https://lore.kernel.org/20260429102704.680174-4-dev.jain@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgalloc.h~mm-skip-kasan-tagging-for-page-allocated-page-tables
+++ a/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
_

Patches currently in -mm which might be from usama.anjum@arm.com are

mm-page_alloc-optimize-__free_contig_frozen_range.patch
vmalloc-add-__gfp_skip_kasan-support.patch
kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch
mm-skip-kasan-tagging-for-page-allocated-page-tables.patch

