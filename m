Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CF2259CAB
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085544; cv=none; b=N0efuU5FamIhAQFGfLRxym96kvlkH6nTGQIf/HT3jswwO05MNd2U23r46dfjZPPzawmMBRLqVC1UMTNN/HzFjBig2o3Ses+FQH29LnqpSJQhtAP+6lmBO/lBRMR+y7UzVB2JK8Z0rJ1jQ5ZQCW9TAMKszG/tXD9FL/ocd6/LIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085544; c=relaxed/simple;
	bh=l3bZL5o3maoIcuFcIGAQaiOC50vt43Dsy5whlclc6qg=;
	h=Date:To:From:Subject:Message-Id; b=mWjO39dCFV9g9K/XcHZ92jWLhHH2kIWPSrFPUxcGnBw+1UqCvOGup/e/0WAxX/8knSwgWpw6qSi8266wDBQ8st69Dc1BJ3kipoLG5G9FQwAbnVR1gMcdkho/T4Tj7V+AKTP7bCMVqTsbuPKJvnddwjE3rlZcdXptOjH8bTK7Qz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P7cmuJ6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P7cmuJ6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C120DC4CEF0;
	Sun, 28 Sep 2025 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085543;
	bh=l3bZL5o3maoIcuFcIGAQaiOC50vt43Dsy5whlclc6qg=;
	h=Date:To:From:Subject:From;
	b=P7cmuJ6dtTqTtU+j9ZT7AtpynteiEQf2Xow8t8r+Y3sXOrrA+oiKracjPcMcW/rB8
	 CQlbmbj+QuZib7KNMlGU+8P8tRMhVB+wwDcWt2M+r4TTsMaBmaIoCKProSLssu+Z8o
	 YdqI3Kgpq3r+CkcKNt7f8vWtwEOiVvDJVaPDVa2s=
Date: Sun, 28 Sep 2025 11:52:23 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch removed from -mm tree
Message-Id: <20250928185223.C120DC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: increase number of reserving hugepages via cmdline
has been removed from the -mm tree.  Its filename was
     hugetlb-increase-number-of-reserving-hugepages-via-cmdline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhe <lizhe.67@bytedance.com>
Subject: hugetlb: increase number of reserving hugepages via cmdline
Date: Fri, 19 Sep 2025 17:23:53 +0800

Commit 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of
pages") batches the submission of HugeTLB vmemmap optimization (HVO)
during hugepage reservation.  With HVO enabled, hugepages obtained from
the buddy allocator are not submitted for optimization and their
struct-page memory is therefore not released—until the entire
reservation request has been satisfied.  As a result, any struct-page
memory freed in the course of the allocation cannot be reused for the
ongoing reservation, artificially limiting the number of huge pages that
can ultimately be provided.

As commit b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated
pages") already applies early HVO to bootmem-allocated huge pages, this
patch extends the same benefit to non-bootmem pages by incrementally
submitting them for HVO as they are allocated, thereby returning
struct-page memory to the buddy allocator in real time.  The change raises
the maximum 2 MiB hugepage reservation from just under 376 GB to more than
381 GB on a 384 GB x86 VM.

Link: https://lkml.kernel.org/r/20250919092353.41671-1-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-increase-number-of-reserving-hugepages-via-cmdline
+++ a/mm/hugetlb.c
@@ -3538,7 +3538,14 @@ static void __init hugetlb_pages_alloc_b
 	nodes_clear(node_alloc_noretry);
 
 	for (i = 0; i < num; ++i) {
-		struct folio *folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+		struct folio *folio;
+
+		if (hugetlb_vmemmap_optimizable_size(h) &&
+		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
+			prep_and_add_allocated_folios(h, &folio_list);
+			INIT_LIST_HEAD(&folio_list);
+		}
+		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
 						&node_alloc_noretry, &next_node);
 		if (!folio)
 			break;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are


