Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46968827
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712963301; cv=none; b=bYf5ukW6guZxYUtTRltWYMrWFz0s4nHJQQPkrq0xbjPt6cuxpe1CQoG9gT1d2vXWtXyk/SxvoEbfHLbN19wUw8Ezke5oiltMz9bLAopNfeVMkU+8n75J0Cru4UydeA34MYj7kwdHMGOVrPKCRqxW2XwM8Td+yT8cMZIcxr2RiM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712963301; c=relaxed/simple;
	bh=BFxt4ZqFZKAVJCiKw04RLAd0Ilm/169qk8kPMR+k7hk=;
	h=Date:To:From:Subject:Message-Id; b=j3V6q+GHT7u+xivBub/QLEuHq8YPJSrqkLlTvZlquoE11xLhNq9+4MIxRdsf2Yej3Z0iWAjg90FqJgSOTEoWEit7SLBXDef/zuEvsYQKpcqq1OhcUqccBwPrU5pEWJOKkKzClct8lEtmvEQ8aDUKzmMx2MQMsHcZ781K75aQEmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dKjtrsIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dKjtrsIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334E5C113CC;
	Fri, 12 Apr 2024 23:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712963300;
	bh=BFxt4ZqFZKAVJCiKw04RLAd0Ilm/169qk8kPMR+k7hk=;
	h=Date:To:From:Subject:From;
	b=dKjtrsIotp0JgjBJUy/W04LQdJIsnUh59HKEzxUzZGHBLcwUvASyrRyCc7rBpP5ov
	 ia7MZoXPWhiFeCA+lCMZgg5tLXnLBfWmDE3j7phut0z4Ra3ZggPkMwz/TPk0/E2Pvc
	 ZopX70zpAZiX2x7weLKzKY3JfOoDc8iPb4y1VrOk=
Date: Fri, 12 Apr 2024 16:08:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,peterx@redhat.com,kasong@tencent.com,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,cerasuolodomenico@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch added to mm-unstable branch
Message-Id: <20240412230820.334E5C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct the docs for thp_fault_alloc and thp_fault_fallback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: correct the docs for thp_fault_alloc and thp_fault_fallback
Date: Fri, 12 Apr 2024 23:48:58 +1200

The documentation does not align with the code.  In
__do_huge_pmd_anonymous_page(), THP_FAULT_FALLBACK is incremented when
mem_cgroup_charge() fails, despite the allocation succeeding, whereas
THP_FAULT_ALLOC is only incremented after a successful charge.

Link: https://lkml.kernel.org/r/20240412114858.407208-5-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -369,7 +369,7 @@ monitor how successfully the system is p
 
 thp_fault_alloc
 	is incremented every time a huge page is successfully
-	allocated to handle a page fault.
+	allocated and charged to handle a page fault.
 
 thp_collapse_alloc
 	is incremented by khugepaged when it has found
@@ -377,7 +377,7 @@ thp_collapse_alloc
 	successfully allocated a new huge page to store the data.
 
 thp_fault_fallback
-	is incremented if a page fault fails to allocate
+	is incremented if a page fault fails to allocate or charge
 	a huge page and instead falls back to using small pages.
 
 thp_fault_fallback_charge
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

