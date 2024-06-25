Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D25F33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293188; cv=none; b=ilJT2u+5Z/5pYid6JzJ9O5Mss5rIAJaQ85DNzcgTuyihVMzVXy4maE4D5Bs9pFQkmsUcw8wgHuEoZWnIx76nj6qbQk37jwRyi+W1zSqgEuRG3QmTpYZ5ax5jsx707Brmwb7wv09Qs6LhTjj5t1zAEG0BTqUznc47grdoKv7Qaoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293188; c=relaxed/simple;
	bh=4QXLYPammJLzb9U138jz+ujVA/9lnNFZviC8eDLmrog=;
	h=Date:To:From:Subject:Message-Id; b=te5L4cMLoW1KevPrYW/T+IJFMaCLDU3cH/TO2UiO54jaSJxGtp65ugn/bAnhe62NQpo2PJianwva+D4y9ezFOSXwFify8ehodsHy4p35MCuKxaQ+SjrIdODumVxolMwdXOK3tCuh4DrO1OPmi9TDpzGeh/SltWBtZcY3F1sVm7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KU02E2Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KU02E2Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8741C32782;
	Tue, 25 Jun 2024 05:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293188;
	bh=4QXLYPammJLzb9U138jz+ujVA/9lnNFZviC8eDLmrog=;
	h=Date:To:From:Subject:From;
	b=KU02E2ZhNWFfrt7bnr1m3pXhMCXaZBpu97yDHOr8w+mp2iR3/Oybfra+KDIgaKSAr
	 YCJn6nJOzZ0bzoGHNRo0VlUwYXg53aZV7JKDYLTz93vY0yoIGRla2stqCrd90ol445
	 diddeOyMEnV8weD3WuBFIIplc9QcRfDbRX1D0ef0=
Date: Mon, 24 Jun 2024 22:26:27 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch removed from -mm tree
Message-Id: <20240625052627.E8741C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: fix outdated comment regarding glibc qsort()
has been removed from the -mm tree.  Its filename was
     lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: fix outdated comment regarding glibc qsort()
Date: Tue, 28 May 2024 04:30:09 +0800

The existing comment in lib/sort refers to glibc qsort() using quicksort. 
However, glibc qsort() no longer uses quicksort; it now uses mergesort and
falls back to heapsort if memory allocation for mergesort fails.  This
makes the comment outdated and incorrect.

Update the comment to refer to quicksort in general rather than glibc's
implementation to provide accurate information about the comparisons and
trade-offs without implying an outdated implementation.

Link: https://lkml.kernel.org/r/20240527203011.1644280-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sort.c~lib-sort-fix-outdated-comment-regarding-glibc-qsort
+++ a/lib/sort.c
@@ -5,7 +5,7 @@
  * This performs n*log2(n) + 0.37*n + o(n) comparisons on average,
  * and 1.5*n*log2(n) + O(n) in the (very contrived) worst case.
  *
- * Glibc qsort() manages n*log2(n) - 1.26*n for random inputs (1.63*n
+ * Quicksort manages n*log2(n) - 1.26*n for random inputs (1.63*n
  * better) at the expense of stack usage and much larger code to avoid
  * quicksort's O(n^2) worst case.
  */
_

Patches currently in -mm which might be from visitorckw@gmail.com are


