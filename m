Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C123D0
	for <mm-commits@vger.kernel.org>; Sun,  7 Jul 2024 02:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720318633; cv=none; b=bXVkoEBxWHiuncPyMWmzY9vglDzGgKuNkdCgrXb8OwN395MUqqiM5rvTQj1vOIxExqfqqiv0DmNjFeByyniayEA4yyfu5lGtOdV3B88tcOMpVXY8i5pyhqaq+ZAVTnQ1BgfeoDmJiWjksdwR/wA6Hn9UneSDNinBE7tfclSwSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720318633; c=relaxed/simple;
	bh=S6CYVJqnvrAGJnEP5YIOxLMnONB/oEOPZI/VEFqE8Vk=;
	h=Date:To:From:Subject:Message-Id; b=fFwJmT/DW2lAGIlAy6cm7PTvqtFmPvED3+cyBdIgLHcp8Amq+RDGkJwZzO/3tcIGwpLBNrln1PbclgK7gP9DZ5v5KatcCxcWnaYNr7oqDjz7GQcRzjDxMVgNTNZgt6fPDT8V4KXI31bAJyCvhDRgUVfIHSmBM8AvlGdYBJoWNGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZIpegw4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZIpegw4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550B7C2BD10;
	Sun,  7 Jul 2024 02:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720318632;
	bh=S6CYVJqnvrAGJnEP5YIOxLMnONB/oEOPZI/VEFqE8Vk=;
	h=Date:To:From:Subject:From;
	b=ZIpegw4d1nSg2rGvnb5UckvzFbGb/flP28IHdlRFl/VO/lf9H3ZNSh4PFrGa+RngT
	 KGdi1Ny13NvjBVb4a3oAybaxHJ89LjJjnH2uAxV++jYmTjFnp5K/ONTDa38BuIjM+o
	 stNdQLf6chePsQq6wkjXvwUHkHj71rAcKG5UXR8E=
Date: Sat, 06 Jul 2024 19:17:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch added to mm-unstable branch
Message-Id: <20240707021712.550B7C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-docs-for-per-order-mthp-split-counters-v3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-docs-for-per-order-mthp-split-counters-v3-fix
Date: Sun, 7 Jul 2024 09:36:59 +0800

tweak Documentation/admin-guide/mm/transhuge.rst

Link: https://lkml.kernel.org/r/20240707013659.1151-1-ioworker0@gmail.com
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-docs-for-per-order-mthp-split-counters-v3-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -514,17 +514,16 @@ split
 	is incremented every time a huge page is successfully split into
 	smaller orders. This can happen for a variety of reasons but a
 	common reason is that a huge page is old and is being reclaimed.
-	This action implies splitting any block mappings into PTEs.
 
 split_failed
 	is incremented if kernel fails to split huge
 	page. This can happen if the page was pinned by somebody.
 
 split_deferred
-	is incremented when a huge page is put onto split
-	queue. This happens when a huge page is partially unmapped and
-	splitting it would free up some memory. Pages on split queue are
-	going to be split under memory pressure.
+        is incremented when a huge page is put onto split queue.
+        This happens when a huge page is partially unmapped and splitting
+        it would free up some memory. Pages on split queue are going to
+        be split under memory pressure, if splitting is possible.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-per-order-mthp-split-counters-v3.patch
mm-add-per-order-mthp-split-counters-fix.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch
mm-add-docs-for-per-order-mthp-split-counters-v3-fix.patch

