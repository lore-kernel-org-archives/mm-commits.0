Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB90F1AB514
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 22:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725576826; cv=none; b=PUauZ9m2gsmZsOzeWo/LfNw6XpXUJOrJfa22nUB7ORXOhM1Mop5vMNPWocTvbOBLdmxDmb+CUfufPHqcdl3D3kKAtWPJpkGF8Yf2SKgwZ5HfZ08WMnEHeN2mW+yCj2jVUD/K+oMUt26kqYYCl7F1sCu4nefGmTZ5ZAy5jrj6aP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725576826; c=relaxed/simple;
	bh=Sq0bfJ8WB2YyzqbV11c+Sp2rpty7BUqSydos1w3OuJ8=;
	h=Date:To:From:Subject:Message-Id; b=YxbKyeYmRre0MmnGQfuKnZf71ecQoqqLSGn7jY0s5xR4TQsz68FUxeJ3pWgLzDfVX1NPl3DEeJ7ofLsuZXKMASA5BwHDEWAYIJfaIKBsKVMYWucBcTAT4EiZsIWlr1XvAOPV0JU67MhAicPD5Dyjm4FAANlVPzbHWGOefF7FJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qm3qaDJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qm3qaDJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C28C4CEC3;
	Thu,  5 Sep 2024 22:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725576825;
	bh=Sq0bfJ8WB2YyzqbV11c+Sp2rpty7BUqSydos1w3OuJ8=;
	h=Date:To:From:Subject:From;
	b=qm3qaDJYvgN17lrMaMPAUg01S2PXH+hj4bEiP5ourEyB2l+GmJvmncwLlF8HbN84E
	 OWbsB1xT/DLMliao26s2RBUmcINm4tlUlR+12gOzTDeajtEXfypayrbXFTuqVApEDH
	 SvFHhr3evxWlnWCN+8PeGiapwnTiwnmHV2KukF0s=
Date: Thu, 05 Sep 2024 15:53:44 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch added to mm-unstable branch
Message-Id: <20240905225345.48C28C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix build with CONFIG_UNACCEPTED_MEMORY=n
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch

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
Subject: mm/page_alloc: fix build with CONFIG_UNACCEPTED_MEMORY=n
Date: Thu, 5 Sep 2024 14:22:20 -0700

When has_unaccepted_memory() is unused, it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

mm/page_alloc.c:7036:20: error: unused function 'has_unaccepted_memory' [-Werror,-Wunused-function]
7036 | static inline bool has_unaccepted_memory(void)
|                    ^~~~~~~~~~~~~~~~~~~~~

Fix it by removeing the CONFIG_UNACCEPTED_MEMORY=n stub.

Link: https://lkml.kernel.org/r/20240905142220.49d93337a0abce5690e515d9@linux-foundation.org
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lkml.kernel.org/r/20240905171553.275054-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-build-with-config_unaccepted_memory=n
+++ a/mm/page_alloc.c
@@ -287,7 +287,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order);
-static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -7068,6 +7067,11 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
+static inline bool has_unaccepted_memory(void)
+{
+	return static_branch_unlikely(&zones_with_unaccepted_pages);
+}
+
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept;
@@ -7095,11 +7099,6 @@ static bool cond_accept_memory(struct zo
 	return ret;
 }
 
-static inline bool has_unaccepted_memory(void)
-{
-	return static_branch_unlikely(&zones_with_unaccepted_pages);
-}
-
 static bool __free_unaccepted(struct page *page)
 {
 	struct zone *zone = page_zone(page);
@@ -7134,11 +7133,6 @@ static bool cond_accept_memory(struct zo
 {
 	return false;
 }
-
-static inline bool has_unaccepted_memory(void)
-{
-	return false;
-}
 
 static bool __free_unaccepted(struct page *page)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch

