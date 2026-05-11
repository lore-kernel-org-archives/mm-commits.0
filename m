Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4B13B5821
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532973; cv=none; b=C0IShdE3RFgP7TmeuCI/QjHmbUBIYYF112Y0T+i+LXdXgvJAwtHBFpCQsHBxr4kJzNHmc7C4nnE9U+R6BETaov5YPZQxDsgXarr1hW1kRx8wENfJRLehzCje80fanMgxbX+6XJ48t0nk4d74id2jStjXkgLlQ8DuhDCqu5/a7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532973; c=relaxed/simple;
	bh=5dA76nBJLjmacPS8naQxF7l0UUjjBZ8e3kvCwYNOTf4=;
	h=Date:To:From:Subject:Message-Id; b=hVOjbppgolc+c9ER0yKrzmXdkALoYC2oi2FJGYeqHs22H18zfayCFdMzyNqJt38Rolc+xzMvEOtec1Qd3U7gPFYv4gG3Z/PRcUsruCmofW3az/CWeXwdWKmXJ/0q1D9G8tkpO29PsqVJFX/2ymjNnFvNZ9IephSJ9+OqulvOVIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IIk+Oe5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IIk+Oe5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E958EC2BCB0;
	Mon, 11 May 2026 20:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778532973;
	bh=5dA76nBJLjmacPS8naQxF7l0UUjjBZ8e3kvCwYNOTf4=;
	h=Date:To:From:Subject:From;
	b=IIk+Oe5S3Y+mwOQtW8m/04DbFW9rsVz854OxVr2bx00vjfabIJPGrz4DJVV1T2kne
	 c6FcBRWZTfzKwRa5jq7PHBnYEG13kTl4ETK7dhnsd7PmZYcKnE3E0N1v1hDd+3Lk/a
	 PeoVKGwvk3PV4VOuJRhaPPDlGHRo5Rj4229geCaU=
Date: Mon, 11 May 2026 13:56:12 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch removed from -mm tree
Message-Id: <20260511205612.E958EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: avoid unnecessary mTHP collapse attempts
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Sun, 19 Apr 2026 12:57:48 -0600

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail.  Avoid these collapse attempts by
bailing out early.

Link: https://lore.kernel.org/20260419185750.260784-12-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts
+++ a/mm/khugepaged.c
@@ -1517,9 +1517,31 @@ static int mthp_collapse(struct mm_struc
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases where lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_LRU:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			default:
+				return collapsed;
 			}
 		}
 
_

Patches currently in -mm which might be from npache@redhat.com are

documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

