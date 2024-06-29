Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F49816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627741; cv=none; b=BnQVnN47QLdEmxgBkB8YA2J82BUrMuqXqIAFCzA8F3j2RKOK1dt793gCRDrtHchNYRctLMe3RfZ9c6eFsLt2A2nwYKOeRycdSZpNkIdWJncDO6Pd8yvnsGuGB+Y5JTFXajsKRdp8kgBiwtcre32vInHtKn6reV/tAGxaTr9dlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627741; c=relaxed/simple;
	bh=3CzbF2um/E+pTTw2fQgenVIuANo+cPI2/UpGUcLL7wo=;
	h=Date:To:From:Subject:Message-Id; b=b8VmMBNDZ4lD1Sv+BCpX+jSr5wwyB/rBCs66PH+mXQ2XMDlEIY+MLrVXvV5PYe/J+x6mRStKdGGhEF4cc/jwtL9oRW1gXfgt/gv588SPK5amfGeNN7RRemYZk4qnd5gCSojqOwiV6m+dK3yfQG8ClS94k9DaVMJzcdCq0Wt+3Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qcPtR6qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qcPtR6qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1D0C116B1;
	Sat, 29 Jun 2024 02:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627741;
	bh=3CzbF2um/E+pTTw2fQgenVIuANo+cPI2/UpGUcLL7wo=;
	h=Date:To:From:Subject:From;
	b=qcPtR6qkcu1sN3vw/okNXzsyFwPfyJSOSY5KEuzhVuH9T2mQhYLalekGWAfrJKGSx
	 hrPtOTq4ZzRgttSjacIKIZrUVkSVoc89UVIsariI/7sukXBmyZ7DbYg9BysJqioKiz
	 lO8baJl2bia5KuIZwmmy/GdCybxzF18aMSOfFu2k=
Date: Fri, 28 Jun 2024 19:22:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch removed from -mm tree
Message-Id: <20240629022221.5C1D0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
has been removed from the -mm tree.  Its filename was
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

This patch was dropped because it was folded into mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
Date: Tue Jun 18 02:06:07 PM PDT 2024

comment fixes, per David and akpm

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    6 +++---
 mm/swapfile.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
+++ a/mm/memory.c
@@ -4343,9 +4343,9 @@ check_folio:
 		folio_add_lru_vma(folio, vma);
 	} else if (!folio_test_anon(folio)) {
 		/*
-		 * We currently only expect small !anon folios, for which we now
-		 * that they are either fully exclusive or fully shared. If we
-		 * ever get large folios here, we have to be careful.
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
 		 */
 		VM_WARN_ON_ONCE(folio_test_large(folio));
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix
+++ a/mm/swapfile.c
@@ -1917,9 +1917,9 @@ static int unuse_pte(struct vm_area_stru
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
 		/*
-		 * We currently only expect small !anon folios, for which we now that
-		 * they are either fully exclusive or fully shared. If we ever get
-		 * large folios here, we have to be careful.
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
 		 */
 		if (!folio_test_anon(folio)) {
 			VM_WARN_ON_ONCE(folio_test_large(folio));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memoryc-fix-used-uninitialized.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

