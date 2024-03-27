Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D463314388B
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 21:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711574600; cv=none; b=QVKL1lo5iB7SvhMZ09YlT+zK9h75DIoZ1No7ssrclMmilTqpqz1zV3z5E89PV/rzCk5evQThS+xsFgjZgiLZ2mfyq1QHPaQ5UM0PZXWlE/dYtwlu+KbFtwiuzuY8bCFsoC4Y8R5jCST2Jcz023Qr5RVBk67Jw6hc6apUaekSGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711574600; c=relaxed/simple;
	bh=DY30cwFGJ8pdKuG6WJV4CUG8AKzJP7FQ/FVvyEVo0C4=;
	h=Date:To:From:Subject:Message-Id; b=WquFgjm2Q36VUzsWgoPKxFkRuLMH9k/lOFuG9ide5CAVtTerpXl7Z/WXAy1taRRreIzed02RC2VPfk4mY483Yg5krjqrhnjawO17i1XLtuLXQ9XTewa/sXwVNwWnJUOtZ8yrrmOW/xi7opiTuZ1pmvVqOT5RJ/LDhbG+G4Sxd+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btBaY6sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btBaY6sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569B5C433C7;
	Wed, 27 Mar 2024 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711574599;
	bh=DY30cwFGJ8pdKuG6WJV4CUG8AKzJP7FQ/FVvyEVo0C4=;
	h=Date:To:From:Subject:From;
	b=btBaY6shbzpG0y7BhVkeQkDYJ4tR5r6CPpHoG/VhHKHjV6SQabDV5K/XWyLSBdV8o
	 NK2lbifoHS/z7CWKNn5gkC69YMktgoDBWDIhWql1I7dNQYQ2Y3y7KqxQ4pFPKQkqv8
	 1hC9WjbXRUzV2lYCcrrEKi4YU2gQrWs52Bsvg55Y=
Date: Wed, 27 Mar 2024 14:23:17 -0700
To: mm-commits@vger.kernel.org,samuel.holland@sifive.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240327212319.569B5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm-amd-display-use-arch_has_kernel_fpu_support-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drm-amd-display-use-arch_has_kernel_fpu_support-fix
Date: Wed Mar 27 02:11:18 PM PDT 2024

fix x86_64 allmodconfig build

Cc: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c~drm-amd-display-use-arch_has_kernel_fpu_support-fix
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/dc_fpu.c
@@ -78,10 +78,8 @@ void dc_fpu_begin(const char *function_n
 	WARN_ON_ONCE(!in_task());
 	preempt_disable();
 	depth = __this_cpu_inc_return(fpu_recursion_depth);
-	if (depth == 1) {
-		BUG_ON(!kernel_fpu_available());
+	if (depth == 1)
 		kernel_fpu_begin();
-	}
 
 	TRACE_DCN_FPU(true, function_name, line, depth);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch
drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch

