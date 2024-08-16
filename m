Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FEA43156
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845239; cv=none; b=DYGhqNZE52XbvohGsTPnSwHBGxVhctpkhWY2/oJNheONoiNxei56ExYr9N3/KCwonB0uI+k3G5Ie8A9XWxXr3FbGFjm7v3V4tjmuq8Gtpvz4z+RKGXhnrnj8dxhOMoalhLIGv7TyChXty0N4GbB4lTaEmvVrK1SpopxbE8MQhwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845239; c=relaxed/simple;
	bh=jd7XdsCY1wu03ZnJx2rQvP3RQW5q71afqjMWPSxE98Q=;
	h=Date:To:From:Subject:Message-Id; b=i6dZhvsUPC7sxM7k0mSzEgwKCbprGMyJCNrfkdK18D6NHaSyTrEJMI4DVrQw+n3agjgcnwvwl/o+5Y5nsspl6H18Gwyd9n2hwSTUmucLr+hh2bKVgCrs5NhGCM2OT8w63uhe/d9vra9iSNTyaCav5/aIrwu/EFAPgE/kV5RaQwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QSpR3W0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QSpR3W0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC333C32782;
	Fri, 16 Aug 2024 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723845238;
	bh=jd7XdsCY1wu03ZnJx2rQvP3RQW5q71afqjMWPSxE98Q=;
	h=Date:To:From:Subject:From;
	b=QSpR3W0EwG8L7LW2R1/xeF0cD7bD+x14656dtRAajA+Eg38EjstSj5FT6w7j0vi9q
	 yCAm8nLes7/Cyv2sARyAuZYLS3/a8XX+u77effFLLx/0su1CcHjzO8HqYw0IlNJwnH
	 gFOCjxnZAw0HUhJs0oqIgMkOLSGrAk9uW/j6uU5U=
Date: Fri, 16 Aug 2024 14:53:58 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shli@fb.com,kaleshsingh@google.com,gaoxu2@hihonor.com,david@redhat.com,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-lazyfree-folio-to-lru-tail.patch added to mm-unstable branch
Message-Id: <20240816215358.AC333C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add lazyfree folio to lru tail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-lazyfree-folio-to-lru-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-lazyfree-folio-to-lru-tail.patch

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
From: gaoxu <gaoxu2@honor.com>
Subject: mm: add lazyfree folio to lru tail
Date: Fri, 16 Aug 2024 07:48:01 +0000

Replace lruvec_add_folio with lruvec_add_folio_tail in the lru_lazyfree_fn:

1. The lazy-free folio is added to the LRU_INACTIVE_FILE list.  If
   it's moved to the LRU tail, it allows for faster release lazy-free
   folio and reduces the impact on file refault.

2. When mglru is enabled, the lazy-free folio is reclaimabled and
   should be added using lru_gen_add_folio(lruvec, folio, true) instead of
   lru_gen_add_folio(lruvec, folio, false) for adding to gen.

With the change in place, workingset_refault_file is reduced by 33% in the
continuous startup testing of the applications in the Android system.

Link: https://lkml.kernel.org/r/f29f64e29c08427b95e3df30a5770056@honor.com
Signed-off-by: gao xu <gaoxu2@hihonor.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-add-lazyfree-folio-to-lru-tail
+++ a/mm/swap.c
@@ -641,7 +641,7 @@ static void lru_lazyfree(struct lruvec *
 	 * anonymous folios
 	 */
 	folio_clear_swapbacked(folio);
-	lruvec_add_folio(lruvec, folio);
+	lruvec_add_folio_tail(lruvec, folio);
 
 	__count_vm_events(PGLAZYFREE, nr_pages);
 	__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
_

Patches currently in -mm which might be from gaoxu2@honor.com are

mm-add-lazyfree-folio-to-lru-tail.patch

