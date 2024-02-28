Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D740869
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146750; cv=none; b=gCVOWa5kBZ6Ni6RQA0KgwGyFG95wnbbGq5c1Gmn9cPjSKdcqChUAbRVgaWZNyqQrUZ9ZbpLn27VMyHx2f4uGov+woyd067iCHzcbBuqRuK5EsK9l+s68yeR+lQSs8q2QcEwnWuJipYfvnHk2qJLKKDPMVLId2uhpTw7tn32/cP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146750; c=relaxed/simple;
	bh=75utfuB50vR55ClGarMAHshor64YJKEiTqB3WIcvxBY=;
	h=Date:To:From:Subject:Message-Id; b=GKDPV0fMdlU53O3kDuAzzkiI60J1TyBsb9SdXALtV985QSPUm8DDGHDv/b2SWY1detSghCha7McAlysRwIk3QgB8Hu8Owk+ElqwGqEFkdqy2czeQpf3bGM6ZXnC30Kgt84+P53Xrj5HPK6XRi0z1b52C/OyHUpKz/DpmxiREbYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RsG6qLus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RsG6qLus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19739C433C7;
	Wed, 28 Feb 2024 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146750;
	bh=75utfuB50vR55ClGarMAHshor64YJKEiTqB3WIcvxBY=;
	h=Date:To:From:Subject:From;
	b=RsG6qLus3wsqJyir9EMn84Uluaw9JQ/OYV660OQN69+xDo/jQQUWAyOpNZZuolroQ
	 jCoxK83eDPsTMCAYUyh8THJDofU9cTPhqoNjxCegE5Peg5zJItYDSgXgK1z/ezLbaq
	 0rvKpw3dXg9U9fGPBCPbqEErd3x880U1gDos68g0=
Date: Wed, 28 Feb 2024 10:59:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageyoung-and-pageidle-definitions.patch added to mm-unstable branch
Message-Id: <20240228185910.19739C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PageYoung and PageIdle definitions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageyoung-and-pageidle-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageyoung-and-pageidle-definitions.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageYoung and PageIdle definitions
Date: Tue, 27 Feb 2024 19:23:30 +0000

All callers have been converted to use folios, so remove the various
set/clear/test functions defined on pages.

Link: https://lkml.kernel.org/r/20240227192337.757313-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageyoung-and-pageidle-definitions
+++ a/include/linux/page-flags.h
@@ -599,10 +599,10 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
 #endif
 
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young, PF_ANY)
-SETPAGEFLAG(Young, young, PF_ANY)
-TESTCLEARFLAG(Young, young, PF_ANY)
-PAGEFLAG(Idle, idle, PF_ANY)
+FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_SET_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_TEST_CLEAR_FLAG(young, FOLIO_HEAD_PAGE)
+FOLIO_FLAG(idle, FOLIO_HEAD_PAGE)
 #endif
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

