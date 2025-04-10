Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D959B71
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 01:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744248171; cv=none; b=goWhsQHeOavoIXYqhb90Ih8EiWUqdrlW8wfLJg83dINyyeOaB9CS9jDl7JuRmqREJgtPSRs5eT9rLCcgZA5GLM7oiEv/JSoMETjXHUdzLfr7e1IAAqraEa5ry5oJDNWFcLtvSdVblufIqWeJg71XTuDvr3bpr1F/4+Lsn36pfAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744248171; c=relaxed/simple;
	bh=hj2zn4cfEXVL8Z5tqp6Hqjw9KwhTr7eGnogBKD0aSYk=;
	h=Date:To:From:Subject:Message-Id; b=N7bg4tNjjTPIkIpuTivqOissjhgUK8z5z3OliF0C26JzxND0svvyNxqYzo8uRAPpdod59w1nIlmjjlmRaWvivjZ5IGqUKRUMGuKd/dK/2pWsszUB1rS1Wo8qzdn9aOjBmjrv92HNPYT2vDqwqmJa2kP/sz2hDhKsJhkPVoRXL+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzx9tvLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzx9tvLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8162C4CEE2;
	Thu, 10 Apr 2025 01:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744248171;
	bh=hj2zn4cfEXVL8Z5tqp6Hqjw9KwhTr7eGnogBKD0aSYk=;
	h=Date:To:From:Subject:From;
	b=hzx9tvLG0FKWexcvpTrQlB2uY6zIgTh8kqF8yCt4CfeCdG0vzczFuM12YRlcj9tVN
	 sapjCR6SqiUnZIgWb//XyG+CINUXFzc3atyE+3h8wWNLCNPnCbIAvt41CkKVpkcEyo
	 1U+AQwF/ye5O6lYhNLYAOZ6lBsvYAK28a7VVpB4o=
Date: Wed, 09 Apr 2025 18:22:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,hannes@cmpxchg.org,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch added to mm-new branch
Message-Id: <20250410012250.E8162C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: add folio_mark_accessed() when zapping file THP
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch

This patch will later appear in the mm-new branch at
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

Link: https://lkml.kernel.org/r/fc117f60d7b686f87067f36a0ef7cdbc3a78109c.1744190345.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp
+++ a/mm/huge_memory.c
@@ -2259,6 +2259,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
+
+			if (flush_needed && pmd_young(orig_pmd) &&
+			    likely(vma_has_recency(vma)))
+				folio_mark_accessed(folio);
 		}
 
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

selftests-mincore-fix-tmpfs-mincore-test-failure.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch

