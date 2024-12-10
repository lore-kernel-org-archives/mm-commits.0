Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA797E111
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733797562; cv=none; b=SRUWp0m32fZkr8BPqN0TH13klQZqCJkWJxO8kDIztFe2UBUehAh99ze4DBiCjdjZtQmDlAJQMTEND5spvoj5XqpAVnRiz/AlQHUQpLrsHSvtntTOtR/w9CoYQ4A96fqsOqkSHaa9DuVNQO1s02mchd69vtXc/STNGb9KMYIVoZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733797562; c=relaxed/simple;
	bh=T/DpLTyhYRpT2hQxxxyxbuWHfYMVcs2RoS1lYpsH3bA=;
	h=Date:To:From:Subject:Message-Id; b=tapMEru7OLLmmZoy0FiEHX/KRH50u9z+YoaaaexkJ0cI6+nODSc3DHZ1TGTCBzR22uuw09Z/UqBOAOodj0KZVsZk2rR5Jbd+m956M0q/jBrHYJc3GI8bc8AVJh2bDbj+Ir1V6V+X7kG17yX5iNdZg4t8WGko3Cm2xlGYKKCir0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NptkFN2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NptkFN2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA806C4CED1;
	Tue, 10 Dec 2024 02:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733797561;
	bh=T/DpLTyhYRpT2hQxxxyxbuWHfYMVcs2RoS1lYpsH3bA=;
	h=Date:To:From:Subject:From;
	b=NptkFN2DuK1kTxvjybxiI9z6Oxxw1n3iKTcMZmzToeUHlg4Z+yKi7SXZiZIEuDGtL
	 vriIv4RNSy4BYvR3ET6QK78CoK6peQFzyrbpdmW67K1bBSqa1DCdLa4GgixPIY0+x/
	 c+wBPQSVCHgHWPdLDLw4BCcHKUR7SEmadH2UxnPo=
Date: Mon, 09 Dec 2024 18:26:01 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch added to mm-unstable branch
Message-Id: <20241210022601.AA806C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/vaddr-kunit.h: reduce stack consumption
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch

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
Subject: mm/damon/tests/vaddr-kunit.h: reduce stack consumption
Date: Mon Dec  9 06:20:01 PM PST 2024

After "mm: move per-vma lock into vm_area_struct" we're hitting

mm/damon/tests/vaddr-kunit.h: In function 'damon_test_three_regions_in_vmas':
mm/damon/tests/vaddr-kunit.h:92:1: error: the frame size of 3280 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Fix by moving all those vmas off the stack.


Closes: https://lkml.kernel.org/r/20241209170829.11311e70@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunith-reduce-stack-consumption
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -68,7 +68,7 @@ static void damon_test_three_regions_in_
 	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
-	struct vm_area_struct vmas[] = {
+	static const struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
 		(struct vm_area_struct) {.vm_start = 20, .vm_end = 25},
 		(struct vm_area_struct) {.vm_start = 200, .vm_end = 210},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch

