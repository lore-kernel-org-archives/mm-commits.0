Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431933C7E1E
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 13:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296137; cv=none; b=oYfSxi9bWLA/5cjEmhIndloCxw8y8KCWbyhkxbiu1WTmGaY4j8lrMDpkWPlFgMnqj6nWSSimi0RH33RNOnMAIOoWbCMevwtcjUtJ4K1se1VAt4Y5ZxRBjl/pn+xtBofFIto9YdtOej5fL9YVqywVk3GHXtJttW8cpRrRzAmS/vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296137; c=relaxed/simple;
	bh=OafbHjk7Md1Omk38+XBRTrEo+IFwKMi+PyDBv2g/sY8=;
	h=Date:To:From:Subject:Message-Id; b=Z0cK9RuZbF9upJ3DghchYdmf0bstdIYHiOWT/K4NnrUoJeTbNaWzvUZnprwuZK+VoAibBwMSTWjJwmESVcAW+L1b5B3jFvIE3hJtsgTXNIWfb3MF7MrUPLVshGPnk2S25SAtAihWDElcWljLYkwobWulBt/ucEaM4RlIrCA3//I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghmnGg4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghmnGg4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F626C2BCB7;
	Mon, 27 Apr 2026 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777296136;
	bh=OafbHjk7Md1Omk38+XBRTrEo+IFwKMi+PyDBv2g/sY8=;
	h=Date:To:From:Subject:From;
	b=ghmnGg4i1S16LIcqYn2Wx/L6NGgsMh4l9wEglho55n82eJdEnooPtCUVaj/eQfYRN
	 C7nzP894oVaW5HrSeO4lwKiEA+KEVrGos18XkgLp2W0IYumfjGac41JuZPjdSGDAoV
	 hbShtEqXJ/qnzHOi4tCq6roo04P+ymbrk5cJ0hpw=
Date: Mon, 27 Apr 2026 06:22:15 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch added to mm-new branch
Message-Id: <20260427132216.7F626C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
Date: Mon Apr 27 06:18:51 AM PDT 2026

s/page_mapped/folio_mapped/, as page_mapped is going away

Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
+++ a/mm/memory-failure.c
@@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
 		cpu_relax();
 		return page_count(p) == 0 &&
 		       !PageLRU(p) &&
-		       !page_mapped(p) &&
+		       !folio_mapped(page_folio(p)) &&
 		       !page_folio(p)->mapping &&
 		       !is_free_buddy_page(p);
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch
proc-rewrite-next_tgid-fix.patch

