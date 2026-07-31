Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A53644BCA5
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521752; cv=none; b=etF2ro3H5g8tVJ4ZR7/0E0HU17OszRVCu8Sb3ZnamY7OXJtTjOpHCTUsXTo0UJCID2uNBsJ97HPATJi2tTUoJHIrmRdc4neOMFRtCvqmdfLwbpCnbUZl4rpKnro546IoE7Flz7CDMeuLqHnlJlmm/t1YTAK9SV4q86ZhNfAhdGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521752; c=relaxed/simple;
	bh=9R3tplXF+W8gLJ10t5pMHdav3HIsXHm3gUehYZkynMA=;
	h=Date:To:From:Subject:Message-Id; b=W5kUz8tLw6USyiviUDZKUSNrLaUVWsiPPxZMXMlKBf+W8u7GZXB/0kBw6yTzKv7s4j+cmmmp81M7C0T6AKDjO103prKtWB9LlLESvl416pfz43YUcC2Yphu1G2NS+QKG/bnInSsE8y6XbsfM3RPEtcvDW7hiOv3CIMtW7qhb8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O02/pXMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O02/pXMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E431F00ACA;
	Fri, 31 Jul 2026 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521741;
	bh=tbUR9248nPI3/ljrZyk6PhOlVwXU+n/jcZCWZsj7s3U=;
	h=Date:To:From:Subject;
	b=O02/pXMpgUDgSjR/Do8ZvVors3K6GipHI9cg4516/aYHBI2gCemH1iqV5UFwvfI7W
	 gaBKeBMDKN5EwRuLgD2a/8MOVLCKhQW51E3G5Tgw/iXAF3Z5xZWUsR0z/pmlZghBeM
	 vnCQ1+ZTpSVqc2mpsWbMgNB5Ns77EzlJS7pJOtRg=
Date: Fri, 31 Jul 2026 11:15:40 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-correct-init-section-annotations.patch added to mm-new branch
Message-Id: <20260731181540.F0E431F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: correct init section annotations
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-correct-init-section-annotations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-correct-init-section-annotations.patch

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch
mm-sparse-correct-init-section-annotations.patch

