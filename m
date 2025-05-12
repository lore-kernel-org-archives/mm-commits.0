Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FF119D8AC
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011109; cv=none; b=EK+9rTBRwKXXX+ZAxQg/T5GOjzkylHjctxeAKH9ti6qaByWbjTFjpMQMReZFc3lwoQJplwpJRHbbRVM4tH5wyI2BTYt+PK3tQEsHflXs/LvQ/c/6wFGbcAj4H4h5vDIYwa/1FIy/Kb/Hcsd2ePQHe3kxflR+kt+XmzKOkmPYkVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011109; c=relaxed/simple;
	bh=JmA4DKwPsaFWt7yyLoGA8DcPKN4AecTWa9fp+YDjG/w=;
	h=Date:To:From:Subject:Message-Id; b=SDZSwFDWo9GIVkltnEUPQGWYeRcdh5GPLNkO+peCfUu/9rc1KNvpxksbeBuRIvQ+j1IyodchfrD13cDxhghaFuzDxivUzu692FGgLW1gDJgL7KJwDa+t77cAU8dMKqOim3jgh3l009CNf9zzTtXmeSuLDM+atMAOonic5n0hYis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q029eEQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q029eEQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2C3C4CEE4;
	Mon, 12 May 2025 00:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011109;
	bh=JmA4DKwPsaFWt7yyLoGA8DcPKN4AecTWa9fp+YDjG/w=;
	h=Date:To:From:Subject:From;
	b=Q029eEQTdjJ2s0bjh+A6A+nW0QsTo1Bj0ofb9O60zRbTFUnZRgJSdjF7W0JplQR44
	 s5sfOpHZEKHmKbGuuS4EzFyq+VuWGaSQpn3vun+v3b27Mu2Z5f7dL4Epvwy51V6K+P
	 DITtExRcp6e6oTBw765sAueeOhyRwKgrpMTOCKGU=
Date: Sun, 11 May 2025 17:51:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,osalvador@suse.de,hannes@cmpxchg.org,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch removed from -mm tree
Message-Id: <20250512005149.3E2C3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: add folio_mark_accessed() when zapping file THP
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: add folio_mark_accessed() when zapping file THP
Date: Wed, 9 Apr 2025 17:38:58 +0800

When investigating performance issues during file folio unmap, I noticed
some behavioral differences in handling non-PMD-sized folios and PMD-sized
folios.  For non-PMD-sized file folios, it will call folio_mark_accessed()
to mark the folio as having seen activity, but this is not done for
PMD-sized folios.

This might not cause obvious issues, but a potential problem could be
that, it might lead to reclaim of hot file folios under memory pressure,
as quoted from Johannes:

: Sometimes file contents are only accessed through relatively short-lived
: mappings. But they can nevertheless be accessed a lot and be hot. It's
: important to not lose that information on unmap, and end up kicking out a
: frequently used cache page.

Therefore, we should also add folio_mark_accessed() for PMD-sized file
folios when unmapping.

[baolin.wang@linux.alibaba.com: add comment]
  Link: https://lkml.kernel.org/r/23fdc11d-e983-4627-89a8-79e9ecf9a45a@linux.alibaba.com
Link: https://lkml.kernel.org/r/fc117f60d7b686f87067f36a0ef7cdbc3a78109c.1744190345.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp
+++ a/mm/huge_memory.c
@@ -2259,6 +2259,14 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
+
+			/*
+			 * Use flush_needed to indicate whether the PMD entry
+			 * is present, instead of checking pmd_present() again.
+			 */
+			if (flush_needed && pmd_young(orig_pmd) &&
+			    likely(vma_has_recency(vma)))
+				folio_mark_accessed(folio);
 		}
 
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch
mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

