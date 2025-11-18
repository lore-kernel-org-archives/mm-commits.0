Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C42726FD9D
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 00:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425610; cv=none; b=aWyTZlZaS6VFtpyDgLvzzEAnQLUC+XiqE+G0VTyJy4QzT6YBkWjx0ifPd83nG7KlBYe3r4n8LHknCG+IWkj9fJsIeVw98T7Br0hYg2xmtrpCAoOqek1+1zUIMTN+vdlQT3GrNquB3Yz0ssyfpM2B7rl+21OibhC9+6Y1FC0nFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425610; c=relaxed/simple;
	bh=UCUvtdKrp+ORiPvjkvYBMtEfN7n4uD5/toEMgB6Ws6o=;
	h=Date:To:From:Subject:Message-Id; b=B4leJgVvlzJxTVCNJpgejEcGhtleEOZvghMDxba+ji05ZmpaDZ0lQGeFlqoWRt6GnoZAI8spOO7tleD5+Yib2GOKFOJeWou9c2dzhBk4IeGgnCB2bkIxxkMyzpGKy1on0RUxr5ubDu18A9t86Be5yPdsJJK0jXJ2sq0quQLRttg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJEZkTC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJEZkTC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756F2C19425;
	Tue, 18 Nov 2025 00:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763425609;
	bh=UCUvtdKrp+ORiPvjkvYBMtEfN7n4uD5/toEMgB6Ws6o=;
	h=Date:To:From:Subject:From;
	b=lJEZkTC7pQTtgBxiN+0NC3sLY8MQLd3GlWvKswkvyBN2Q+d91hg76zs1SYgPa+jDW
	 5AXv7B1FgdwqR5O0VTyIwXxUputSwViP4hUrIqwsA6nMv3Jdof16VLjE78TDsfhB+M
	 0t5wvx7QULPJ7XTU/qdVdB6u4Anm/zJeR+n/5Psw=
Date: Mon, 17 Nov 2025 16:26:48 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,david@ixit.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags.patch added to mm-new branch
Message-Id: <20251118002649.756F2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags.patch

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
From: David Heidelberg <david@ixit.cz>
Subject: mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
Date: Tue, 18 Nov 2025 01:05:57 +0100

Without WARN_ONCE, the logs get spammed immediately after the boot, on
devices as OnePlus 6T (Snapdragon 845).

Link: https://lkml.kernel.org/r/20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz
Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Signed-off-by: David Heidelberg <david@ixit.cz>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags
+++ a/mm/vmalloc.c
@@ -3936,8 +3936,8 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-			invalid_mask, &invalid_mask, flags, &flags);
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
+		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }
 
_

Patches currently in -mm which might be from david@ixit.cz are

mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags.patch

