Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C1815532F
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816527; cv=none; b=R+1FOjwN0ka/+x7eChWuygtJOKer0zd/UqQuYIk1cvF5tIlHlmzQ5bt+12/Acxg3YRdr07AcdlTTJ4y9hv8geQQPKQ7zgoT+8lYwPuOiZtPHKl528/Zi/qQtsZxHKWUWbYtLcOluaAxvOUZ3QUNT3RATE+L17/E6qSoCV6z+3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816527; c=relaxed/simple;
	bh=9e9v/SB/9E34I14+26GxWcxWhe7y61diqrYSZD1Loq0=;
	h=Date:To:From:Subject:Message-Id; b=lCG4RyayQQuz6JGlVjGwK5uF4KU0Z1HNd8towceloiGh+RpK3+E5UrqBX1oRlItaC2Q243CUeRhbGUZsvhbmXCL5+fUPUJjLlR7Zt9nSB+d9bBCdNrYuZa28oGgq6A89sPTDWXAnWQJUJ/nAXpjFzu6r6dMInZex/5gWVVRsBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHuFIAQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHuFIAQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71CBC113CC;
	Mon, 22 Apr 2024 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713816526;
	bh=9e9v/SB/9E34I14+26GxWcxWhe7y61diqrYSZD1Loq0=;
	h=Date:To:From:Subject:From;
	b=UHuFIAQ108xYyGq3RewZKZ7m201/ytl31X6Y5kQT+JJWqcGSTP0pmEirSmv80Dy2r
	 YljFrc2nc1CWxyIT1j7bTo8CHZvIe6Z/LViby+Naidh41I+F6e14B1Yf9QPf+sQEpO
	 PrFJ5MLGzcYDpd0WLabh3Y4bxq7UUhvkM2ch56HM=
Date: Mon, 22 Apr 2024 13:08:46 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,ioworker0@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch added to mm-unstable branch
Message-Id: <20240422200846.D71CBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
Date: Mon, 22 Apr 2024 15:33:43 +0800

check the THP earlier in case the folio is split, per Lance

Link: https://lkml.kernel.org/r/b99f8cb14bc85fdb6ab43721d1331cb5ebed2581.1713771041.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2
+++ a/mm/huge_memory.c
@@ -2934,6 +2934,7 @@ int split_huge_page_to_list_to_order(str
 	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	bool is_thp = folio_test_pmd_mappable(folio);
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3112,7 +3113,7 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (folio_test_pmd_mappable(folio))
+	if (is_thp)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-fix-freelist-movement-during-block-conversion-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-3.patch
mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics-v2.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch
mm-set-pageblock_order-to-hpage_pmd_order-in-case-with-config_hugetlb_page-but-thp-enabled.patch
mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

