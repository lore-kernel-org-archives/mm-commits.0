Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709917C220
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752029756; cv=none; b=IYGtq8x9FjaQCPT7CLqk7MCAtqHidnZw20s7VnEVCUOsoR3mWQ42tSLmmBRyJyo0ZGBlhNhYCiRtWe19lJ8Edw8+Pdhycsqh1FJz89h7WKBlsqHqhKHgSIiPv/bFHzhLY9AbaT6Ejqn/zL/TE6+gtO2fe4aYCR0FhrkjQ5S36io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752029756; c=relaxed/simple;
	bh=0Ty9xi9vHC33EmbxJPYAF6+2FJo8VlcTGKt5FaiqJZE=;
	h=Date:To:From:Subject:Message-Id; b=gONZGOedjCwDwjr0EQpT3zveRDU3aG109UxKMLst/1yugTXjzvLPCgV+uM1ltf2fbPi/PP+dGSX0m1csoVBPbCnSWBbT4v5wDpt961sDAAaAk5f0DBoC7wrj93Sg4uZxOIaNo+AIwBB4vk4sU4o7vew4ywc4WUgZcHWQjQKtaIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ut8lZC5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ut8lZC5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B10C4CEED;
	Wed,  9 Jul 2025 02:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752029756;
	bh=0Ty9xi9vHC33EmbxJPYAF6+2FJo8VlcTGKt5FaiqJZE=;
	h=Date:To:From:Subject:From;
	b=ut8lZC5HRyOXnWZGxGVOlef1PJN7qiCQ48RRUFC27XCZ7RfWgEqnaDHX8B3F02N09
	 smApReawiDurEsmcpjwUo6myAEkAlfX0hqj/3GR6J8wPAuwv9XHjrA2m7eMhBksZj2
	 waBcM/HKPq3gpUlIVVrfNuQTGfJwEffvLjWA6fKk=
Date: Tue, 08 Jul 2025 19:55:55 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,chanho.min@lge.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch added to mm-nonmm-unstable branch
Message-Id: <20250709025556.57B10C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix incorrect argument to sizeof in kmalloc_array call
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: squashfs: fix incorrect argument to sizeof in kmalloc_array call
Date: Tue, 8 Jul 2025 15:26:04 +0100

The sizeof(void *) is the incorrect argument in the kmalloc_array call, it
best to fix this by using sizeof(*cache_folios) instead.

Fortunately the sizes of void* and folio* happen to be the same, so this
has not shown up as a run time issue.

Link: https://lkml.kernel.org/r/20250708142604.1891156-1-colin.i.king@gmail.com
Fixes: 2e227ff5e272 ("squashfs: add optional full compressed block caching")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call
+++ a/fs/squashfs/block.c
@@ -89,7 +89,7 @@ static int squashfs_bio_read_cached(stru
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 	struct folio **cache_folios = kmalloc_array(page_count,
-			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
+			sizeof(*folio), GFP_KERNEL | __GFP_ZERO);
 #endif
 
 	bio_for_each_folio_all(fi, fullbio) {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

squashfs-replace-with-and-end-of-fi-declaration.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch

