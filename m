Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54DD257424
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 21:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000148; cv=none; b=DfUbW1bzZI58vnHiRgsXbRHBNSy/NBt8ezxZG6RfEUGkcHns1DC5EOtRN3wGantct/bPD0KnDfUlJg+VqrWpOjy3IaoOqCOrMuNbBemKE79mC09k5fWE31Yh2o7Y5zF2fNfy6cGMuxV2mMXIy5NkVgHCP968MRUCTkNMuFJwbbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000148; c=relaxed/simple;
	bh=D4H+gnhZX1cEvk1nsvXg8srC0BhnwAKkuMUO7HeFE78=;
	h=Date:To:From:Subject:Message-Id; b=RPuN05w01LynrY5y3sHqi6cwxjExGyzluc3k4pVpmk+SxWDHuCfvYvQ1k38S9Y+bX4AKk+t25jzrpmkTvCreUS9dRqcpNj7wKsoNQP91w5nVrdqwFNKO8oD4uPzUG3NwRJn9rmfTk2vozfYp9B01B523dBdKcoSZmG9vMzGiRzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSG4WmD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSG4WmD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0680BC4CED1;
	Wed, 19 Feb 2025 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740000148;
	bh=D4H+gnhZX1cEvk1nsvXg8srC0BhnwAKkuMUO7HeFE78=;
	h=Date:To:From:Subject:From;
	b=tSG4WmD4LvRZwZVs4NlsHGfh9kxVEJUsEEaZ1RT6W7OZDr6dYDkK4tFbBLrCLo4Hv
	 trSpkjqg1XISz1wu6SCgAqG4UeIcVOCv7qPGITT/XHJSF2LrzxBY9pWo8J5oyPM3jK
	 QtqIopeRXrbxtQEtuWiUJIexGtx/5Bc9N7IZ/MUM=
Date: Wed, 19 Feb 2025 13:22:31 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-pgtable-remove-duplicate-included-header-file.patch added to mm-unstable branch
Message-Id: <20250219212228.0680BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm/pgtable: remove duplicate included header file
has been added to the -mm mm-unstable branch.  Its filename is
     arm-pgtable-remove-duplicate-included-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-pgtable-remove-duplicate-included-header-file.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: arm/pgtable: remove duplicate included header file
Date: Wed, 19 Feb 2025 12:24:02 +0100

The header file asm-generic/pgtable-nopud.h is included whether CONFIG_MMU
is defined or not.

Include it only once before the #ifndef/#else/#endif preprocessor
directives and remove the following make includecheck warning:

  asm-generic/pgtable-nopud.h is included more than once

Link: https://lkml.kernel.org/r/20250219112403.3959-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/pgtable.h~arm-pgtable-remove-duplicate-included-header-file
+++ a/arch/arm/include/asm/pgtable.h
@@ -19,14 +19,13 @@ extern struct page *empty_zero_page;
 #define ZERO_PAGE(vaddr)	(empty_zero_page)
 #endif
 
-#ifndef CONFIG_MMU
-
 #include <asm-generic/pgtable-nopud.h>
+
+#ifndef CONFIG_MMU
 #include <asm/pgtable-nommu.h>
 
 #else
 
-#include <asm-generic/pgtable-nopud.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

arm-pgtable-remove-duplicate-included-header-file.patch

