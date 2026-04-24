Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD433ACA4B
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 11:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030893; cv=none; b=Cz+AG5qFB/19hz7JVwiIWwqr+QMz1rOFP+dCGykn1hbDdK7mxjmHrJed3JbCE8iHsINF6NmIXkzS49BKH39SmuQGUUeuQTX0PAX7bnGyd0sRq/ae1MBDFaeq3BHsrjPIyE83MMaKcu6HAxeDqla4xXzbO8mf0H1l0gdNpXoV0Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030893; c=relaxed/simple;
	bh=cUq++5+wT/5LY9b2/kBL9WqThZBNaOcQ8Aj1YuJ0m6E=;
	h=Date:To:From:Subject:Message-Id; b=Jj4w6N1eTEVrj6AbJG0x56xBiMI71Dv7wJEeuoUC6rLWyNpTW0+aTKq1TERN3A+6TtjGIZEgjn5fq59ViTQKIyqPYIA5u/+dDCEITEE4jGOUXHXDcvm/zwauf+16cIR2CHG3G5tc/jZjgA3pvyutKHlavlvmjhHKmbkCu/PaN6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=auZQHRVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="auZQHRVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E52BC19425;
	Fri, 24 Apr 2026 11:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030893;
	bh=cUq++5+wT/5LY9b2/kBL9WqThZBNaOcQ8Aj1YuJ0m6E=;
	h=Date:To:From:Subject:From;
	b=auZQHRVouKzxTRj0wiAbv2WxETqlWSoQ0lXlgafl6yG+IZ+jMGKacl+KvLbUlyXtu
	 KM8WOhSdYqk9H3X8yKyekG8PMTtb3cWUh31lw+jo4xPsKVaZlqB67+mMfENSC131V6
	 izKWqIaiy/8Bdk+JRysTFslLNf2OdEtDMopftBfI=
Date: Fri, 24 Apr 2026 04:41:32 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch added to mm-new branch
Message-Id: <20260424114133.6E52BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: remove unnecessary NULL check before allocating mem_section
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch

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
Subject: mm/sparse: remove unnecessary NULL check before allocating mem_section
Date: Sun, 19 Apr 2026 23:42:25 +0900

Commit 850ed20539a4 ("mm: move array mem_section init code out of
memory_present()") moved mem_section allocation logic into
memblocks_present().

Before that move, memory_present() could be called multiple times, so
unlikely() matched the common case, where most calls found mem_section
already allocated.

After that move, memblocks_present() is called exactly once from
sparse_init().  Under CONFIG_SPARSEMEM_EXTREME, mem_section is always NULL
when it is called.

So remove unnecessary NULL check before allocating mem_section.  No
functional change.

Link: https://lore.kernel.org/20260419144225.2875654-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/sparse.c~mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section
+++ a/mm/sparse.c
@@ -201,13 +201,11 @@ static void __init memblocks_present(voi
 	int i, nid;
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
-		unsigned long size, align;
+	unsigned long size, align;
 
-		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc_or_panic(size, align);
-	}
+	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+	align = 1 << (INTERNODE_CACHE_SHIFT);
+	mem_section = memblock_alloc_or_panic(size, align);
 #endif
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-hugetlb_cma-round-up-per_node-before-logging-it.patch
mm-sparse-remove-unnecessary-null-check-before-allocating-mem_section.patch

