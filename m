Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC14305699
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784049414; cv=none; b=fgxzgbjYnA84xVWRQyg3HXL5q1gDJfSFGCkDRTtMgYl40GXHuT3x3mB2+migBVkQdS0+FKM4nLCc70q6uH6fbEZPd0s2ClXPj8Dt6UHNV7qKtHIpJX6BaBLS4nhUc7Tcnl7qug4LxVI4/lpVK1t16iSBS9wLk1THyYAOwsE4hPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784049414; c=relaxed/simple;
	bh=A8+x6co2gS8vGXz/ZanBMu+mVz64wFaR/+wAiJidUdU=;
	h=Date:To:From:Subject:Message-Id; b=QsNOU5PKudSdxu5Nz71pXrqocZvtJGNtni6/y2ycg/iqGToZqmrblQV47hc1X7/rEPpmIjNyqFVdEqNFf/bfQLX7HQoTL3PvLaTCpsqrGrG+DlsYgzSzl7IjddHGy0kbjeQpb2Uax9SX1FOA8Ea976HkQsB+s83A0LBKHJaDWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2thXtTuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2thXtTuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA451F0155B;
	Tue, 14 Jul 2026 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784049413;
	bh=+S05WbEWkCNSods6Er/iDL1W1I5Ttqx7OXztS1aUD/w=;
	h=Date:To:From:Subject;
	b=2thXtTuGEGGKI0UtxGEaiok7Be/MLWoVJ2V7LQ/g5gAu/gaZqrc8xyw/SSCTl0Sv0
	 zttmC89JlimdPBhLvMbqDLVc1vr70HwXPNk8f7UWHWfsrBqPWXzObk8P2+P6B/U5HO
	 WKeKlq2o2L9JKjeOq5UlGbilFEsAiETkG1q632bQ=
Date: Tue, 14 Jul 2026 10:16:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,songmuchun@bytedance.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch removed from -mm tree
Message-Id: <20260714171653.0FA451F0155B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch

This patch was dropped because it was folded into selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
Date: Sun Jul 12 12:09:22 AM PDT 2026

don't clean old executables out of .gitignore

Link: https://lore.kernel.org/CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -3,9 +3,11 @@ cow
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
+hugepage-vmemmap
 hugetlb-mmap
 hugetlb-mremap
 hugetlb-shm
+hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

