Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A473D9DA8
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299204; cv=none; b=aKtk4Sv0zGbOhvBvBUWyEy4YEZMw7q4R1ATSX3eVk+0cV130RD6KoJr07f4YGLEhfdYTkDK/kRWDPkRlrQg9WMJqRNxlewHFIL67tu3oIf+dXz9hzL0LznTXyXSnRWxKcjwbN3h/ovKO7K/8osfdF91SCmT1AvZj0w2Y0djuGoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299204; c=relaxed/simple;
	bh=nA8Okg02x0A356lG8bjNK5WY5n6S10KiJ0zJA6+iuJA=;
	h=Date:To:From:Subject:Message-Id; b=KoaAlneu3WAZ3s/IEU7QdYjRqWIhsiPWu8zEH3GDhilvOJF6jf9ECeFmjUf72O+crESTiGtBgDEvohrQn+aHGzG9PZB7xROBj+Ib62RffiUJBHYs9jii0aO2xXljdltAsCN0TnvPzpnr5BWlDisNHIUMuCkka6ni147Qa1qnFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VaGECVpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VaGECVpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45F11F000E9;
	Tue,  1 Sep 2026 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299202;
	bh=M0731pRCKs+/VMh93FYZBFUMsvpyTSo0mxxX7lslxyQ=;
	h=Date:To:From:Subject;
	b=VaGECVpRe2A8+h0Cw+cSVrNFZxD8eV0zE8zsQqPrS1SLi6m4Wvpwf5JyG0UdqNlNw
	 uz/zR2PtobNxHMkbZGC05Cm6jLY3WKVYfLCvgq9oynr+dLAoelHI6kJKlSHtcjV3jU
	 rKxlYJAkS2zxXCk7PoXDnOhNDEBMssawOnXJpdx8=
Date: Tue, 01 Sep 2026 14:46:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-mark_page_reserved.patch added to mm-new branch
Message-Id: <20260901214642.A45F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused mark_page_reserved()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-mark_page_reserved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-mark_page_reserved.patch

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
Subject: mm: remove unused mark_page_reserved()
Date: Tue, 01 Sep 2026 15:38:04 -0400

Patch series "mm: remove three unused helpers from mm.h", v2.

I happened to notice these were unused.  Two of them are relatively
recently unused, and one has been unused for a few years.  Remove them.


This patch (of 2):

mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
mm: consolidate empty_zero_page"). Remove it.

Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu
Link: https://lore.kernel.org/20260901-mm-remove-unused-helpers-v2-1-f6474e169c23@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/mm.h~mm-remove-unused-mark_page_reserved
+++ a/include/linux/mm.h
@@ -4080,12 +4080,6 @@ static inline void free_reserved_page(st
 	free_reserved_pages(page, 0);
 }
 
-static inline void mark_page_reserved(struct page *page)
-{
-	SetPageReserved(page);
-	adjust_managed_page_count(page, -1);
-}
-
 static inline void free_reserved_ptdesc(struct ptdesc *pt)
 {
 	free_reserved_page(ptdesc_page(pt));
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-page_io-convert-write-completion-handlers-to-folios.patch
mm-remove-pagereclaim.patch
mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch
mm-page_io-rename-bio_associate_blkg_from_page.patch
mm-page_io-refer-to-folios-in-swap_writeout-comments.patch
mm-swap-rename-__swap_writepage-to-__swap_writeout.patch
mm-remove-unused-mark_page_reserved.patch
mm-remove-unused-totalram_pages_inc-and-totalram_pages_dec.patch

