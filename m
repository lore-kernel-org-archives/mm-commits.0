Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BA3A1CD
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 02:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029861; cv=none; b=dZ4s8z8byUkAmt4MgzFDcOXpOv7gsd3aOs4shfSaywfRMyUVm8KwnnrI4hAMd/dxq81jLxuNPwmx+5+YXVTQJkBaCY3hAW9fXVtHKUmyfk35ZIJbvSfQtRrhRg24/9xG877HInLimlv/qwGmVVs4grVmbJEyublUfL+XkQQHulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029861; c=relaxed/simple;
	bh=AoRaOKSAveYYwRIldxZ9PpEKIrxsP8nAXsV8Hk4OvmE=;
	h=Date:To:From:Subject:Message-Id; b=uOXHgmrOlfHLfscfO81d+sjfhrnp7yS527A3XWTHiQpziLZXEpbM5cjmBJct2OvpjTL+xz9g+3lnfUTM0UcN4QvPLVMcP+1uJ3w/QjDqgdi142NAKqKrMaEfn0IvaAm7s3DNc73hlRh1GKnZf32IIiTAf9sgtpDeC0I3NIphMSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YXR/Izvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YXR/Izvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46977C4CED2;
	Tue, 28 Jan 2025 02:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738029860;
	bh=AoRaOKSAveYYwRIldxZ9PpEKIrxsP8nAXsV8Hk4OvmE=;
	h=Date:To:From:Subject:From;
	b=YXR/IzvhynbTYiGkZfbkw9PCdI9k/Yei5vhtTegGWOyz+6WSwk43wqwHPg7x8trY+
	 hoCTPvbzQJZi/uwl0AVQuKiaxfeYQ3KagbM5R9Fk3FYFkxoJqCh4pLGLiPwGW998vN
	 CZN3Af3SqtLsWOimoN9q47eXF2//nD+tNJ2POj80=
Date: Mon, 27 Jan 2025 18:04:19 -0800
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,david@redhat.com,apopple@nvidia.com,aijun.sun@unisoc.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250128020420.46977C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
Date: Wed, 22 Jan 2025 09:26:04 +0800

move definition of local

Link: https://lkml.kernel.org/r/20250122012604.3654667-1-zhaoyang.huang@unisoc.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
+++ a/mm/gup.c
@@ -2324,9 +2324,9 @@ static void collect_longterm_unpinnable_
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	unsigned long i;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
+	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch
mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch

