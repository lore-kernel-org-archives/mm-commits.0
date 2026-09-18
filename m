Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534D751A742
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753431; cv=none; b=nlOoy2yqBLhgWPGqwARrAqslytQyYx3dkwgUUkwHu1mBaR9PxOIdLM1jSyfOrZqLLmyRuNmnmW5/ZPoBZtU7j1jatRmse29Z0q2Jl9AVV0trcVLv2Y+XQDw40MyU5i16AfBTVsjGWR0QuMfQVMa/nboZhu1Dkp9v5TFfzp0RNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753431; c=relaxed/simple;
	bh=1TlhNX42Q0NBRLTfYyjam1aa9rBnMrm/pEQ4J2tPc6M=;
	h=Date:To:From:Subject:Message-Id; b=b2MJFX8c18IwEH/+dlM8iQTDwUIz3n3uOCOK3HUDLP3lJY1OTYEYRNV+aPle/aHWZtW4B0fKW6fcfC3av2U1YBeKBA1o5l0D0ldVKQG13hXIfTZI9ZsZC4yN2phEC8H/TMWzI2UCPpi0w0Vr5+UIRxDyMaeEtF41rfTwCYyZI8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oWgV7eZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oWgV7eZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E371F000FF;
	Fri, 18 Sep 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789753423;
	bh=EAa6kAgV4A2F/yeuRbUf533GAuAo7g5m60jGhNSBjS4=;
	h=Date:To:From:Subject;
	b=oWgV7eZIaYFkEvvst5899H80WAYxt7KKw2YkYTnQOY1Im7FTAjrujeo67h064kv9K
	 kDj5yy8LB+LuKz5Z1aJKV2o2y/3qeELgaf8fFG9NE63KY1c9E2h3k2AsKJt8vhTpGE
	 KxRx2e7TIEaSeq99PDo4blQV864IuQ3EHVdBhDr4=
Date: Fri, 18 Sep 2026 10:43:43 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapops-remove-unused-is_hwpoison_entry.patch added to mm-new branch
Message-Id: <20260918174343.A3E371F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapops: remove unused is_hwpoison_entry()
has been added to the -mm mm-new branch.  Its filename is
     mm-swapops-remove-unused-is_hwpoison_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapops-remove-unused-is_hwpoison_entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/swapops: remove unused is_hwpoison_entry()
Date: Sat, 19 Sep 2026 01:56:40 +0900

Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
is_hwpoison_entry() has no callers.

So remove it.

No functional change.

Link: https://lore.kernel.org/20260918165642.1014988-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 include/linux/swapops.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/swapops.h~mm-swapops-remove-unused-is_hwpoison_entry
+++ a/include/linux/swapops.h
@@ -261,11 +261,6 @@ static inline swp_entry_t make_hwpoison_
 	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
 }
 
-static inline int is_hwpoison_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_HWPOISON;
-}
-
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
@@ -273,10 +268,6 @@ static inline swp_entry_t make_hwpoison_
 	return swp_entry(0, 0);
 }
 
-static inline int is_hwpoison_entry(swp_entry_t swp)
-{
-	return 0;
-}
 #endif
 
 typedef unsigned long pte_marker;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch
mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch

