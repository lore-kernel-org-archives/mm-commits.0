Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C742BB13
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188405; cv=none; b=Q9ef2G9/wQ/EMZU08SWoHrEFv1LFlLr2vic3xB4nmWSYWQGy1/5aqucxeIa2Hl2x4cls/MNR/lsSOd3qtqCImTGShVG3YFuLdtO87gIdsHGWpoqfd6B5vkEc3UCjBxaD2aZPkNHsYRi1zF69qHH0Ci4OQ3uopOKyJ9FHjbkNABU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188405; c=relaxed/simple;
	bh=ev1RNojrzKphGQYlfUJnSQHMmk3olBNi42NneKSm6Ms=;
	h=Date:To:From:Subject:Message-Id; b=DJYQaIkz2lS8e215oux49d1pPGlBhsvYw1WUfDE7CDP3YP42xlm7s8TtAp4i6ce0rrQYEpNZ74+p0pYCrY/O90sckkJJ6XyjG0sKLjtc+VWANBUg5dX99EBxDSIn0Mprv6xg4HQMGta5U9mnjgYMoPbovUjKw9Wm0GRPW1bgm9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOahLL6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOahLL6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEB5C4CEEC;
	Mon, 17 Mar 2025 05:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188405;
	bh=ev1RNojrzKphGQYlfUJnSQHMmk3olBNi42NneKSm6Ms=;
	h=Date:To:From:Subject:From;
	b=UOahLL6ZTgMLAovQ1HSlCWYtbxJnywD7T7RB2Jl2w0XKlxeUypPcqw8dM1ecenkSH
	 jDMJ2ThwY0ZoRjUewbgjnmlUR0Zv0biBZqWI/Ej68Knxt6kFm62iZG39U3uguDfjwG
	 AqRfFZeHUXcsIeM76CIdP3jG+pj56CKd0kI1ifW8=
Date: Sun, 16 Mar 2025 22:13:24 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-pgtable-remove-duplicate-included-header-file.patch removed from -mm tree
Message-Id: <20250317051324.DEEB5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm/pgtable: remove duplicate included header file
has been removed from the -mm tree.  Its filename was
     arm-pgtable-remove-duplicate-included-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

watchdog-perf-optimize-bytes-copied-and-remove-manual-nul-termination.patch

