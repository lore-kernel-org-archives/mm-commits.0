Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87E13AA2B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479226; cv=none; b=iHOliw7oBViuTCINsaRzV8yos0KVELgn/vnT3XZOlyQXK/ScGxnzCTUiGY6UxYLI18NKp5Y30a6yoiA9raZUkNGTwslMLbpcgZ//7jT0dWLw1x+D6XWrL3vkoydNh0TDaurkhYXpNH+muKSazQrCE+FL+Us19GlXVx7BN/bIvkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479226; c=relaxed/simple;
	bh=JYul589Fjo5ymgAIiuEkBo8H2r5uJGZVcw4dGxx+dXA=;
	h=Date:To:From:Subject:Message-Id; b=FUQpchlTc9tbsonBzgvpeTiA86/GkC+FaMChieER3bA3UWh8m+8ps0Ncbw5CVWEi/nmI2Z3E8dMP0/7YILLC1x+pOCyjZhjMpMSj2mlh7P9YgR4r418PPJIgztl9xbxEIe6Ex+Q8bFt3BMK54diY+L0V7GNsapbKcz2n4Xw7T/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cEzqPGT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cEzqPGT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F7C4CEC2;
	Wed,  4 Sep 2024 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725479225;
	bh=JYul589Fjo5ymgAIiuEkBo8H2r5uJGZVcw4dGxx+dXA=;
	h=Date:To:From:Subject:From;
	b=cEzqPGT/avM5hS0iWRw8UiXrYdQ/+Wx8k9ISpSy1Wsh75yK9io1FUaua8J5743kKV
	 nhzRq+JIEB2N6mdUBeYuGmabwbUHPSZiNiO+iBGmej3XbtfrZhoX3PeIbyZ5AuAwMT
	 QuQL1wDmLCw0iw0GZFGG8VrpgFjpi7hqvtv57+wk=
Date: Wed, 04 Sep 2024 12:47:04 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,Liam.Howlett@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch added to mm-unstable branch
Message-Id: <20240904194705.4A8F7C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/vaddr-kunit: init maple tree without MT_FLAGS_LOCK_EXTERN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/vaddr-kunit: init maple tree without MT_FLAGS_LOCK_EXTERN
Date: Wed, 4 Sep 2024 10:29:31 -0700

damon_test_three_regions_in_vmas() initializes a maple tree with
MM_MT_FLAGS.  The flags contains MT_FLAGS_LOCK_EXTERN, which means mt_lock
of the maple tree will not be used.  And therefore the maple tree
initialization code skips initialization of the mt_lock.  However,
__link_vmas(), which adds vmas for test to the maple tree, uses the
mt_lock.  In other words, the uninitialized spinlock is used.  The problem
becomes clear when spinlock debugging is turned on, since it reports
spinlock bad magic bug.

Fix the issue by excluding MT_FLAGS_LOCK_EXTERN from the maple tree
initialization flags.  Note that we don't use empty flags to make it
further similar to the usage of mm maple tree, and to be prepared for
possible future changes, as suggested by Liam.

Link: https://lkml.kernel.org/r/20240904172931.1284-1-sj@kernel.org
Fixes: d0cf3dd47f0d ("damon: convert __damon_va_three_regions to use the VMA iterator")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/1453b2b2-6119-4082-ad9e-f3c5239bf87e@roeck-us.net
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -77,7 +77,7 @@ static void damon_test_three_regions_in_
 		(struct vm_area_struct) {.vm_start = 307, .vm_end = 330},
 	};
 
-	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
+	mt_init_flags(&mm.mm_mt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_USE_RCU);
 	if (__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas)))
 		kunit_skip(test, "Failed to create VMA tree");
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch
mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch

