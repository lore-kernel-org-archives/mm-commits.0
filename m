Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC67E3207
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 00:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762387317; cv=none; b=XacicPB0TY3Pxdb81WczDZ586yG0VFlQsSD+8KM2Q4ZBaIQlV2ZUqE9WMgmFqstBov6/N+QpEGCDUEQ7qKmr3HXkzKL4xDu8Ip/wVUz3NXId5Zj9w+/orVBB8Wt3PULWsja5e7Tafa6shNyJ73w/r+LZLoYTxQIZqDQ3UPGLpQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762387317; c=relaxed/simple;
	bh=4Zt0mqUZ9P3DRs4TxrH/M8ROchYUkYkvJbM/omMwsWw=;
	h=Date:To:From:Subject:Message-Id; b=kHWJGwDS+jsk3LM1qMD9w7uLuE7cVNet9ZhaFdgHpzQf8ouAhUWK/ch4YdoaEG70/0R/JIQVHHKRVMc5/OtU69kPMGba0PtY7x2fytGpyP7gtuUCXQVSVtEArHcN3VZvqqYvwG41kKgeYFd4IQJ/Ibs3hhxwFegamjdGKs4ovDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUojigAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUojigAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E63C4CEFB;
	Thu,  6 Nov 2025 00:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762387317;
	bh=4Zt0mqUZ9P3DRs4TxrH/M8ROchYUkYkvJbM/omMwsWw=;
	h=Date:To:From:Subject:From;
	b=HUojigAaceqmVzpH1crb1+JYVsx6vriy20FEk/d7U0Inz3oLv9cye7Qep5q5AEIp1
	 WcSXNckoLaAEfWm1S9i7PkABpgRQt9HP03TZn4G5Nne57OmhGxcmxtI/Avz8njdLDA
	 XVXFwoC7RWPwn5pVfoOq0XIQtd0TsllrmG0Aks2g=
Date: Wed, 05 Nov 2025 16:01:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch added to mm-unstable branch
Message-Id: <20251106000157.86E63C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
Date: Wed, 5 Nov 2025 11:01:09 -0500

add newline to fix an error and a warning from docutils

Documentation/core-api/mm-api:134: mm/huge_memory.c:3593: ERROR: Unexpect=
ed indentation. [docutils]
Documentation/core-api/mm-api:134: mm/huge_memory.c:3595: WARNING: Block =
quote ends without a blank line; unexpected unindent. [docutils]

Link: https://lkml.kernel.org/r/040B38C0-23C6-4AEA-B069-69AE6DAA828B@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
+++ a/mm/huge_memory.c
@@ -3591,6 +3591,7 @@ static void __split_folio_to_order(struc
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
+ *
  * 1. uniform split: @xas is split with no expectation of failure and a single
  *    __split_folio_to_order() is called to split the @folio into @new_order
  *    along with stats update.
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch

