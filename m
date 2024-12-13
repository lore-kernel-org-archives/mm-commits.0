Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD29416D4E6
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062712; cv=none; b=ivzUt/wMoeSjrs0QZApJQb1zrfxrBnSLdz0Sp4YM3sC2PJoiUN6rs+mK6pd/ghxsBvfaoCXKfPuFnXykF+CBBEy1zXiwf/CbF+thRMjtdhv3SH/7mlzExGz52r43hiHXOGR23d5OooRuMuwUZT04XXMoP39NR1QzFcWZ8Ym02+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062712; c=relaxed/simple;
	bh=CrweHXHkr3uHyvX3vSucNNm0t4zm5LUsyOIL3dwjlk8=;
	h=Date:To:From:Subject:Message-Id; b=lBdu0nPFeAiyUXQEJ/17cThOccRU1PJ5lidzqhWjx/O7if8u3SA6e9RmUtf1hWIk/aBJ42rhXkymCInNJ4uaoJQZn0IdWy/7R09pHNrzElzqdhieIi3+Y1i9OtSYz1n1P2wi7NIp4xmaUuv1Nq+L4zN0bTsCZirXMknpZshUzf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4bx8lze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4bx8lze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE34C4CED2;
	Fri, 13 Dec 2024 04:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062712;
	bh=CrweHXHkr3uHyvX3vSucNNm0t4zm5LUsyOIL3dwjlk8=;
	h=Date:To:From:Subject:From;
	b=V4bx8lzedjUFIqdSnmiJ+UswotCJT5qP/chPsB+ZhtprLVVyEiWvi5fND5B0BBLov
	 auJQQd+/uEADUbvbuU/g/8u7yrYKG+/08I88BS6atUq6liSCTKksDULR0pmxeROdsc
	 VeNnHuLcFhWghmZEIWAb/DqSBisUqUldEURgyago=
Date: Thu, 12 Dec 2024 20:05:11 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unexport-apply_to_existing_page_range.patch added to mm-unstable branch
Message-Id: <20241213040512.2BE34C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: unexport apply_to_existing_page_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-unexport-apply_to_existing_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unexport-apply_to_existing_page_range.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport apply_to_existing_page_range
Date: Thu, 12 Dec 2024 08:34:23 +0100

apply_to_existing_page_range() is only used by non-modular code.

Link: https://lkml.kernel.org/r/20241212073423.1439954-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-apply_to_existing_page_range
+++ a/mm/memory.c
@@ -3082,7 +3082,6 @@ int apply_to_existing_page_range(struct
 {
 	return __apply_to_page_range(mm, addr, size, fn, data, false);
 }
-EXPORT_SYMBOL_GPL(apply_to_existing_page_range);
 
 /*
  * handle_pte_fault chooses page fault handler according to an entry which was
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-apply_to_existing_page_range.patch

