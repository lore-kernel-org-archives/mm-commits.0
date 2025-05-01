Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3671E260A
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126716; cv=none; b=sbd5604SQ6hzDMaQ9G0brZThn8MuPsMBkJD/Jl2QHF69q4kVWChsosv1Ya3d2yyMfhlY9a3ghwvtAnJ2uARPstLpfJ3B1PYUoRu51UCLs7f39p/IjKjrJe3ksOO+lUT+0/tKL2CkVlKiBge36gkmG/PESqPzKBcWV3zf/k904mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126716; c=relaxed/simple;
	bh=4TEZXRURHThceyaTmLti3WXx5Eg07P41c/mN++3VyM8=;
	h=Date:To:From:Subject:Message-Id; b=LVcX0yAygDOg7ylgYPfyIhe9QJ2eGPPqSKsAlP/cZqxyDV6yK0Pyy0wUQOnZZxrR4GE/ZFRCWUJKr324W0Vqjerl43q6BLa4NMK40/Q7aJfVycEuzm7Der4q0PQmSewRkMzcT0W6J8VkJFJ9sw71lFwfNucgiDXf94xDwijUjhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZ9mh3EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZ9mh3EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CF8C4CEE3;
	Thu,  1 May 2025 19:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746126715;
	bh=4TEZXRURHThceyaTmLti3WXx5Eg07P41c/mN++3VyM8=;
	h=Date:To:From:Subject:From;
	b=QZ9mh3EYLvuqZNFvlnnMmhBvLJ4qv/Uq/4AHl5lImmiMr9T2vQruqt9PWs3+cYwV2
	 oO3gOxGf2p1DCfWG2XliuiScOvmCHhk+CtLk7+aVfEhXTOyWODatSvs9boTq6jT+K2
	 wR3XRKEORihEA88UAQ8L+PK4/qN57xwrhtHAhNlk=
Date: Thu, 01 May 2025 12:11:55 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-drop-kmemleak_warning-variable.patch added to mm-unstable branch
Message-Id: <20250501191155.C9CF8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: drop kmemleak_warning variable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-drop-kmemleak_warning-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-drop-kmemleak_warning-variable.patch

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: kmemleak: drop kmemleak_warning variable
Date: Wed, 30 Apr 2025 16:59:45 -0400

These are a trivial mm/kmemleak.c cleanups.  I found these while reading
through the code.


This patch (of 3):

The kmemleak_warning variable is not used since commit c5665868183f ("mm:
kmemleak: use the memory pool for early allocations"), drop it.

Link: https://lkml.kernel.org/r/cover.1746046744.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/97e23faa7b67099027a1094c9438da5f72e037af.1746046744.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-drop-kmemleak_warning-variable
+++ a/mm/kmemleak.c
@@ -215,8 +215,6 @@ static int kmemleak_enabled = 1;
 static int kmemleak_free_enabled = 1;
 /* set in the late_initcall if there were no errors */
 static int kmemleak_late_initialized;
-/* set if a kmemleak warning was issued */
-static int kmemleak_warning;
 /* set if a fatal kmemleak error has occurred */
 static int kmemleak_error;
 
@@ -254,7 +252,6 @@ static void kmemleak_disable(void);
 #define kmemleak_warn(x...)	do {		\
 	pr_warn(x);				\
 	dump_stack();				\
-	kmemleak_warning = 1;			\
 } while (0)
 
 /*
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-kmemleak-drop-kmemleak_warning-variable.patch
mm-kmemleak-drop-wrong-comment.patch
mm-kmemleak-mark-variables-as-__read_mostly.patch

