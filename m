Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867A7DA9E;
	Wed,  6 Nov 2024 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854869; cv=none; b=e7HYlLNoKwKn0OuprmOpJ99M0dkS/oM/yMpylSYLzLnswpBqqTcHKzry7c6zLOm4CTrSiezcHJ452zpfPDE1HDNSnFFAkRIWz68zBAyYaEutcBX//YM3IhhT8wkeudTMgGHeVYFO25IALU77ejRO0gRZ1vBwyAU3Qrm6cjEy328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854869; c=relaxed/simple;
	bh=c/Yr3lrToFwykC/Scu1cqKSLwL3lup8PEdRorOu/9+E=;
	h=Date:To:From:Subject:Message-Id; b=fEH/XSs62qiS5QP9OZdyxKqMTYpBnXYYs4nsrPect7CguYp7QHf2ZIZIsFHijzaHbFj+OzjAbRPuDRLZyjyPvx0MoOeFEUV+GQlSXOEJH7UXBkmTEnhqrn33B6BglTIiVD5zYsOzk8mMUj+AyVrNq+59FBEUMdtQ63K13mOw10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UqLRPifi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UqLRPifi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6A7C4CECF;
	Wed,  6 Nov 2024 01:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854869;
	bh=c/Yr3lrToFwykC/Scu1cqKSLwL3lup8PEdRorOu/9+E=;
	h=Date:To:From:Subject:From;
	b=UqLRPifiZDG9yWqDfN37z1BbyM9aeraiEFzMkUmaTGuN6bbWJiAXmWtfZyxPN6kPw
	 lIEwlWUcJDUW6Ft1jN/4889U2XHCftrr15PbD4uZDw4WadcLIP9oV6nqywSnfSI6I7
	 en7U7UikALCIUzMIwpA5SqsFnXM55D6CGyC1++vE=
Date: Tue, 05 Nov 2024 17:01:08 -0800
To: mm-commits@vger.kernel.org,yeweihua4@huawei.com,stable@vger.kernel.org,sj@kernel.org,sieberf@amazon.com,shakeel.butt@linux.dev,foersleo@amazon.de,zhengyejian@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch removed from -mm tree
Message-Id: <20241106010109.3A6A7C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: fix issue in damon_va_evenly_split_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


