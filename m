Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CEF417BE5
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 20:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035930; cv=none; b=qvg+SlK0wkKYvmTw0HKIeTtG/5Rq3OwdouV3CsAWxuQYS+7vF3H8hepmHV0N1X7HYOfz0LFYHHbfwNN/nkz225w6G4zZ8fjvmREgy2HMW6pKpodWrDurOJ/ua4u9V3qH6z9Q2x+mHZJ0t+jUArHAC9uQRzB/O81aSiQ31VL2Cf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035930; c=relaxed/simple;
	bh=XtEZjJuG9pu4Rza3JRewBHQT5u6Wxi3J2iZSVKdXve8=;
	h=Date:To:From:Subject:Message-Id; b=hjqQ/l+3u+dbIzX+IOIqO2cB639o7I3/XBDH7iMF3aFnBTJt/oE3CUmaVft/dlCQUEpSJk2MMsAOIeb+t//6mNgr3qsnagAui+ylJThxKd66AJdFrTCk4m59JCOXb+V12gnNr9wzb7WYgyTzewTCF6X6GUkseIGUs89SABLE0hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xBXKACjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xBXKACjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CDE1F000E9;
	Sat, 29 Aug 2026 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788035928;
	bh=0tEpvPpC6jkUwlCUwdVkpkwqdQTuwAi6abkJ961Ga/c=;
	h=Date:To:From:Subject;
	b=xBXKACjfP/9lJPigis2XRMG0y+EAabu1zBy00i0LWLUCIaapx2OMj6It4mO0ZiNoi
	 4g3Zm2o7gsuWMX6cQUSORgLL0IqN5q+nO/T4N1CXhIrjTlU6/HhFkmJEpK+YWQ0F7F
	 qeRzfrUsB6mqtVByRjcNQhs5Ty8kJER98xz6Mnwo=
Date: Sat, 29 Aug 2026 13:38:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_io-refer-to-folios-in-swap_writeout-comments.patch added to mm-new branch
Message-Id: <20260829203848.78CDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_io: refer to folios in swap_writeout() comments
has been added to the -mm mm-new branch.  Its filename is
     mm-page_io-refer-to-folios-in-swap_writeout-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_io-refer-to-folios-in-swap_writeout-comments.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: refer to folios in swap_writeout() comments
Date: Sat, 29 Aug 2026 15:09:04 -0400

swap_writeout() operates on folios, not pages.  Update its comments
accordingly.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-5-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-refer-to-folios-in-swap_writeout-comments
+++ a/mm/page_io.c
@@ -209,7 +209,7 @@ int swap_writeout(struct swap_io_ctx *ct
 		goto out_unlock;
 
 	/*
-	 * Arch code may have to preserve more data than just the page
+	 * Arch code may have to preserve more data than just the folio
 	 * contents, e.g. memory tags.
 	 */
 	ret = arch_prepare_to_swap(folio);
@@ -220,7 +220,7 @@ int swap_writeout(struct swap_io_ctx *ct
 
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
-	 * pages. The zero mark is protected by the cluster lock, which is
+	 * folios. The zero mark is protected by the cluster lock, which is
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch

