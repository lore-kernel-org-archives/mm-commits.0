Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B20113AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744933; cv=none; b=JEulKx1EgFyVMfoB51QJV+udBtUz15RyLihz97+sx86olrFEC1U+iXSc8O7hi5jPOJ7bv/RS0LRKILCyNAeSqzmMMOsM2J4bswiNP7jr9L4rBkzhxH1/iRaOX0k9COqj3idqDgITEVF2ILnm1ZuCG+6/H1ccdO01TJsCmRKiRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744933; c=relaxed/simple;
	bh=a7rJfLlVWgvYit7O1vHSNEUXxvT+PenXcerKsesxWwg=;
	h=Date:To:From:Subject:Message-Id; b=hiTNCL2QCJrxC0XuLFzXoY+w+BJPDNMfjHN92zC0unV8QIoNgh4iIoKxUYGIyNCMIyieH1zo5TZdGFyAPYS6KA8uCMiJ+ES4FgkOlsGuUzBoSEEKOvScbg6iXZZTGusbNDLLpoW2cA0svt/T3+u/mTHe641dnqTMqab2hVFwkCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNm0EiY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNm0EiY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9808C4CEF7;
	Sun, 29 Mar 2026 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744933;
	bh=a7rJfLlVWgvYit7O1vHSNEUXxvT+PenXcerKsesxWwg=;
	h=Date:To:From:Subject:From;
	b=SNm0EiY56YyzBCm2HufLFs8zhRKpOSTZg80iyO6JaHdaiBf+1wbAuzFt1ALQc1/Oj
	 ERhb3dZWIX6Yt7jbdgg2qfQkr4jTSWylYzj+9KYwhDLi5LuWryR1aAoqoJynir2Z9T
	 kpHPTngDhDkhFf8UQsfayjGCrrIFiiNfW/GP0YOU=
Date: Sat, 28 Mar 2026 17:42:12 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-sparse_decode_mem_map.patch removed from -mm tree
Message-Id: <20260329004212.E9808C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove sparse_decode_mem_map()
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-sparse_decode_mem_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove sparse_decode_mem_map()
Date: Fri, 20 Mar 2026 23:13:41 +0100

section_deactivate() applies to CONFIG_SPARSEMEM_VMEMMAP only.  So we can
just use pfn_to_page() (after making sure we have the start PFN of the
section), and remove sparse_decode_mem_map().

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-9-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 --
 mm/sparse.c                    |   16 +---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-sparse-remove-sparse_decode_mem_map
+++ a/include/linux/memory_hotplug.h
@@ -308,8 +308,6 @@ extern int sparse_add_section(int nid, u
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
-extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
-					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
--- a/mm/sparse.c~mm-sparse-remove-sparse_decode_mem_map
+++ a/mm/sparse.c
@@ -274,18 +274,6 @@ static unsigned long sparse_encode_mem_m
 	return coded_mem_map;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
- * Decode mem_map from the coded memmap
- */
-struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
-{
-	/* mask off the extra low bits of information */
-	coded_mem_map &= SECTION_MAP_MASK;
-	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
 static void __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
@@ -754,8 +742,6 @@ static void section_deactivate(unsigned
 
 	empty = is_subsection_map_empty(ms);
 	if (empty) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-
 		/*
 		 * Mark the section invalid so that valid_section()
 		 * return false. This prevents code from dereferencing
@@ -774,7 +760,7 @@ static void section_deactivate(unsigned
 			kfree_rcu(ms->usage, rcu);
 			WRITE_ONCE(ms->usage, NULL);
 		}
-		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
 	}
 
 	/*
_

Patches currently in -mm which might be from david@kernel.org are


