Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632D340298
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622810; cv=none; b=LooWsSgQGv5JMjIYdYXPgs86cFUZdTj5F958wWLSH64WJKNsWG/EwLySRFNQZRCBnfpZQHpXE7sE0FXsyzqXNL/v+Qu7ilHa5tEnuJf9aP9nwmWkGzey8/OyqxXZCtKiiqxPluiN5CeVWyarnJ5qVlhNrNgThdFl+j1ZhHXwdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622810; c=relaxed/simple;
	bh=BrydONvYR8BmOcSfkX6addZNhvcH3vLtPucf/nw9Uu0=;
	h=Date:To:From:Subject:Message-Id; b=F2UHJyVnHSBHX++VsRoDO+pg8oXgdpHcwhMSPpoH8mZrd/Il9QFx+1ffxi3A9GHcR3hD0HcBkYSDya/7mhyeT6b07KC1+qKhdtJjhYq3clMkS0FnVclCGR2iLadgzLSvXXxoqTjRxSCnAg57YgWOvKWaYGsT3Tm9zWxx48I2YBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xm6MRrbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xm6MRrbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1CA1F000E9;
	Tue, 25 Aug 2026 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622808;
	bh=1XIj2eFyCkx+KxOLnvT94iWwd+7RW9xlvK7i66WBYRU=;
	h=Date:To:From:Subject;
	b=xm6MRrbMs3FoAXumTz+gBliDDqcSkGIUJP/vNoFKUDUZYX04Nzdd4vpueogUPC7kU
	 62FfZe/nmaD7N0Ps4qOQiaXoVGbP8yUJOpE7GQt6A1z9kCx2Bc3lenXtV8qTWZGKcz
	 9BkcFE5SvYiPCrFfgG39HXsQGQO34wiKUY539VUg=
Date: Mon, 24 Aug 2026 18:53:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-correct-init-section-annotations.patch removed from -mm tree
Message-Id: <20260825015328.5F1CA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: correct init section annotations
has been removed from the -mm tree.  Its filename was
     mm-sparse-correct-init-section-annotations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/sparse: correct init section annotations
Date: Sat, 1 Aug 2026 01:47:55 +0900

The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation but
the SPARSEMEM_EXTREME variant is __meminit.  So mark the stub __meminit
too.

mminit_validate_memmodel_limits() is only called by memory_present(),
which is __init.  So mark it __init.

sparse_usagebuf and sparse_usagebuf_end are only used by
sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
which are all __init.  So mark them __initdata.

Link: https://lore.kernel.org/20260731164758.1210668-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/sparse.c~mm-sparse-correct-init-section-annotations
+++ a/mm/sparse.c
@@ -104,7 +104,7 @@ int __meminit sparse_index_init(unsigned
 	return 0;
 }
 #else /* !SPARSEMEM_EXTREME */
-int sparse_index_init(unsigned long section_nr, int nid)
+int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
@@ -127,7 +127,7 @@ static inline int sparse_early_nid(struc
 }
 
 /* Validate the physical addressing limitations of the model */
-static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
+static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
 						unsigned long *end_pfn)
 {
 	unsigned long max_sparsemem_pfn = (DIRECT_MAP_PHYSMEM_END + 1) >> PAGE_SHIFT;
@@ -249,8 +249,8 @@ void __weak __meminit vmemmap_populate_p
 {
 }
 
-static void *sparse_usagebuf __meminitdata;
-static void *sparse_usagebuf_end __meminitdata;
+static void *sparse_usagebuf __initdata;
+static void *sparse_usagebuf_end __initdata;
 
 /*
  * Helper function that is used for generic section initialization, and
_

Patches currently in -mm which might be from ekffu200098@gmail.com are


