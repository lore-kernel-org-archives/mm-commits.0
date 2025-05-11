Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCB17A2E8
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934913; cv=none; b=sgVrK0pPbZ9NzNYsCGftyrOJKhjmK/b2sKUB20mCXtV4bbEQt8zlbbgMjsHGpOKqWxwuIdtlxgIdEYvWBKBc+bkDfHqbJu6MmWAT0nGZYRPT4s0iRXf1zNRKbUmq4X+3I2A+lLUSaOA/uaAd5rc2VTngohLnnbHKTDYB7hWb8Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934913; c=relaxed/simple;
	bh=wmLiAFOTSLNdnhd4pUF460oORpISjaEm33WjwGUL/gA=;
	h=Date:To:From:Subject:Message-Id; b=ro4siyKRObl5WOBfqESmqzs6aCK5z1g6HN1L9D1LCjFjoaNWcQkv0IexLxb5bi2hlPY1GDAoX4+U5hk8X+0ez5XeAqQPGclW4CjpKJy7NovvIyOU4ttCyPXzbfiTgSyRkvUY2w9WeLJayBibgUB0Qm8SscORGeWLJD0GmnlEhVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZ/pgDFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZ/pgDFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0462C4CEE4;
	Sun, 11 May 2025 03:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934912;
	bh=wmLiAFOTSLNdnhd4pUF460oORpISjaEm33WjwGUL/gA=;
	h=Date:To:From:Subject:From;
	b=mZ/pgDFnACHRm5pj/TYqO+rAWMlqCsxXqGuQ6nQYFtTHiZy764ytSHJzwEeFjXObs
	 Urz+gv6CMg5jVwp12cIUhQBwJl8sWq1cBhnwwmcweFhu3NFyDJgt0tq9o2TjQUuXER
	 Uv9wJo/FciOR4QGN4mFjWqGL54s6RX3Qlp7wqWAs=
Date: Sat, 10 May 2025 20:41:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,osalvador@suse.de,hannes@cmpxchg.org,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch removed from -mm tree
Message-Id: <20250511034152.B0462C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.txt
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch

This patch was dropped because it was folded into mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.txt
Date: Fri, 11 Apr 2025 09:07:16 +0800

add comment

Link: https://lkml.kernel.org/r/23fdc11d-e983-4627-89a8-79e9ecf9a45a@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix
+++ a/mm/huge_memory.c
@@ -2260,6 +2260,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
 
+			/*
+			 * Use flush_needed to indicate whether the PMD entry
+			 * is present, instead of checking pmd_present() again.
+			 */
 			if (flush_needed && pmd_young(orig_pmd) &&
 			    likely(vma_has_recency(vma)))
 				folio_mark_accessed(folio);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch
mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch
mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

