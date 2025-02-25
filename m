Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FC525771
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 23:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740526379; cv=none; b=hLyJQR+U9cv73YVD898fn4FUgxX3ZzNo/nokwp0ufFNpRo6Pww2a5vMCbpsq/sA49rj++IsVkAnY/Mmak0NxqvQPknDrrTDLYHhZg35NUbOO5+EjPEXkF4OMsDhAdddKjMKqgXWZo71Dm+X2SCnlTEVkvhbnmMVPNrgNGq9CwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740526379; c=relaxed/simple;
	bh=2tRgqtdaQlE5cQCnfK1P1HBkezwlihY0aTADs7fQ5dA=;
	h=Date:To:From:Subject:Message-Id; b=JXuYx63y6vzPKgoLFhBv2LtWuLu45NYo43gfzuX1UxFEAmJ+jR4WC6MHhdFYWIsZovImTkr1Buqgetx+H4KWzgCL/cwdWUlp3Q0cqVp2rggONPzL3aaobzZdm3uTantQ+wSryb37BacVqeBvDMvP+12as0U8o/arYVy/4c71SWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mDNFuW4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mDNFuW4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5CBC4CEDD;
	Tue, 25 Feb 2025 23:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740526378;
	bh=2tRgqtdaQlE5cQCnfK1P1HBkezwlihY0aTADs7fQ5dA=;
	h=Date:To:From:Subject:From;
	b=mDNFuW4uTlqyaCYUgqp0r3yU43IiFNT/q4K82vbVrR9NwJUZTMUBslOlqW+fsQlpx
	 Qaw3w52wKAlZyXmWazWoWkKAjo1SGgcIoPy3EMUV09m0/e85AE01MSpmlQb4k2iknt
	 1Ii182V0JiKmMPffmH3p5V3YzRwI/e8LjE/v0WMk=
Date: Tue, 25 Feb 2025 15:32:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch added to mm-unstable branch
Message-Id: <20250225233258.DF5CBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: warn on nr_reserved_highatomic underflow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: warn on nr_reserved_highatomic underflow
Date: Tue, 25 Feb 2025 18:45:09 +0000

As documented in the comment this underflow should not happen.  The
locking has indeed changed here since the comment was written, see the
migratetype hygiene patches[0].  However, those changes made the locking
_safer_, so the underflow _really_ shouldn't happen now.  So upgrade the
comment to a warning.

[0] https://lore.kernel.org/all/20240320180429.678181-7-hannes@cmpxchg.org/T/#m3da87e6cc3348a4640aa298137bc9f8f61b76c84

Link: https://lkml.kernel.org/r/20250225-warn-underflow-v1-1-3dc542941d3a@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-warn-on-nr_reserved_highatomic-underflow
+++ a/mm/page_alloc.c
@@ -3095,6 +3095,7 @@ static bool unreserve_highatomic_pageblo
 			if (!page)
 				continue;
 
+			size = max(pageblock_nr_pages, 1UL << order);
 			/*
 			 * It should never happen but changes to
 			 * locking could inadvertently allow a per-cpu
@@ -3102,8 +3103,8 @@ static bool unreserve_highatomic_pageblo
 			 * while unreserving so be safe and watch for
 			 * underflows.
 			 */
-			size = max(pageblock_nr_pages, 1UL << order);
-			size = min(size, zone->nr_reserved_highatomic);
+			if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
+				size = zone->nr_reserved_highatomic;
 			zone->nr_reserved_highatomic -= size;
 
 			/*
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

