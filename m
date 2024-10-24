Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5C156F30;
	Thu, 24 Oct 2024 03:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738803; cv=none; b=HBCWRg7PdI166aDDtDogAOh8vqjcQfk4ni54ZqNTtINbyqx7L14udZaQc3Ofhi8zbtSxIj+1tOOrTLWSsIDyMpCPhyytK1fSlRdgb4HpDX+AxgKTm+8DG0f7lcaEaW6oT5RFyWRrOqje7wAgw+1VZVTsXlFEAEIRhTGK4qGY15U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738803; c=relaxed/simple;
	bh=Y4iOGP+DCwBj9Plp01TpcArgJAABKF2G0i6KPJefUz4=;
	h=Date:To:From:Subject:Message-Id; b=AlyJMieARm13l2ax4Phf3SbhfVX2fmavV4ThWYYa5BVMlbKeJa++S8PaMRlcWaz2yGDYiH1h5+fz1UKXzCAgW7+lxKHUf6rxefyN68PvzqkB2ykT+0xR9FxQbnHH/qtAdtmHXg+isUmYLsKozsr9daD37Z8DpDIFePndmd4u3+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m7EKQeeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m7EKQeeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA7BC4CEC6;
	Thu, 24 Oct 2024 03:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738802;
	bh=Y4iOGP+DCwBj9Plp01TpcArgJAABKF2G0i6KPJefUz4=;
	h=Date:To:From:Subject:From;
	b=m7EKQeeUWBZ/z1tQ2ojkpkCr+yuKMVvwv+2IetD6E8LrttQzoh24AOPYRS8s2eUV4
	 3U+FUbpaayxyQm94OTelHRAtUPF6JDtvQUA+bP700uPFTdgjBqaW+cJVeaUVPyaFT1
	 5HNLyTxcj0eWVOAR/szP2gJRFChAvEmTkEhMPGpU=
Date: Wed, 23 Oct 2024 20:00:01 -0700
To: mm-commits@vger.kernel.org,yeweihua4@huawei.com,stable@vger.kernel.org,sj@kernel.org,sieberf@amazon.com,shakeel.butt@linux.dev,foersleo@amazon.de,zhengyejian@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch added to mm-unstable branch
Message-Id: <20241024030002.1AA7BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch

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
From: Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
Date: Tue, 22 Oct 2024 16:39:26 +0800

Patch series "mm/damon/vaddr: Fix issue in
damon_va_evenly_split_region()".  v2.

According to the logic of damon_va_evenly_split_region(), currently
following split case would not meet the expectation:

  Suppose DAMON_MIN_REGION=0x1000,
  Case: Split [0x0, 0x3000) into 2 pieces, then the result would be
        acutually 3 regions:
          [0x0, 0x1000), [0x1000, 0x2000), [0x2000, 0x3000)
        but NOT the expected 2 regions:
          [0x0, 0x1000), [0x1000, 0x3000) !!!

The root cause is that when calculating size of each split piece in
damon_va_evenly_split_region():

  `sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);`

both the dividing and the ALIGN_DOWN may cause loss of precision, then
each time split one piece of size 'sz_piece' from origin 'start' to 'end'
would cause more pieces are split out than expected!!!

To fix it, count for each piece split and make sure no more than
'nr_pieces'.  In addition, add above case into damon_test_split_evenly().

And add 'nr_piece == 1' check in damon_va_evenly_split_region() for better
code readability and add a corresponding kunit testcase.


This patch (of 2):

According to the logic of damon_va_evenly_split_region(), currently
following split case would not meet the expectation:

  Suppose DAMON_MIN_REGION=0x1000,
  Case: Split [0x0, 0x3000) into 2 pieces, then the result would be
        acutually 3 regions:
          [0x0, 0x1000), [0x1000, 0x2000), [0x2000, 0x3000)
        but NOT the expected 2 regions:
          [0x0, 0x1000), [0x1000, 0x3000) !!!

The root cause is that when calculating size of each split piece in
damon_va_evenly_split_region():

  `sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);`

both the dividing and the ALIGN_DOWN may cause loss of precision,
then each time split one piece of size 'sz_piece' from origin 'start' to
'end' would cause more pieces are split out than expected!!!

To fix it, count for each piece split and make sure no more than
'nr_pieces'. In addition, add above case into damon_test_split_evenly().

After this patch, damon-operations test passed:

 # ./tools/testing/kunit/kunit.py run damon-operations
 [...]
 ============== damon-operations (6 subtests) ===============
 [PASSED] damon_test_three_regions_in_vmas
 [PASSED] damon_test_apply_three_regions1
 [PASSED] damon_test_apply_three_regions2
 [PASSED] damon_test_apply_three_regions3
 [PASSED] damon_test_apply_three_regions4
 [PASSED] damon_test_split_evenly
 ================ [PASSED] damon-operations =================

Link: https://lkml.kernel.org/r/20241022083927.3592237-1-zhengyejian@huaweicloud.com
Link: https://lkml.kernel.org/r/20241022083927.3592237-2-zhengyejian@huaweicloud.com
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ye Weihua <yeweihua4@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    1 +
 mm/damon/vaddr.c             |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -300,6 +300,7 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_fail(test, 0, 100, 0);
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_succ(test, 0, 3, 2);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
 }
 
--- a/mm/damon/vaddr.c~mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region
+++ a/mm/damon/vaddr.c
@@ -67,6 +67,7 @@ static int damon_va_evenly_split_region(
 	unsigned long sz_orig, sz_piece, orig_end;
 	struct damon_region *n = NULL, *next;
 	unsigned long start;
+	unsigned int i;
 
 	if (!r || !nr_pieces)
 		return -EINVAL;
@@ -80,8 +81,7 @@ static int damon_va_evenly_split_region(
 
 	r->ar.end = r->ar.start + sz_piece;
 	next = damon_next_region(r);
-	for (start = r->ar.end; start + sz_piece <= orig_end;
-			start += sz_piece) {
+	for (start = r->ar.end, i = 1; i < nr_pieces; start += sz_piece, i++) {
 		n = damon_new_region(start, start + sz_piece);
 		if (!n)
 			return -ENOMEM;
_

Patches currently in -mm which might be from zhengyejian@huaweicloud.com are

mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch
mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch

