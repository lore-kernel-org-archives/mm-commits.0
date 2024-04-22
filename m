Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF51553A3
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816675; cv=none; b=PEXBihMWusVhQPRDd+yM+LNMLKDUAgN/JqQRn9MZS0lz4jWUYnpQdhiFnsshglypPU84RxOzGstS4FgvZEmOKJa4h4sG1ay0k2J2vl5bQazo400/DF4qyCCu0waDZaA4gBwdorifygTqvCIXEmxYvYTc6e2oxs5aIT3bybAvI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816675; c=relaxed/simple;
	bh=Q/DtPlHn8jQ3pLGLUaVIIdq9kDRQzqbbvd2okmSIjHE=;
	h=Date:To:From:Subject:Message-Id; b=gj30vJRY/TZcJtWHIzVmiGgeLdTRSItS2OokqKFk44+4i6hMUPLMfCygjdYyFXbyQkRuONtC2mjIB6r7dAoKaFzlClo69TsF1n+HH0yH6jzht7BzuXBN68K9ooxxNL279jj3ov2Jj7PTvAxG/4BEm7U8zpfhrtuVAzbUGE7c6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2KrS1gI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2KrS1gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A73C116B1;
	Mon, 22 Apr 2024 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713816675;
	bh=Q/DtPlHn8jQ3pLGLUaVIIdq9kDRQzqbbvd2okmSIjHE=;
	h=Date:To:From:Subject:From;
	b=b2KrS1gItf2PWyQ5GTmFvdzZPclBXEYyQn/0yLJwO7j3sbek8fQz8k3hxVHxf2rrG
	 sOh2y8X7y+WOJ6HeBRH3kbaQU4KWNRa+gVE12Uf9B6eTANalb47blMmtB4xqDnqnx1
	 3LWznL09x5L1FsDBrgLbCYpdnB5UOZspYXGUhcL8=
Date: Mon, 22 Apr 2024 13:11:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,lrh2000@pku.edu.cn,josef@toxicpanda.com,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-make-pageuptodate-return-bool.patch added to mm-unstable branch
Message-Id: <20240422201115.69A73C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: make PageUptodate return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-flags-make-pageuptodate-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-make-pageuptodate-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make PageUptodate return bool
Date: Mon, 22 Apr 2024 11:27:25 +0800

Make PageUptodate return bool to align the return values of
folio_test_uptodate function

Link: https://lkml.kernel.org/r/20240422032725.41452-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-pageuptodate-return-bool
+++ a/include/linux/page-flags.h
@@ -789,7 +789,7 @@ static inline bool folio_test_uptodate(c
 	return ret;
 }
 
-static inline int PageUptodate(const struct page *page)
+static inline bool PageUptodate(const struct page *page)
 {
 	return folio_test_uptodate(page_folio(page));
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page-flags-make-__pagemovable-return-bool.patch
mm-page-flags-make-pagemappingflags-return-bool.patch
mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch
mm-page-flags-make-pageuptodate-return-bool.patch

