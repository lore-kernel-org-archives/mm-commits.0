Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C84255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744918; cv=none; b=DXkNOEe3ZED7mLZc1WbJnKzI3bpcDFgzL3XSXBfXkTz2iJzhzB07VsvTnvLmbT3YBLiYXUQZRZJjl+jb80M0HOk1mH619r+uSs5pqb7AW9SucAIBBDgMr6F2l/hggxkQ6+8otk1JjPVyXqJ3Y3eyJ5VlG1ImUDMUxT24Z82IrfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744918; c=relaxed/simple;
	bh=8KwQbVzBQwAhhg+G7bZ2U21f9FT9X0GE2ojZ9iGzrOQ=;
	h=Date:To:From:Subject:Message-Id; b=RPyfQba90OkybjAgN+wx/Mh8IdSoAwAhjLQ53uxJBtHEO1UAfZN8HQUrHPqy98lSUGURO05OAfQN+rZssc+yzYp5JkahDphl51vZ4/tBlaSsrH2rfwuDb+JzIR0qF0QeTJdNNNLnmkMcI8cXkZN44kdnGvHI7XT6zoXV7lDuQH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5mz7Tqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5mz7Tqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD80C4CEF7;
	Sun, 29 Mar 2026 00:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744917;
	bh=8KwQbVzBQwAhhg+G7bZ2U21f9FT9X0GE2ojZ9iGzrOQ=;
	h=Date:To:From:Subject:From;
	b=R5mz7Tqy1hQqf5Dh2aDFNAeEZsfKoL+RAV7Y3vA0mOcSmbpurMFStoXlblXFKprnT
	 GEsSF++KZ45FVAp5Dp9zXfErMi81RpEPLqvvHtTfEnxltAFvXNk/0pTHXI8Sdf/fRZ
	 OEdbAurxLxCfj6QNS++CteAPCOHneKjC4arV2P44=
Date: Sat, 28 Mar 2026 17:41:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch removed from -mm tree
Message-Id: <20260329004157.BFD80C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMON actions when TRANSPARENT_HUGEPAGE is off
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


