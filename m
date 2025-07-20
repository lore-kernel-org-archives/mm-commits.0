Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E63A7DA6A
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976926; cv=none; b=eb0+p6FoNwPNZ0BUyZ15/a/AaP0dZmShR62kYaYdz4JaGN2vJgVQqjWvRchJ/m4+vYhbCcqozL+OSmjC8VlJRQUr+55Dk82INahlYe2Lkc5TDcOJ/gIn9vr3R6ESEzZHzTeAlk0PUl9Kr2B5qNFirvAH4/Nz+jYiHKEMCdtrj2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976926; c=relaxed/simple;
	bh=ML1FnbMWBIom2CobhLszZxLVzpInUwsWArtymhTpDy8=;
	h=Date:To:From:Subject:Message-Id; b=SOaS6Go9N4I8ccnMM8KsQF1Zewn/LavvD+z3vdST9NYqZ8/5A3n6zcGDRsRXJQhK+pruzPBv6+oQvZjr+gGYQAoOYWySyiaKzvwj4ZgJ9pF/MGCPHL1feHKPDFaLXmKISsRv3drcxVc9X+OMzqT55/S8l9jcZRPWOOLcJzUbkv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gKLOSc52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gKLOSc52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0251CC4CEF4;
	Sun, 20 Jul 2025 02:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976926;
	bh=ML1FnbMWBIom2CobhLszZxLVzpInUwsWArtymhTpDy8=;
	h=Date:To:From:Subject:From;
	b=gKLOSc52400on8hmERmer26zi4r8wb96BdJBBH+MDbbFYrnrWA3kKm1JRfU/dJI+5
	 GkIM4PLXj7t22A7b3JeO9AY9cUTWruXY/I+GqJthZUwLMGB60D/nrSHj8+eZ8LMAIl
	 HTJ6NPyyWaSvgiV0fumvFh+JThImUD0WcpoDS39o=
Date: Sat, 19 Jul 2025 19:02:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-min_brk-handling-in-brk.patch removed from -mm tree
Message-Id: <20250720020206.0251CC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify min_brk handling in brk()
has been removed from the -mm tree.  Its filename was
     mm-simplify-min_brk-handling-in-brk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: simplify min_brk handling in brk()
Date: Thu, 10 Jul 2025 10:58:58 +0800

Set min_brk to mm->start_brk by default, and override it with mm->end_data
only when CONFIG_COMPAT_BRK is enabled and brk_randomized is false.

This makes the logic clearer with no functional change.

Link: https://lkml.kernel.org/r/20250710025859.926355-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-simplify-min_brk-handling-in-brk
+++ a/mm/mmap.c
@@ -127,18 +127,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 
 	origbrk = mm->brk;
 
+	min_brk = mm->start_brk;
 #ifdef CONFIG_COMPAT_BRK
 	/*
 	 * CONFIG_COMPAT_BRK can still be overridden by setting
 	 * randomize_va_space to 2, which will still cause mm->start_brk
 	 * to be arbitrarily shifted
 	 */
-	if (current->brk_randomized)
-		min_brk = mm->start_brk;
-	else
+	if (!current->brk_randomized)
 		min_brk = mm->end_data;
-#else
-	min_brk = mm->start_brk;
 #endif
 	if (brk < min_brk)
 		goto out;
_

Patches currently in -mm which might be from liuqiye2025@163.com are


