Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E3C205E25
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875660; cv=none; b=VeOJiuTAKMRIHnZsFXtL69efAZl8vGVxD++mBQ//zwcdXcdmfmMfh/KO6rgBe/TKaByhwdr81UQpmqA07vhgia03i+pzRoX0gAQwsMs9nyn7mkOTLdf4UNC5tJQBIIqwqQYpV1CCleXQrP4TXd+Ai2eRPOHfx0tEGKzkY+/HBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875660; c=relaxed/simple;
	bh=X2lz07ydM4g9+7ohp4kJc1vJUjiV6Lq0Oftyak4tJ3w=;
	h=Date:To:From:Subject:Message-Id; b=g/ZJ+tet5uNHo7stcfA1/e6KpTKcfp53hOJrXwiQJ/v4/JqExgmgpt6SixKHrpvr7/Qud2X+UJN+zFt0v7p/rMQbQvHuSGAkZt00nT3W4oYvdurSmqffuFJ0sl7m5lC5usLDydaNSSY8EkNrGQpvMjTpwbtYWfyrvSRvaUaPIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ztc8/abE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ztc8/abE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8E6C4CEF1;
	Tue,  7 Oct 2025 22:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759875660;
	bh=X2lz07ydM4g9+7ohp4kJc1vJUjiV6Lq0Oftyak4tJ3w=;
	h=Date:To:From:Subject:From;
	b=ztc8/abEFjJRzG7lyjv6hF9buJqZjLAYtG1Js68vyXNyENHiFontRKHHf807OtaRS
	 1pfL8G3pDTZ6NlwwSlQGFaC4sfQs/A75+3g1+rvuEtJ8gQfqECIlCjhcZ4wXixHb9v
	 YAQXuqRbbSo40jIr2rtW/zU1+SrfmmvEcrbKoNT4=
Date: Tue, 07 Oct 2025 15:20:59 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cleanup-swap-entry-allocation-parameter-fix.patch added to mm-new branch
Message-Id: <20251007222100.4F8E6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-cleanup-swap-entry-allocation-parameter-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-cleanup-swap-entry-allocation-parameter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cleanup-swap-entry-allocation-parameter-fix.patch

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-cleanup-swap-entry-allocation-parameter-fix
Date: Tue, 7 Oct 2025 04:07:44 +0800

update folio_alloc_swap() kerneldoc

Link: https://lkml.kernel.org/r/CAMgjq7DGy_ZmPqcqUO6s5BN381Zuee_g3KWjVqM3amLhpwE=2g@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-allocation-parameter-fix
+++ a/mm/swapfile.c
@@ -1417,7 +1417,6 @@ static bool swap_sync_discard(void)
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
- * @gfp: gfp mask for shadow nodes
  *
  * Allocate swap space for the folio and add the folio to the
  * swap cache.
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-cleanup-swap-entry-allocation-parameter-fix.patch

