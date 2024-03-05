Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77B0EEC6
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600536; cv=none; b=X1HhvoQalM+x3FtnW7xrwALl4w0l1ni1KYQdugNUuitmD43duvQD2Td9ufZ0xBJ6qEGNpbFycvqs0Pj2mQe06FV/o6bMihzA+XZEVInQdVT+Rl7+uDKafm+EyRuvMF/LTbMNvx11B7BZ6LwZzMkbR9fTEWBYTXTEQHMqeWleGMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600536; c=relaxed/simple;
	bh=REKysteEtF/YCDTMkpaSEjST5LXM78OMiaXs6VR3//8=;
	h=Date:To:From:Subject:Message-Id; b=SUMT6DZm0JliabJ0DBICaxwvJVm6nVnUblUhXoszXAz97m1sAJJlUCOJJL2bPRqV8RX3MPLPa8xqa6hBjJGUlC58TDPVLVXemo8xEI5BupW2QgSwdIpPY88U46ElcbGD3659pN4cQU+U+/K6p1a8VTqb+KirN2lQN/Fq+499HdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xoXbX3fK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoXbX3fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA849C43390;
	Tue,  5 Mar 2024 01:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600536;
	bh=REKysteEtF/YCDTMkpaSEjST5LXM78OMiaXs6VR3//8=;
	h=Date:To:From:Subject:From;
	b=xoXbX3fKbPWm+yI+TrYVuxJsQaJEvuzPhQtypkep7R2SxveVc7TOZXNxiDg+2V/Gb
	 xlS9sGpqWgXue1kPoay0gtP+503vzcEpsQWI7R7NHKMpb60TW8nd4G/vl40s7oGYiU
	 LZ8a6ukhdqWNWtbbivEJ+xdPUMj0g7u9/ACoEgTg=
Date: Mon, 04 Mar 2024 17:02:16 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,hannes@cmpxchg.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch removed from -mm tree
Message-Id: <20240305010216.AA849C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: remove the details for pageout as paddr doesn't use MADV_PAGEOUT
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: Docs/mm/damon/design: remove the details for pageout as paddr doesn't use MADV_PAGEOUT
Date: Sun, 25 Feb 2024 11:47:51 +1300

The doc needs a fix.  As only in the case of virtual address, we are
calling madvise() with MADV_PAGEOUT.  But in the case of physical address,
we are calling reclaim_pages() directly.  MADV_PAGEOUT on virtual address
is much more aggresive to reclaim memory compared to reclaim_pages() on
paddr region.  This patch removes the details so that the description can
apply to both cases.  And we don't need to couple with the implementation
details.

Link: https://lkml.kernel.org/r/20240224224751.4673-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout
+++ a/Documentation/mm/damon/design.rst
@@ -315,7 +315,7 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
  - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+ - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
    Supported by ``vaddr`` and ``fvaddr`` operations set.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

