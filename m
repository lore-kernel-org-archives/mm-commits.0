Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D281A29
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 22:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720476270; cv=none; b=ZBEhfv7dsPNt9tEXkjEksuqV1R2qCPtBa9CYstAO8OvoTJy+dc4vuMWUFu8XYx7HNbWjFtYCTZ8bB8tO0sWXgz8OHGhwLcG11gmP6PFCGpqEju5Blou64rVXEDYb58gPeZCQP3zZ0QiQByjawbECqhjBXh46sG2nJCfjGsqcEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720476270; c=relaxed/simple;
	bh=TpeRdCFykXJcR2LpEFhYoa2Z1p5/zRsZvmNAvqM3aOQ=;
	h=Date:To:From:Subject:Message-Id; b=FUGii3eUTLWKAchKAWxtvt7ETZ0/vmhc+4e745wsIbOI9UWehGnaBIu1FrgwFClysQqa9GH1IyRL6Hl4A3UCfL7tX3xd32fj56CXr5VTly5OxV+UEiEa/QKY4m5LjXIZyVe2IaUvsVJXEeQQPD86yRN/7A5ma2ZxM1ruQHgWoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efzhV3Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efzhV3Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029DC116B1;
	Mon,  8 Jul 2024 22:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720476270;
	bh=TpeRdCFykXJcR2LpEFhYoa2Z1p5/zRsZvmNAvqM3aOQ=;
	h=Date:To:From:Subject:From;
	b=efzhV3Om4Woib3v70y/OAbCYdPrwTyMZfrOdN6Y4I3DRqaltMuNKEhXDWdK2uEk6I
	 FPxP6VWXRo7+3KVUgm21eLqjMkF7LsR7LT/KbhArIKSlyAmgsK5aGXPcp4RCOkBbPi
	 aPVo6Zl0YaZ5L3XYmi7BAfydvr/eRm0UXh25GIec=
Date: Mon, 08 Jul 2024 15:04:29 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,masahiroy@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-remove-unused-__meminit-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240708220430.1029DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: remove unused __MEMINIT* macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-remove-unused-__meminit-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-remove-unused-__meminit-macros.patch

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
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init: remove unused __MEMINIT* macros
Date: Sun, 7 Jul 2024 01:05:05 +0900

These macros are not used anywhere.

Link: https://lkml.kernel.org/r/20240706160511.2331061-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/init.h~init-remove-unused-__meminit-macros
+++ a/include/linux/init.h
@@ -99,10 +99,6 @@
 #define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
-#define __MEMINIT        .section	".meminit.text", "ax"
-#define __MEMINITDATA    .section	".meminit.data", "aw"
-#define __MEMINITRODATA  .section	".meminit.rodata", "a"
-
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
_

Patches currently in -mm which might be from masahiroy@kernel.org are

init-remove-unused-__meminit-macros.patch
init-modpost-conditionally-check-section-mismatch-to-__meminit.patch

