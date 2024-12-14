Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118BF6AA7
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136594; cv=none; b=U2NbyvVfw3R61egtNwPXXcA8AzV3EXK9+wAAcu6Q9ZAoHOdnWKBJlyqLtzPhSeNOVxkBAOFnVZxF+riDe4FLRWc3bEKxs58IMFO4RRqWagZ3NB05XK5aSBZCpYbiXGaveDkM/aXxFpRO7oPSSfArCFvNCPBfESKhwwuuWyMX3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136594; c=relaxed/simple;
	bh=flQGr35m0FOoUBsf3iPEfzsy2UGMSmVnVKfnAOmm0BE=;
	h=Date:To:From:Subject:Message-Id; b=KjpmGjp3dlmfsNi382uEAxKy5MEhlLnizXUaVpnPKeWr1+FjSZN+9PK6x3gxCsxT4Lc0KaVeSDvbijG6QSOR13nfP39hf34SEi0T4DuI0pbEOwMekqJ2hxXmHuq48Xg6qGHiF/5T0nURajm8JM6muaj//ZnODyoxJPOgtpGrxMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYTXpX5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYTXpX5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACAC4CED0;
	Sat, 14 Dec 2024 00:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136593;
	bh=flQGr35m0FOoUBsf3iPEfzsy2UGMSmVnVKfnAOmm0BE=;
	h=Date:To:From:Subject:From;
	b=FYTXpX5HViihSG9sR5JICY75KlSct/d4j9MfmPiyUpIMUj6Qdma8b+wAs08ICd8l4
	 a6b/F+ZrsWI7e53B/6NUvXSaVOHwfWJWG28d6P09j1HE7hQMWgaUMY4nC95uqf1Y5O
	 bmJToTJQQRWAfZQ6hmZBJbIqA8l32ca9xR4/Z/5E=
Date: Fri, 13 Dec 2024 16:36:33 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,alexjlzheng@tencent.com,alexjlzheng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch added to mm-unstable branch
Message-Id: <20241214003633.91ACAC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
Date: Fri Dec 13 04:35:29 PM PST 2024

s/mmap_Locl/mmap_lock/, per Liam

Cc: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix
+++ a/mm/memory.c
@@ -6141,7 +6141,7 @@ static vm_fault_t sanitize_fault_flags(s
 
 /*
  * By the time we get here, we already hold either the VMA lock or the
- * mmap_Lock (FAULT_FLAG_VMA_LOCK tells you which).
+ * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
  * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

