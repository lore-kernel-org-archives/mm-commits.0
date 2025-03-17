Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269FB215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188360; cv=none; b=uHhtdN33kpyUEQKURGk4PxPCV1Hm+kGPhavUDm7ozsZuvNo/res5VVE7mgSA9lEnezv5lqkN67XlvMFAq6YCWsT10nyBUx+ciuQu+w7URqww9qBA20oksudt2GS4m7sNGwhhRLGCWEYuJ5n5iBhV44FKyJDz7Tuh6fMy1/z/efA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188360; c=relaxed/simple;
	bh=dtDLbuY5sBc7OLcu3qBWoDfVXbaaufmocFGE06TDtHA=;
	h=Date:To:From:Subject:Message-Id; b=g+utSIq2kAK7w9CSyAPXQrYfMYIcahwWqFVV8gtFcjaB8RGDye6JbNq/IdoAbn2k4Br1Iir1znwavVVK9hAiUlnnk+59fA/KRK8Q0hFzXiwHldbl8ZBBkESH4ISgV7ZBOpbMJqfTkZj+jobcpow1N7Mv4UlmeGLTecXXj8b+W8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xCVW7ht4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xCVW7ht4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7F3C4CEEC;
	Mon, 17 Mar 2025 05:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188360;
	bh=dtDLbuY5sBc7OLcu3qBWoDfVXbaaufmocFGE06TDtHA=;
	h=Date:To:From:Subject:From;
	b=xCVW7ht4gGJr2MlWeHFszwMatEEwicA+Rj1kywls14I0hwUS6s23zf9NuaShT3Z4k
	 Q3+YsN7uCoqGh0WBMs9OpL1sbaGP11AdwbKNTaw/I0JkXir0eBnzNwiZkGySmNdyPZ
	 DWNNcR3IXl0EkYEtviEm5X+r5ZJ9Gh4Tbk3Dj+aw=
Date: Sun, 16 Mar 2025 22:12:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-introduce-cma_intersects-function.patch removed from -mm tree
Message-Id: <20250317051239.EF7F3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: introduce cma_intersects function
has been removed from the -mm tree.  Its filename was
     mm-cma-introduce-cma_intersects-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: introduce cma_intersects function
Date: Fri, 28 Feb 2025 18:29:04 +0000

Now that CMA areas can have multiple physical ranges, code can't assume a
CMA struct represents a base_pfn plus a size, as returned from
cma_get_base.

Most cases are ok though, since they all explicitly refer to CMA areas
that were created using existing interfaces (cma_declare_contiguous_nid or
cma_init_reserved_mem), which guarantees they have just one physical
range.

An exception is the s390 code, which walks all CMA ranges to see if they
intersect with a range of memory that is about to be hotremoved.  So, in
the future, it might run in to multi-range areas.  To keep this check
working, define a cma_intersects function.  This just checks if a physaddr
range intersects any of the ranges.  Use it in the s390 check.

Link: https://lkml.kernel.org/r/20250228182928.2645936-4-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   13 +++++--------
 include/linux/cma.h |    1 +
 mm/cma.c            |   21 +++++++++++++++++++++
 3 files changed, 27 insertions(+), 8 deletions(-)

--- a/arch/s390/mm/init.c~mm-cma-introduce-cma_intersects-function
+++ a/arch/s390/mm/init.c
@@ -239,16 +239,13 @@ struct s390_cma_mem_data {
 static int s390_cma_check_range(struct cma *cma, void *data)
 {
 	struct s390_cma_mem_data *mem_data;
-	unsigned long start, end;
 
 	mem_data = data;
-	start = cma_get_base(cma);
-	end = start + cma_get_size(cma);
-	if (end < mem_data->start)
-		return 0;
-	if (start >= mem_data->end)
-		return 0;
-	return -EBUSY;
+
+	if (cma_intersects(cma, mem_data->start, mem_data->end))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int s390_cma_mem_notifier(struct notifier_block *nb,
--- a/include/linux/cma.h~mm-cma-introduce-cma_intersects-function
+++ a/include/linux/cma.h
@@ -53,6 +53,7 @@ extern bool cma_pages_valid(struct cma *
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
+extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
--- a/mm/cma.c~mm-cma-introduce-cma_intersects-function
+++ a/mm/cma.c
@@ -978,3 +978,24 @@ int cma_for_each_area(int (*it)(struct c
 
 	return 0;
 }
+
+bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
+{
+	int r;
+	struct cma_memrange *cmr;
+	unsigned long rstart, rend;
+
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+
+		rstart = PFN_PHYS(cmr->base_pfn);
+		rend = PFN_PHYS(cmr->base_pfn + cmr->count);
+		if (end < rstart)
+			continue;
+		if (start >= rend)
+			continue;
+		return true;
+	}
+
+	return false;
+}
_

Patches currently in -mm which might be from fvdl@google.com are


