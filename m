Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC814F12F
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738805; cv=none; b=tKO6c/VPLbv3mCEUAKfW0d+RlMHCHCfH/6TT5zvYS63DJAXk0LnBn5u3mfAvNep5OdyOpOSS+uovQPAzBSeddP4oI5AOOCfwej36sI4yetT1RFrl7u/nsHyuxb70RXR+KC0jn4awyzDy+zs2mEfQgIl9eg6mDFY5Xgaj0weTAzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738805; c=relaxed/simple;
	bh=DA9S8AjW8nSSIhO3Ck4p/idDiFWaY170RJ5c7zh/9/4=;
	h=Date:To:From:Subject:Message-Id; b=Q7DGCjzKRTRPWcxC+i9FqtUFhAmuL/E2o2u8xWfiC7+R0Y+VlMQVKjrGQwzrQYQmFJYX5zb9hlN2pntrR3O/j4Lmz1nFSxUkJ3o3iFlZrrnnUZ2DGT3OWPA2kr05SHxvuojkdBjU1H7lazjevBZmYYHJUdAl5rBYRJGO/vtMvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SC4UM0r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SC4UM0r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66947C4CEC6;
	Thu, 24 Oct 2024 03:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738804;
	bh=DA9S8AjW8nSSIhO3Ck4p/idDiFWaY170RJ5c7zh/9/4=;
	h=Date:To:From:Subject:From;
	b=SC4UM0r1xjNf2kEuS0porutwYO4jvUPxCxNP7vLBzUM/8vvvHQwKVXl4EuCKvxDI/
	 VojP2Nj7sKRuEcIEmaPPJzmXIipHSDcxAF1xqz58VK1SNEOW1zcXj8hzOpr886cYzg
	 hzCgtRYcBOQjTbc9FOpnIISIfqhGRk0ao/VMVdns=
Date: Wed, 23 Oct 2024 20:00:03 -0700
To: mm-commits@vger.kernel.org,yeweihua4@huawei.com,sj@kernel.org,sieberf@amazon.com,shakeel.butt@linux.dev,foersleo@amazon.de,zhengyejian@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch added to mm-unstable branch
Message-Id: <20241024030004.66947C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: Add 'nr_piece == 1' check in damon_va_evenly_split_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch

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
Subject: mm/damon/vaddr: Add 'nr_piece == 1' check in damon_va_evenly_split_region()
Date: Tue, 22 Oct 2024 16:39:27 +0800

As discussed in [1], damon_va_evenly_split_region() is called to
size-evenly split a region into 'nr_pieces' small regions,
when nr_pieces == 1, no actual split is required. Check that case
for better code readability and add a simple kunit testcase.

[1] https://lore.kernel.org/all/20241021163316.12443-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20241022083927.3592237-3-zhengyejian@huaweicloud.com
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    1 +
 mm/damon/vaddr.c             |    3 +++
 2 files changed, 4 insertions(+)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -300,6 +300,7 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_fail(test, 0, 100, 0);
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_succ(test, 4, 6, 1);
 	damon_test_split_evenly_succ(test, 0, 3, 2);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
 }
--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region
+++ a/mm/damon/vaddr.c
@@ -72,6 +72,9 @@ static int damon_va_evenly_split_region(
 	if (!r || !nr_pieces)
 		return -EINVAL;
 
+	if (nr_pieces == 1)
+		return 0;
+
 	orig_end = r->ar.end;
 	sz_orig = damon_sz_region(r);
 	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
_

Patches currently in -mm which might be from zhengyejian@huaweicloud.com are

mm-damon-vaddr-fix-issue-in-damon_va_evenly_split_region.patch
mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch

