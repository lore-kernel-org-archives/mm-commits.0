Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947CD1E378C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064665; cv=none; b=UcN7pZHLiFOr2bPnVfHAR0/lvPhfJj2le/5eciSkZdHfGXIefqjftr+y/X1lKB5W2OwWa8KLciH2FAE720jmPb3NMJ3PFvNnEYyRl+GlGcQqR5BJICb/NJL6/pbRXYey+f0s42V6bt/7LOm0aRL1KD/ASoPY/0SPZ+VMEmvIdYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064665; c=relaxed/simple;
	bh=E9gzK4a9Bs9bYwkySiDakSthSzKbL+NhBRmz+buk658=;
	h=Date:To:From:Subject:Message-Id; b=Dxg9d619jh1kQI8NSpdJiokkHWX00x3XJ/NTQjF3dgop8gpq0IpAhCHTW2V0R0WIP4pMvsaZR/rZ7bZRKNNDI/8HR7nOA4qeP83GBZUZ2T1v8Xf5pESRFBozFyYrYZ+O/spALr2pTsjBI6/gOyDjI4lbfaZIngFlyoBLIRo+Gmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HIBtLylp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HIBtLylp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CF6C4CEC6;
	Fri,  4 Oct 2024 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728064665;
	bh=E9gzK4a9Bs9bYwkySiDakSthSzKbL+NhBRmz+buk658=;
	h=Date:To:From:Subject:From;
	b=HIBtLylp5lWzmFqj+sirFTLNWLQLt/CP/5Ir8Y6MwbotpHgpCu+4kUWJSeDuwJBDw
	 uFSYTtOh49GyCrDMuE5uK6mLqL+1oNnXc25KlNZjoWQaBjLWT1Uzd6ptNJyxUm5/N5
	 Az1sIUtGeAbkG5WkTLOQ+HhNtc0azZ8MmhG/2hOM=
Date: Fri, 04 Oct 2024 10:57:44 -0700
To: mm-commits@vger.kernel.org,m.szyprowski@samsung.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-pageanonnotksm-fix.patch added to mm-unstable branch
Message-Id: <20241004175745.03CF6C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-pageanonnotksm-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-pageanonnotksm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-pageanonnotksm-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-add-pageanonnotksm-fix
Date: Fri, 4 Oct 2024 18:43:52 +0100

fix assertions

Link: https://lkml.kernel.org/r/ZwApWPER7caIA_N3@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-add-pageanonnotksm-fix
+++ a/include/linux/page-flags.h
@@ -1136,14 +1136,14 @@ static __always_inline int PageAnonExclu
 
 static __always_inline void SetPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
 
 static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageAnonNotKsm(page), page);
+	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
 	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch

