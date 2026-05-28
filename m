Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740030C608
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 22:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007718; cv=none; b=k1foZdENO22Vcr1nPtj2zSM5Za3qD95s9vlNYRLT9nBEV/jJlxd1aTt3WPT5qwogIbNcI974mz3cx3IcFnbAFBM+m436gVnUVWsiIhEagx+uq2Y6MO/f9EVe9EkCc7DdVQKbo2naJa7zaDd62smjItyxCSbUXb9RVNZCeSEMan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007718; c=relaxed/simple;
	bh=1rsPLMfLOvpM0lrpyEzNHg6OD7OoF5e4sj2tA51Xc2I=;
	h=Date:To:From:Subject:Message-Id; b=tfPPVo+3crwUN7ljBSsRLp9cJ3TAhOebWYwn7GAMrHQDaW7kD0WEHjo01HR9sODAHHXymtrRc1YQQTq3RY2Y9IJUqbUYh938ehlhrZ7OSiyfKKrynjSi2ycrFKnf3syP6sNlQYEh5Qx0hfSkZEupb2XHaPY0Q8Qpr2RC65dtNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a14RhpWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a14RhpWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2925A1F000E9;
	Thu, 28 May 2026 22:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780007717;
	bh=5PTPJ5zO08TNEmBAqwN6mUyRwAWYgr8vGVQH2wRvudk=;
	h=Date:To:From:Subject;
	b=a14RhpWhSWTLBoUSJhueL4ZMd87kVRbZtCeCS4gXl0n2FO0wc3EK8kSC3ZIgxdT1s
	 xfLuEbxrQxk63LDD2MJzrxQfMk53CHjOhn919yRkTiTfvGqOg4mD+IOguahvqz7Ov5
	 0nXlcpZ4MrGzYQQ+iCVBAQWgiPklAehJBcfBV8Ko=
Date: Thu, 28 May 2026 15:35:16 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,leon@kernel.org,jgg@ziepe.ca,balbirs@nvidia.com,apopple@nvidia.com,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch added to mm-new branch
Message-Id: <20260528223517.2925A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
Date: Thu, 28 May 2026 09:13:36 +0800

Move the kvcalloc() calls after the early return checks to avoid leaking
src_pfns and dst_pfns when end < start or mmget_not_zero() fails.

Link: https://lore.kernel.org/20260528011336.20797-1-hao.ge@linux.dev
Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system
+++ a/lib/test_hmm.c
@@ -1130,9 +1130,6 @@ static int dmirror_migrate_to_system(str
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
 	start = cmd->addr;
 	end = start + size;
 	if (end < start)
@@ -1142,6 +1139,9 @@ static int dmirror_migrate_to_system(str
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
 	cmd->cpages = 0;
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
_

Patches currently in -mm which might be from hao.ge@linux.dev are

proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch
lib-test_hmm-use-kvfree-to-free-kvcalloc-allocations.patch
mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
alloc_tag-fix-use-after-free-in-proc-allocinfo-after-module-unload.patch
lib-test_hmm-fix-memory-leak-in-dmirror_migrate_to_system.patch

