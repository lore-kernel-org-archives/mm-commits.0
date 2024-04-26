Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BF7EF0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104029; cv=none; b=E5iZrQA9aBx6uETOQmQU9RZSLU10fdkOyWLt/jMnaGce5cR4YhFfKeFfjJ5ql/I8cbrIh34jUUfrT8XW/lPdeGHDKaD7jobH3XJgyFLjGypaS4Js5zdV32cxplATjMczTaoKDdMhYKS/KEf83o89aIxKFNSkFC6GXdGfQ7S6eis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104029; c=relaxed/simple;
	bh=aut2DL1NQFgnR2rRlUeQ50c2vlyg5ASMe88W+nuURbE=;
	h=Date:To:From:Subject:Message-Id; b=kJsjgCrXJP8I78QgiL1/CEhlrG2jKZQoUnTLlClX2AGkS6iGhPl+DEAAffASzRnsfKijpMQkcV14EIygLYFpuc7vMA2tirL/FJZPxhw41EVSVTzNzEpS2Js7OtmuQ+ThdmFb3gLqHfD1jrEQQEWsD2QYEd9VubswBnSKepSj8Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lvAkVtst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lvAkVtst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD0C113CD;
	Fri, 26 Apr 2024 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104029;
	bh=aut2DL1NQFgnR2rRlUeQ50c2vlyg5ASMe88W+nuURbE=;
	h=Date:To:From:Subject:From;
	b=lvAkVtstuItu6Mzr4zw116bFLSJcmdlpwQgh410upglfx7GB2lkK7ioNRp3AMjCDQ
	 DfZ+nR5wxsACz/I1lxCPUaI7ZAr04Jop34VvPQ5W/2opSlCAx8wPTYW/IM5f3+bFey
	 EJVsk3T+BghC7uz2uvocubky98XUsL/GaF0+Rnnk=
Date: Thu, 25 Apr 2024 21:00:28 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-array-mem_section-init-code-out-of-memory_present.patch removed from -mm tree
Message-Id: <20240426040029.58FD0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move array mem_section init code out of memory_present()
has been removed from the -mm tree.  Its filename was
     mm-move-array-mem_section-init-code-out-of-memory_present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: move array mem_section init code out of memory_present()
Date: Tue, 26 Mar 2024 14:11:27 +0800

Patch series "mm/init: minor clean up and improvement".

These are all observed when going through code flow during mm init.


This patch (of 7):

When CONFIG_SPARSEMEM_EXTREME is enabled, mem_section need be initialized
to point at a two-dimensional array, and its 1st dimension of length
NR_SECTION_ROOTS will be dynamically allocated.  Once the allocation is
done, it's available for all nodes.

So take the 1st dimension of mem_section initialization out of
memory_present()(), and put it into memblocks_present() which is a more
appripriate place.

Link: https://lkml.kernel.org/r/20240326061134.1055295-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240326061134.1055295-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/sparse.c~mm-move-array-mem_section-init-code-out-of-memory_present
+++ a/mm/sparse.c
@@ -226,19 +226,6 @@ static void __init memory_present(int ni
 {
 	unsigned long pfn;
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
-		unsigned long size, align;
-
-		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc(size, align);
-		if (!mem_section)
-			panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
-			      __func__, size, align);
-	}
-#endif
-
 	start &= PAGE_SECTION_MASK;
 	mminit_validate_memmodel_limits(&start, &end);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
@@ -267,6 +254,19 @@ static void __init memblocks_present(voi
 	unsigned long start, end;
 	int i, nid;
 
+#ifdef CONFIG_SPARSEMEM_EXTREME
+	if (unlikely(!mem_section)) {
+		unsigned long size, align;
+
+		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+		align = 1 << (INTERNODE_CACHE_SHIFT);
+		mem_section = memblock_alloc(size, align);
+		if (!mem_section)
+			panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+			      __func__, size, align);
+	}
+#endif
+
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
 		memory_present(nid, start, end);
 }
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

