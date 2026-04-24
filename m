Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B8A2BB1D
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777058528; cv=none; b=RK0vS4lrsNOD0RR9d875zQ8J7iBsBJFijPEd+sTwP872bTgHnn+EW/Z5L4AvtRDVMLVVYbku8FOy9jpu+vhZQUP78gN59aa3K9FwFYZx+e0PFYwx3XKyss0x1vwxT4l96pnpJVz55f1tczbhMGngZKx12CDD3bBLZjJwmCRIRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777058528; c=relaxed/simple;
	bh=PzLOGZuDmSIJRizMIylMi57bFfwUksUh3Ojy8CYrGYo=;
	h=Date:To:From:Subject:Message-Id; b=WqT8dTn+B9tGvy+weo7XQk3U4WuFSQhzVdQ+1yRJLjZ9iyweTWBRPod/Y7J4u1HFkk69DuF7uYu6zoBSRhVQCABFJYgOyMpsdq/ME/whlXrJFqtVP/2Oz20msWigAv4AIas134yxNDtWdD2QuQYC3SZ19oa2VaYdmImBE1PtzWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/t1SGJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/t1SGJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E56C19425;
	Fri, 24 Apr 2026 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777058527;
	bh=PzLOGZuDmSIJRizMIylMi57bFfwUksUh3Ojy8CYrGYo=;
	h=Date:To:From:Subject:From;
	b=x/t1SGJRVTuvYRlAtgMcH2sDcgfaGFY3F6mzya0jFAH80LiiWVlGGEn2l4sBdo9dC
	 nK7rWoKJh7REqMU/r7kEsMmKGUAHWTfIoltu7ZoxpGh2tb39qJsrWJQW0GfqJ4tqH7
	 /UD7UsUx5Vz2+txRbRFWShRuv1vl/XHLodH+0580=
Date: Fri, 24 Apr 2026 12:22:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch added to mm-new branch
Message-Id: <20260424192207.96E56C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch

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
From: wangxuewen <wangxuewen@kylinos.cn>
Subject: mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
Date: Thu, 2 Apr 2026 14:49:46 +0800

Replace the hardcoded magic number 3 in get_any_page() with the existing
GET_PAGE_MAX_RETRY_NUM macro for code consistency and maintainability.

This change has no functional impact, only improves code readability and
unifies the retry limit configuration.

Link: https://lore.kernel.org/20260402064946.1124250-1-18810879172@163.com
Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num
+++ a/mm/memory-failure.c
@@ -1501,7 +1501,7 @@ try_again:
 			 * We raced with (possibly temporary) unhandlable
 			 * page, retry.
 			 */
-			if (pass++ < 3) {
+			if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
 				shake_page(p);
 				goto try_again;
 			}
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch

