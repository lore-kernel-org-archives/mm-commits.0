Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A5236F8F5
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027617; cv=none; b=Uwcn+wrQDTnqR65cIRfvvodetS+oibS8JlLFXnsxEp9oAvk91LNXvi1MO1LJc2QZmYygDNGl9/Du5KOAomprz8pKH/sfaRLCjIuq921vuVzPwmAAK/bWK6SwXyhJ8wRjGYZJeUVmBTrRmdSBQqB6XUg3woowBXb4o6VAV+Gk/EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027617; c=relaxed/simple;
	bh=W0lN0SChJ6HDGwdFtjzqk7emGiEFgRdsukMouhxQ0GU=;
	h=Date:To:From:Subject:Message-Id; b=YJLhLqApWmPL7hssbaKigFVGX4GCe9zKt00lne0Qcb4vAHq1815BsqpigdH8mxFgnfnFgo3BU3xJs4opbRJ8jovl4QxFjbjJG1dKFdiGcz4vPKfk9Ir6+483j0BQ6YcZF1s5KZsIQwBhW/3w0f5GOA1Pz6t1aiIFOQIAYRaQF+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mNqdrGPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mNqdrGPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA5E1F00898;
	Fri, 29 May 2026 04:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027616;
	bh=r3ntmQ9pF9xDlzyixeAw7swKRQHeCx+OWlb6Qim9AQs=;
	h=Date:To:From:Subject;
	b=mNqdrGPW7dOgDkTNm7SbgrtJ17LX5oFVNUGm0cNiPHOC5orl769H7rtSjWWQ0j8tO
	 sRXTq2eGbk1UATbY5Rc8LN7IKD5rMY2VjU2zaZ9AhBhs79fwRZuMchD+E0/lI7mxAs
	 6GdTBCViE9LsH005NqwNa1cN8siEZj2J2Q9ZEMB4=
Date: Thu, 28 May 2026 21:06:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch removed from -mm tree
Message-Id: <20260529040656.6FA5E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1418,7 +1418,7 @@ try_again:
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


