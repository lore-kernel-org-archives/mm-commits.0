Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89815B554
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728063165; cv=none; b=fUwA3wu3+DkbDXqFmOGeCyEuxfqepMOmK+CrwgfH27MnLmODdYeeTgqWRYsDmF3W3BzS4ut4/eHOfgKg3a/sHtt66zQqyj27t0LGBwZfFNCDhYe1BUMFCUqzSVopoDqzunwONqBZqnZNsIdjS5KztrARfQGdKeubVwHM3/fvaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728063165; c=relaxed/simple;
	bh=ZHJNMjjXaFtFFNoJhER+C2NpRVhZTVnwtdPdLRg1B5Y=;
	h=Date:To:From:Subject:Message-Id; b=MErFdnFIAgj/V038sLDPXgvw5gflG6/bNGDueQFWQuF6ba+unFbentvVyxxzuMhcONwYfbjEegmEPBnO4goP0wd/eZ0pAxIkmwP3nFDaYQG0/4eWkusQxwq0J41gLtCty53B15EWNgBH78xVCim6VCVW1kbln1bMGJ3zacS1vlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OwZfrASy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OwZfrASy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B7BC4CEC6;
	Fri,  4 Oct 2024 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728063165;
	bh=ZHJNMjjXaFtFFNoJhER+C2NpRVhZTVnwtdPdLRg1B5Y=;
	h=Date:To:From:Subject:From;
	b=OwZfrASynCXPhSMHfPLUgKCeulfXeZKzMBem6/pVHFtZC7APEEKESEmAzcciMuwGF
	 jpyYLXP3FLwOOX8JKJcgQgR1KiqSOZcf61wDeW1IMQ/rl6p7/xPgGVBgnXdHBCCrVt
	 ua48owNYcRD+vwX9Vpk+/iMLDjPv6mRNMhBE/trg=
Date: Fri, 04 Oct 2024 10:32:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,m.szyprowski@samsung.com,alexs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pageanonnotksm-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241004173245.24B7BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-pageanonnotksm-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-add-pageanonnotksm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pageanonnotksm-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-add-pageanonnotksm-fix
Date: Fri Oct  4 10:31:53 AM PDT 2024

hide problematic assertion

Link: https://lkml.kernel.org/r/853a1b27-8c74-4fd1-9186-1c0c1378a8ef@samsung.com
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-add-pageanonnotksm-fix
+++ a/include/linux/page-flags.h
@@ -1136,7 +1136,7 @@ static __always_inline int PageAnonExclu
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+//	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-pageanonnotksm-fix.patch

