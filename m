Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29A15B7
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 00:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721779362; cv=none; b=WFlPge+nesS1X6PmFn8E70iw4r58NKbuABPvFwAhHCeFX/NQgnqTBXzVBQFjImPuhzUFsTp64M33uFHRg01UiESh7KG9ANOJ4Z+TRK+JMwYQZLC9Jr2lNZxq1WZRmEOSqr+/hBDHvvK6raj+ZujC6LjVJDWJ4XSk72ZciqIQNOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721779362; c=relaxed/simple;
	bh=5+2hF15gA6pYdA3pvzV8BIF2DcrvC6UGyXhXoHLPtFg=;
	h=Date:To:From:Subject:Message-Id; b=pCB1JQyNBI6TmUz8ShMsAly8nLo55sPYsVBz1F5jGMGcayNrcMH3eEIQIar61ukMtmCSAqWrjeiDzQVJajVO3xIZ+k3rXKLWHqVhqMdPHpe9D3QB46+fYvnipCFeCOvJiUoHH0Nq0uDJpZmmexMLVuLfZ4gA3Mk42Ru5GmsDIRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CJnl3SNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJnl3SNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD7C4AF0A;
	Wed, 24 Jul 2024 00:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721779362;
	bh=5+2hF15gA6pYdA3pvzV8BIF2DcrvC6UGyXhXoHLPtFg=;
	h=Date:To:From:Subject:From;
	b=CJnl3SNZ26TXwvC2nSuYf7YIo92RBv4DwCpCaRCzpf5CvNy65zpA0XOfcTyHFnz8+
	 UXCSg2whWg2Gm/jMnw5YG3guKLoSIodNMOZaXvWmhUtLwD2sERMWGZjt4R0+JcUje0
	 yCGwfZmng48GZje8K3syzSKTJCLJ3NPVQBgc3rUM=
Date: Tue, 23 Jul 2024 17:02:41 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-foll_flags-in-__get_user_pages.patch added to mm-unstable branch
Message-Id: <20240724000242.4DFD7C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove foll_flags in __get_user_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-foll_flags-in-__get_user_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-foll_flags-in-__get_user_pages.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm: remove foll_flags in __get_user_pages
Date: Thu, 18 Jul 2024 17:26:07 -0400

Now that we're not passing around a pointer to the flags, there's no
reason to have an extra variable for the gup_flags, simply pass the
gup_flags directly everywhere.

Link: https://lkml.kernel.org/r/1e79b84bd30287cc9847f2aeb002374e6e60a10f.1721337845.git.josef@toxicpanda.com
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-remove-foll_flags-in-__get_user_pages
+++ a/mm/gup.c
@@ -1437,7 +1437,6 @@ static long __get_user_pages(struct mm_s
 
 	do {
 		struct page *page;
-		unsigned int foll_flags = gup_flags;
 		unsigned int page_increm;
 
 		/* first iteration or cross vma bound */
@@ -1488,9 +1487,9 @@ retry:
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, foll_flags, &ctx);
+		page = follow_page_mask(vma, start, gup_flags, &ctx);
 		if (!page || PTR_ERR(page) == -EMLINK) {
-			ret = faultin_page(vma, start, foll_flags,
+			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
@@ -1547,13 +1546,12 @@ next_page:
 				 * large folio, this should never fail.
 				 */
 				if (try_grab_folio(folio, page_increm - 1,
-						   foll_flags)) {
+						   gup_flags)) {
 					/*
 					 * Release the 1st page ref if the
 					 * folio is problematic, fail hard.
 					 */
-					gup_put_folio(folio, 1,
-						      foll_flags);
+					gup_put_folio(folio, 1, gup_flags);
 					ret = -EFAULT;
 					goto out;
 				}
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-cleanup-flags-usage-in-faultin_page.patch
mm-remove-foll_flags-in-__get_user_pages.patch

