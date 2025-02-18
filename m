Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC1E1D86C7
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921897; cv=none; b=TxeG0M1ptH5ZJ1LZRYmfX9YXs40OX2/IRezsHFkVZeDqy6QA/oFxAQe6EeGBQMXjUfcpx/RuLMRUUZYVa9nUQodjYhYYRZq2gSkA6O/Yz+WwSolTmnofr3SUNASzlGc9JFZkysGLUsG+BDzEsw2/0d249hCgQJFQy1x0OXArZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921897; c=relaxed/simple;
	bh=ND1IB3tdyhK1Cg/up6QlTGvw8Kv0NUSYUgyYZXL7xHE=;
	h=Date:To:From:Subject:Message-Id; b=Sqw7elvROBZ/NNnL2QdYQWa2alJ2Ds97M1q2rTTjSiz/StIhjEt72wAm2BIFQkSRFoFu1terIjCjrbAIxR7n/+As2YoIpCoVrw0BoOy0rq6CEGoG084WD5pJDmTAqKnrc1g4M43d6XwiSAnRcscutFqTkn0zhrIN6xyr469AJ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2jh+5Mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2jh+5Mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB6C4CEE2;
	Tue, 18 Feb 2025 23:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921897;
	bh=ND1IB3tdyhK1Cg/up6QlTGvw8Kv0NUSYUgyYZXL7xHE=;
	h=Date:To:From:Subject:From;
	b=p2jh+5Mqaa8IjdX9xbjoP+IdOBJSiG4kuRNe6kRWAyh+RG5NM/Ne8iPqeHhchEhiq
	 3e+qKuGjo+VconnRugMOfVtyyYyhrQsWw13ALbYJMOATSdAlckFRg1gEGeYp9q7MKE
	 SjZh10KVp3Qjx2aSCUim3O7WxpNf7KmsB01nyl1Q=
Date: Tue, 18 Feb 2025 15:38:16 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch added to mm-unstable branch
Message-Id: <20250218233817.26DB6C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix typo on DAMOS filters usage doc link
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: fix typo on DAMOS filters usage doc link
Date: Tue, 18 Feb 2025 14:37:04 -0800

Patch series "Docs/mm/damon: misc DAMOS filters documentation fixes and
improves".

Fix and improve DAMOS filters documentation by fixing a copy-paste typo,
adding hugepage_size filter documentation on design doc, moving logic
details from usage to design, clarify DAMOS filters handling sequence
based on handling layer, and re-organizing the filters type list for
easier understanding of the handling sequence.


This patch (of 5):

The link from DAMOS filters design doc to usage doc has a typo calling
filters as watermarks.  Fix it.

Link: https://lkml.kernel.org/r/20250218223708.53437-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250218223708.53437-2-sj@kernel.org
Fixes: d31f5626a0e1 ("Docs/mm/damon/design: add links to sections of DAMON sysfs interface usage doc")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link
+++ a/Documentation/mm/damon/design.rst
@@ -617,7 +617,7 @@ Below ``type`` of filters are currently
     - Applied to pages that belonging to a given DAMON monitoring target.
     - Handled by the core logic.
 
-To know how user-space can set the watermarks via :ref:`DAMON sysfs interface
+To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
 documentation.
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch

