Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D574320CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898283; cv=none; b=eqsme8jvG4Vb/eyiCAmDl50WP7TZLGZdyGlhewBQuFoD6IuasgbQ+uuDKOyleR/7nVYN0D0vhXrXMFHgu/SWD0RAcB/eZh2LmTgTtSVnsKKrxRQR1OpN9tSkTAgWnNz5MFnTjbLW05zG5WBh5WLGsPeA2Fj9jCDf2Cn6Siqf1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898283; c=relaxed/simple;
	bh=K9DDgXmx49XBWPnY9YDrBSyPTeIB4R9eeOOWR16qX1s=;
	h=Date:To:From:Subject:Message-Id; b=kOSih04S0pVAmiV4U4sApwAHpLCwtlWasD9AqfqkR7GOvb/s3BS0jXgVnZ63sj8F0PVZRZlkg0aIv9F6km/HCAMk9EdxWA+U64QOI2AWxLvxEqIdQYHOVdXV7VQyD4VHrRcbjOADwy3UwIJ2HA6pi+a3QCTrYk2bmSwagzD2EGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5QBP2p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5QBP2p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D5C4CEF1;
	Sat, 31 Jan 2026 22:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898283;
	bh=K9DDgXmx49XBWPnY9YDrBSyPTeIB4R9eeOOWR16qX1s=;
	h=Date:To:From:Subject:From;
	b=c5QBP2p//BaJDy46nViTw7VyswjYJVheLABpMN1CvkbuOa4j207vfh170MAU0vQwt
	 lmFh5qRyEGMtgwQICzErGA6UO621Kh5wOic6SHqjivmbcflP21A2OZ9WfrreMckzkr
	 KFjwGWEw6n0LE+gqebSG6fSSwKtGcfR/lG1BtEiM=
Date: Sat, 31 Jan 2026 14:24:43 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-filename-from-page_allocc-header-comment.patch removed from -mm tree
Message-Id: <20260131222443.AD8D5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop filename from page_alloc.c header comment
has been removed from the -mm tree.  Its filename was
     mm-drop-filename-from-page_allocc-header-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manish Kumar <manish1588@gmail.com>
Subject: mm: drop filename from page_alloc.c header comment
Date: Fri, 16 Jan 2026 01:01:00 +0530

The file name in the header comment is redundant and not useful, as the
location is already known from the path.  Remove it to align with kernel
coding style.  No functional change.

Link: https://lkml.kernel.org/r/20260115193100.116109-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c~mm-drop-filename-from-page_allocc-header-comment
+++ a/mm/page_alloc.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/page_alloc.c
  *
  *  Manages the free list, the system allocates free pages here.
  *  Note that kmalloc() lives in slab.c
_

Patches currently in -mm which might be from manish1588@gmail.com are


