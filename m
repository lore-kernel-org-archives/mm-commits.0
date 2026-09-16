Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB52765DF
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 00:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789519953; cv=none; b=lSjUowniaOff9Eahv9xKiDG9gz+wIgxsEWzZ4emQOcb32eArua4xy12PWNciv15Nhv6FQPyYBiriiiE5AwJ48QnnhyO7KT2ufq4BRy2oWnb+M0E/NafLU2PeO8Z0WOKUcNU7AxTf1qjzoBerD7jVTzaApcJZcsK2Ut86Z+tXzdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789519953; c=relaxed/simple;
	bh=HXPzfcxCoSsDDwr/ViPQXH3vhwbLTaXYs3Vzi3YhnDU=;
	h=Date:To:From:Subject:Message-Id; b=trno8dADM7Bq8mlR31ES8eB6P4vrS0CXc0s5tJZH36AIxaCpOke3ERkGQ7waQjQNXB+bYDA53WvVbagTMwc+sobxbNJLCMSibd+bVD7mkWfN1NXwFZo4K5W5OEDOuiZIu9e+x9HpOmpcBNGREoDNmTy/pMZKLPAN9S4m3tg+DA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kPIhgSwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kPIhgSwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965921F000FF;
	Wed, 16 Sep 2026 00:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789519951;
	bh=SnaVXdzACGBAu3Qcm0zMcDncklCk/g+BT2SwYBi+cbU=;
	h=Date:To:From:Subject;
	b=kPIhgSwpW0/ZbIMExoh3q5EjeNygeMWBFINHjNYD+WJLVJQidjffKGuAjH9b6JnCB
	 DhbmGGk4anOCb24c9ScVb/DoAyQrTQ9GqdvekRCmxFNFsX/Uk+GabnszHu3OLHgpKy
	 X/ww/3MrSpo37ViqeXPWaAc5pNeJkQOoyZ6Pmue8=
Date: Tue, 15 Sep 2026 17:52:31 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-safely-calculate-gup-batch-size.patch added to mm-new branch
Message-Id: <20260916005231.965921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup_test: safely calculate GUP batch size
has been added to the -mm mm-new branch.  Its filename is
     mm-gup_test-safely-calculate-gup-batch-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-safely-calculate-gup-batch-size.patch

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
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: mm/gup_test: safely calculate GUP batch size
Date: Tue, 15 Sep 2026 15:55:24 +0530

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.  If it
wraps, the next > end check is bypassed and a large value of nr is passed
to the GUP call, even though the pages array was allocated according to
gup->size.  This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages.  The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and the
pages remaining in the address range.  Reject zero sized and non page
aligned gup->size values and zero nr_pages_per_call value.

Link: https://lore.kernel.org/20260915102524.125758-1-sarthak.sharma@arm.com
Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
---

 mm/gup_test.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-safely-calculate-gup-batch-size
+++ a/mm/gup_test.c
@@ -116,7 +116,8 @@ static int __gup_test_ioctl(unsigned int
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -139,11 +140,9 @@ static int __gup_test_ioctl(unsigned int
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

mm-gup_test-report-actual-pinned-bytes.patch
mm-gup_test-safely-calculate-gup-batch-size.patch

