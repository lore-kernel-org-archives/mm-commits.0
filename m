Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2F7296BD6
	for <mm-commits@vger.kernel.org>; Sun, 15 Mar 2026 23:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773617898; cv=none; b=DjjnDYT4FtaBiKB7VKoDWc0LHHU93+1oXAx9rWPsrL3FzC0TdUR9ydSx8q3ECBpl/MQQRBW3xMMTfDS0e+1d8U5CWOujgtZTQQksAjLZ2uN11wa9FtqAcaHuCET8kx3o9YLY25mVA9MjxJV3DF1g3d3zN6YaBWiUnRWy9hz0wvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773617898; c=relaxed/simple;
	bh=TBIv/jSLY6mNGOukVDZ2RCMCBG1wFhQHtj+Jr2KVwwY=;
	h=Date:To:From:Subject:Message-Id; b=Pld6ZvLjA9A8VVn9llnwm/CRWU2BiXE9P74m0i1G5i3EEqouL0IsX23PXJXXPsIC9g4KBQoBU503v7EVZ3KNXe3aIyUSMFGQZKZSemhZdLblYvp4PuuaHDzqGDHG/zJutXStsCjYgeGr1xEnvQbSlBMhKnoTBI/RArWzkLXNfBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E+pMgD0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E+pMgD0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D0DC4CEF7;
	Sun, 15 Mar 2026 23:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773617897;
	bh=TBIv/jSLY6mNGOukVDZ2RCMCBG1wFhQHtj+Jr2KVwwY=;
	h=Date:To:From:Subject:From;
	b=E+pMgD0NBAZKl6RC7E1jdyH5yehGgu4qvlwTTK+b8aKXkJrY0XjrqJUjcabJsR21v
	 XM7kRQ/aDajktFJ2vFW/n3ZtQyxnfQYwJm5TM4mkP3AQkhZR/1v9F6i0Vv70u/vjlX
	 8XqH1T1mkliOGvxhOkhz3jZacKt/4swvkO0dnUkM=
Date: Sun, 15 Mar 2026 16:38:16 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_action_map_kernel_pages-fix-3.patch added to mm-new branch
Message-Id: <20260315233817.A0D0DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs: mmap_prepare: don't italicize structs
has been added to the -mm mm-new branch.  Its filename is
     mm-add-mmap_action_map_kernel_pages-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_map_kernel_pages-fix-3.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: Docs: mmap_prepare: don't italicize structs
Date: Sun, 15 Mar 2026 15:45:06 -0700

Using a single quote mark `struct xyz` causes the html output to be
produced as italic.  Omit the quote marks so that kernel-doc's automarkup
can make the "struct xyz" bold monospace ("code" style") in the generated
html.

Link: https://lkml.kernel.org/r/20260315224506.1973566-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/mmap_prepare.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_map_kernel_pages-fix-3
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -130,11 +130,11 @@ pointer. These are:
 * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
-* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
+* mmap_action_map_kernel_pages() - Maps a specified array of struct page
   pointers in the VMA from a specific offset.
 
-* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
-  page` pointers over the entire VMA. The caller must ensure there are
+* mmap_action_map_kernel_pages_full() - Maps a specified array of struct
+  page pointers over the entire VMA. The caller must ensure there are
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix.patch
mm-add-mmap_action_map_kernel_pages-fix-3.patch

