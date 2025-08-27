Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0CE2882A8
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756263140; cv=none; b=NrCz1vbBO885jBl+p3GpBR/Ap0elCFDTYxIEbcheYWkIQRYi9kBenr4wwzi0oMO+Q0tq5vRhQFdH16gpLc6NUI/i46ZzzsLwSCsmYg8OHclHn7By56yWudeiMgsNGBR3mnQ96/2AYzhH8xM1cBYcbddLb8OqWBTHGzAzcUVt3rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756263140; c=relaxed/simple;
	bh=ctaNe2eMjCub7t7Ejz2uZvHuh0J4NUv4aAeqf1vxP1k=;
	h=Date:To:From:Subject:Message-Id; b=Vzu0z/UD4UI/tTBh6zMxjYsZ/PUXW6iXK6+eVdWQ/eWUAVtbGZpXt6IkFPXDj6gRP9PvSlTnSd68q/lWX1o++gZ+UrfG5bPbO2GlIHq8JwijOgWj1pkBGQfQ/y/uNXLGcq+r2K5k2aQyi5FBBMYbL4zRi4kFykCkAsA1i54qu58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dG28gZ6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dG28gZ6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E713EC4CEF1;
	Wed, 27 Aug 2025 02:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756263140;
	bh=ctaNe2eMjCub7t7Ejz2uZvHuh0J4NUv4aAeqf1vxP1k=;
	h=Date:To:From:Subject:From;
	b=dG28gZ6ka0I8WTpRM9b789x/VsxDAvLxr6gbU81aCkYQr9FLvwqyyyEtwJQ6h5xQX
	 vT4Xsl3EUIRd+vkUFPnkJh+CJUCbvues/vCQVgPK4XXHdA9wKtLfI+ZOynNazp+5JN
	 rbXNTpgik5F53QTCDdl6pVq1Lah2KOgGGDyXA4HY=
Date: Tue, 26 Aug 2025 19:52:19 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-drop-the-unnecessary-folio_nr_pages.patch added to mm-new branch
Message-Id: <20250827025219.E713EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: drop the unnecessary folio_nr_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-drop-the-unnecessary-folio_nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-drop-the-unnecessary-folio_nr_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: drop the unnecessary folio_nr_pages()
Date: Tue, 26 Aug 2025 17:35:55 +0800

We've got the number of pages in the folio earlier, thus remove the redundant
folio_nr_pages() call.

Link: https://lkml.kernel.org/r/67c80182ebd949e3894908e01e224697c143aabb.1756200587.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-drop-the-unnecessary-folio_nr_pages
+++ a/mm/shmem.c
@@ -2430,7 +2430,6 @@ static int shmem_swapin_folio(struct ino
 		goto failed;
 	}
 	folio_wait_writeback(folio);
-	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-use-folio-for-shmem_partial_swap_usage.patch
mm-shmem-drop-the-unnecessary-folio_nr_pages.patch

