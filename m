Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C454968E0
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786647316; cv=none; b=GZ5IdN3WfASLSF6ukafEihODuSvuGHfaRMLZ6IQdj1DYCcbwghVpQUlW29yqKD9hxlt8wijEQEXDGsRVnpDuxiLJFt5L2iKM7G7/BVuWKzePthO0Q8RW8HUVLm3lk99TS70SLOqCcao6Rv6jCpW/4sNhcStpMO0YeDQlcs+d7DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786647316; c=relaxed/simple;
	bh=Lys+uAEnLhF2B5tdD1E9s6b/Uo+PtfKqZgPDcXh6ZJo=;
	h=Date:To:From:Subject:Message-Id; b=Snj4bY2EDw1lutaGRQ3B4qIgvh2a+9aFUiVk+ZDoEpvNU3ge3cN5xJBZhsLzVtcWM40hZUJ3jyr8ONzIG+mFfCH3Zk12940ol1PCKaWGNybauC8mIg3nYN3KFYAd0U+dkrEJGpaYetk7CvxTOY4YugvyJpGapI8MOn93mJvte8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=chlPj2ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="chlPj2ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B607E1F000E9;
	Thu, 13 Aug 2026 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786647313;
	bh=Is0tQNtQNxCxK08E46Pou0kOSZi17U5MyFae3JnT8qw=;
	h=Date:To:From:Subject;
	b=chlPj2ihXqSwB/xFIY9R2ahoevrL7cbnU+qkIwdpNK5ajIyaSLAMdFRNvLIFAf4BE
	 9HF7AxKVdTeXCadpm6bCAAUW86uN2du/rd7TDE7RqLpMig2l6Kic/J8c1H6xk+hsqc
	 r/lNBaRT4jBAl6EUlEFpPTvTaqqXbCO1trLoWUzo=
Date: Thu, 13 Aug 2026 11:55:13 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch added to mm-unstable branch
Message-Id: <20260813185513.B607E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: expand VMA merge tests to assert anon pgoff
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: expand VMA merge tests to assert anon pgoff
Date: Thu, 13 Aug 2026 18:32:32 +0100

Now we have introduced the VMA anonymous page offset attribute and update
it when VMAs are manipulated, update VMA merge tests to assert that the
anonymous page offset is as expected.

Also update instances where we could use vma_start_pgoff() to do so.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-15-c21581c0c3c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/merge.c |   45 ++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 9 deletions(-)

--- a/tools/testing/vma/tests/merge.c~tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff
+++ a/tools/testing/vma/tests/merge.c
@@ -121,6 +121,7 @@ static bool test_simple_merge(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -153,6 +154,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -165,6 +167,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -174,6 +177,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -183,6 +187,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -212,6 +217,7 @@ static bool test_simple_expand(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -234,6 +240,7 @@ static bool test_simple_shrink(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -346,6 +353,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -367,6 +375,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -387,6 +396,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -407,6 +417,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -426,6 +437,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -446,6 +458,7 @@ static bool __test_merge_new(bool is_sti
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
 		ASSERT_EQ(vma_start_pgoff(vma), 0);
+		ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -642,7 +655,8 @@ static bool test_vma_merge_with_close(vo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x5000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
 
@@ -753,7 +767,8 @@ static bool test_vma_merge_with_close(vo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x5000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
 
@@ -808,6 +823,7 @@ static bool test_vma_merge_new_with_clos
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -863,11 +879,13 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x3000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 3);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_next), 3);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -897,7 +915,8 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x2000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_next), 2);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 1);
@@ -929,11 +948,13 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x6000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -964,7 +985,8 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -996,7 +1018,8 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x9000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -1126,7 +1149,8 @@ static bool test_anon_vma_non_mergeable(
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_FALSE(vma_write_started(vma_next));
 
@@ -1157,7 +1181,8 @@ static bool test_anon_vma_non_mergeable(
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_FALSE(vma_write_started(vma_next));
 
@@ -1419,6 +1444,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1485,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

