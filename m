Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C32262FED
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763484391; cv=none; b=XlrdUqBadD1KY3tTbMYLplWgGUy9u7JZ4gX23wyTXSz0V2G/dOH69clPy9rOFnij47VaE/3dyIbH6yIiKcbguYw+j3XtM9JJDLtucyE9Q2O1RENdsK4Af3cP6dfV5vfB87dJos6pulXrUK026/nBF0mFb4Y20FBheWpnc0xLVSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763484391; c=relaxed/simple;
	bh=WNW0c/XptHm5KZY4VXfPGmHY9iRt1H8ZmuSm/j2iE9Q=;
	h=Date:To:From:Subject:Message-Id; b=ueKfaZwp3wFP4eCLcFsvKXFLoK5P+KnkEaifnlMM3J/ViXmUaigHrgxcMIFXwjj918Yk4VhzRwrQ0b3wEKD7Zo3eo1TA/PyayDm9QKyuVSQAX2KQCsoIv4XBjNsEHbtNfOR7qFH3WRrWdZmSbhY47EOenR7U6o8XMsf6y1QpF6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WES90ZI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WES90ZI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC2DC116B1;
	Tue, 18 Nov 2025 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763484390;
	bh=WNW0c/XptHm5KZY4VXfPGmHY9iRt1H8ZmuSm/j2iE9Q=;
	h=Date:To:From:Subject:From;
	b=WES90ZI3X+AJvgu6gFdYJJVGpKQUCbb5m822AMkVXgy0EjHWODgTqQhYYgH076hGD
	 ziN9XInSQWzNyv9XFty2Kw89aRGWr7imKt856zE4Y+wTlfdmuEl70LQJ01DvNcxBoa
	 DGEeVQJKbRutfuW2Y/MYhMCuJPhrOEmNzt9gAYP4=
Date: Tue, 18 Nov 2025 08:46:28 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,david@ixit.cz,peng8420.li@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags-fix.patch added to mm-new branch
Message-Id: <20251118164630.6CC2DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: fix build error
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags-fix.patch

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
From: Peng Li <peng8420.li@gmail.com>
Subject: mm/vmalloc: fix build error
Date: Tue, 18 Nov 2025 23:50:34 +0800

commit 056b93566a35 ("mm/vmalloc: warn only once when vmalloc
detect invalid gfp flags") modify the function call from WARN to WARN_ONCE.

WARN_ONCE input parameter format error, missing ',' tag.
Resulting in the following compilation errors:

mm/vmalloc.c:3940:19: error: expected `)' before `invalid_mask'
 3940 |                   invalid_mask, &invalid_mask, flags, &flags);

After adding the "," tag, the compilation passed.

Link: https://lkml.kernel.org/r/20251118155034.273696-1-peng8420.li@gmail.com
Signed-off-by: Peng Li <peng8420.li@gmail.com>
Cc: David Heidelberg <david@ixit.cz>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags-fix
+++ a/mm/vmalloc.c
@@ -3936,7 +3936,7 @@ static gfp_t vmalloc_fix_flags(gfp_t fla
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
 		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }
_

Patches currently in -mm which might be from peng8420.li@gmail.com are

selftests-mm-gup_test-stop-testing-foll_touch.patch
selftests-mm-gup_test-fix-comment-regarding-origin-of-foll_write.patch
mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags-fix.patch

