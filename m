Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E31CEE8D
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728592906; cv=none; b=eYvzboP3NCHl8PVWwfELt7Ba0/mXhZXFevIaTQH/H9uEKjRuJyjV2H9vrvr/b6jc3L+nLBzkpawRnsfPJbhRafkfHfs89CfM4bu7mF6MDwIC2SjNRadp6SotLM4H9nwrxESUhFLF3haofyAjd+nAwqzIuSPgJnbbeZxjJfOonek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728592906; c=relaxed/simple;
	bh=rmGh2u0pi6t66/D1rNtbpZJI1z8cELAw8Wq0PibtCXs=;
	h=Date:To:From:Subject:Message-Id; b=YOT638L91tGk3tWhu6FrLymhvQwKJi0bN5EEUztoOzq2NOG5w5sbx2bAzeZkYiS04hv0O+ovKyNtJ2X+5K9nP08+3kJR9xtw7mpRJNo6yZTzQeB31Ak7//kRAe9DufXnysiaUJcf7RCQhGWsNAjg8xygMeZpkmJAMkSNxy8kcnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ug21vDpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ug21vDpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86124C4CEC5;
	Thu, 10 Oct 2024 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728592905;
	bh=rmGh2u0pi6t66/D1rNtbpZJI1z8cELAw8Wq0PibtCXs=;
	h=Date:To:From:Subject:From;
	b=Ug21vDpPvUwNCwxg1U5mUG5sfCZruphtS0AhIrAGxiHFLpl2HmcQLCk6n8hx7JYxd
	 aY73ZIm/udfrO2e3SN3bFUnXmBscTWiY6GPW/NcD1QmcCfPdhGX7IKynaxkhMdG87W
	 O4HHP341L6y7sfmZsafmxtpkgBnhkpVy57KtCKnM=
Date: Thu, 10 Oct 2024 13:41:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kees@ijzerbout.nl,everestkc@everestkc.com.np,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-add-support-for-cache-of-large-rox-pages-fix.patch added to mm-unstable branch
Message-Id: <20241010204145.86124C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: remove logically deadcode in execmem.c
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-add-support-for-cache-of-large-rox-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-add-support-for-cache-of-large-rox-pages-fix.patch

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
From: "Everest K.C." <everestkc@everestkc.com.np>
Subject: mm/execmem: remove logically deadcode in execmem.c
Date: Thu, 10 Oct 2024 12:10:58 -0600

NULL check of variable `area` within the `mas_for_each` loop is
unnecessary, as the varialbe `area` can never be NULL.  So, the `continue`
statement inside the if block is never reached.

Remove the if block that performs the NULL check.

This was reported by Coverity Scan:
https://scan7.scan.coverity.com/#/project-view/51525/11354?selectedIssue=1600362

Link: https://lkml.kernel.org/r/20241010181102.5522-1-everestkc@everestkc.com.np
Fixes: d44c3485820e ("execmem: add support for cache of large ROX pages")
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Cc: Kees Bakker <kees@ijzerbout.nl>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/execmem.c~execmem-add-support-for-cache-of-large-rox-pages-fix
+++ a/mm/execmem.c
@@ -75,9 +75,6 @@ static void execmem_cache_clean(struct w
 	mas_for_each(&mas, area, ULONG_MAX) {
 		size_t size;
 
-		if (!area)
-			continue;
-
 		size = mas_range_len(&mas);
 
 		if (IS_ALIGNED(size, PMD_SIZE) &&
_

Patches currently in -mm which might be from everestkc@everestkc.com.np are

execmem-add-support-for-cache-of-large-rox-pages-fix.patch

