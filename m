Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F6184540
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773862293; cv=none; b=YxRe1r8gFEoEV6qPnbtTY+PXmdURi9YylkqmU1imzXL0uHoJD+7l8RQsKNICCu6oWl09m6v8TudHf3iz/rLcueyN/8hG35zzsJ/3bijf+dtB1nHyGuHDkMTVgfTacO5CMwSzUi662GnBlUBpWOLO9qSH+yZi1+FCO6LFepFP4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773862293; c=relaxed/simple;
	bh=1TnkjxlvUMxq7jCQgEji+8od4cZu6oTKZmC12r0Xxwc=;
	h=Date:To:From:Subject:Message-Id; b=d1JHv60fuukDuAueqogM8AN0hz4yupRHcw7Sz+8AYOk3SNpEsORAbSbiuqinProDb1kHb1y3yiX1fLOJqvKZDc3jvS1igBQwXPD0VOt/mM+WFmOLxXmX3rU597S5jA9Q7nmu4fXwx/Tvd6txe8XilNchcy+cU3o83ZzH3gBIqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZUrbPtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZUrbPtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9A4C19421;
	Wed, 18 Mar 2026 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773862293;
	bh=1TnkjxlvUMxq7jCQgEji+8od4cZu6oTKZmC12r0Xxwc=;
	h=Date:To:From:Subject:From;
	b=TZUrbPtbdzgvWJOhC1YW3nssp04dduOzqVq3Q7rA6bq+ZTEXRRoFM82b+hPAaAqtU
	 O8VHU7BIlp87Ne93tMXH8jtBgB8SmwK7sodkSLCeE9alCbczJhriPmbjz5SZGclyFx
	 k3JVWzFvNOKjKR6aa48xhXDNAkI74m+HTkmkwGhM=
Date: Wed, 18 Mar 2026 12:31:32 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch added to mm-new branch
Message-Id: <20260318193133.4A9A4C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document DAMON actions when TRANSPARENT_HUGEPAGE is off
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch

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
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: Docs/mm/damon/design: document DAMON actions when TRANSPARENT_HUGEPAGE is off
Date: Tue, 17 Mar 2026 20:53:47 -0700

MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they are not available
when compiling the kernel without TRANSPARENT_HUGEPAGE option.  The DAMON
behaviour is to silently fail [1] in when DAMOS_HUGEPAGE or
DAMOS_NOHUGEPAGE are used, but TRANSPARENT_HUGEPAGE is disabled.  Update
the DAMON documentation to reflect this behaviour.

Link: https://lkml.kernel.org/r/20260318035349.88715-1-sj@kernel.org
Link: https://lore.kernel.org/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/ [1]
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off
+++ a/Documentation/mm/damon/design.rst
@@ -460,9 +460,13 @@ that supports each action are as below.
  - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are

mm-damon-remove-unused-target-param-of-get_scheme_score.patch
docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch

