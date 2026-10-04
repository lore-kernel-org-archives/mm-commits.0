Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B87347F3A0
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138597; cv=none; b=NAGDyxIHAjTFqG9OaW52mccdY+gaBR5R5gou0ms21h1cCEZLwem0gzMD9R4XllyBz4D9IT6TDQtnJxn7TGuN/S0QlBtSiEdj1hTjsQ8AYH9A+GPsbeppbszvbvjVBNwcs0DXzn5MzTjCR9vL4T9KLEjp/szyPa5g5NhiS9EPsyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138597; c=relaxed/simple;
	bh=mj4NLHxMecxfoGti3kz9ixvdspO+3asqjGbCdZyn2es=;
	h=Date:To:From:Subject:Message-Id; b=XuwpsJT3dA3wnWOSbOkJCpjP0cs1yaG9pgyAxWY2bW7ijpV56I/ot9z3uLKME+qf4UnbTDbJyrsrBQyArnB0s4+OoXpc0gVgpl200d8bzgJVQMqzYMAcWKcWp2lC7fuk4O2zq2+XDUm9MRfnj0zOFyFSenWVZD16OLb25qLvQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKPPgqNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKPPgqNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105BD1F000FF;
	Sun,  4 Oct 2026 18:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791138596;
	bh=gJ6awC53aI3ri9L7MS74sxpCdha6eMUAvqmDhB3O6wU=;
	h=Date:To:From:Subject;
	b=VKPPgqNhEIsr5T66Lj3ZgogSVZglNeCVEjIF0zJCPIkCRE1g5znFnFxn2FCyJ9cf1
	 trZ2ZVm+8WN7b/jdIapDTh7YalzD4lnyc5peOVGCy/d+ETYf+VYljX722T7/yQp7N8
	 LhvgyZlfvRYvecejwhh3Iyhc9AUgNfqnWFryCz84=
Date: Sun, 04 Oct 2026 11:29:55 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,dev.jain@arm.com,baohua@kernel.org,jiangwen6@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch added to mm-new branch
Message-Id: <20261004182956.105BD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch

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
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
Date: Sun,  4 Oct 2026 15:16:39 +0800

__vmap_pages_range_noflush() currently only warns when page_shift is
smaller than PAGE_SHIFT, then continues with the invalid shift.  Return
-EINVAL instead so the bogus argument is caught immediately.

Link: https://lore.kernel.org/20261004071639.119857-1-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush
+++ a/mm/vmalloc.c
@@ -684,7 +684,8 @@ int __vmap_pages_range_noflush(unsigned
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
 
-	WARN_ON(page_shift < PAGE_SHIFT);
+	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
+		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

mm-vmalloc-bail-out-early-on-invalid-page_shift-in-__vmap_pages_range_noflush.patch

