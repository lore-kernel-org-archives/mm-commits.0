Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262822F17B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654226; cv=none; b=VzulP4ho69W55JTs5w/GWQ6LfDcG0B/DXZSZstP/Qm9N9c2sVzuE4pvoqINe11zFQJTYjKxW2yuClnj8ilIT8Abdn//lE40TNDFQ/4An58eZHHTDRe3l2Z3Ew1lHFJhZfTWNU8ooz3yOMUB0xb7M+KCfZG4Bng5EhRrUdAmoGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654226; c=relaxed/simple;
	bh=zRc1UOHST/MFsJE8Py9IMxq4An6bXG365wu0zqBMC84=;
	h=Date:To:From:Subject:Message-Id; b=Nx2nf9BiaM+UHUJeeUktyS8fim8OEZzeh2E/pUdpNcEm0ymPz/jahKI/HaYqg4C0yU9C+QNgkR/jge3dIEYTEiQ7R36lz7/vNEYTYQ2zNUlA4ZaDKimurTSHjHEkonrOQmTzM3SbqX8x4cbg2X+ZROhwPmtPX16nSRprNg2FkdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OS8G4Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OS8G4Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF4DC4CEE2;
	Wed,  7 May 2025 21:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654226;
	bh=zRc1UOHST/MFsJE8Py9IMxq4An6bXG365wu0zqBMC84=;
	h=Date:To:From:Subject:From;
	b=0OS8G4Cysui/8mQevFe3xEDSVVLmxXYpGymXHX5kG9wZdWkuXjxeVZxJe6eCN9Sfs
	 nYgDk6SNH2z1PuvecTceTlDetjgCLq4hyIPTFo7dKvU2NhD6qsc7eKKozc5fRuJ2vV
	 nqFz9NtnVn1w/UDa2978jc1mvv3GGYhggxDJ6jPY=
Date: Wed, 07 May 2025 14:43:45 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-drop-the-declaration-of-kmsan_save_stack.patch added to mm-new branch
Message-Id: <20250507214346.9EF4DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: drop the declaration of kmsan_save_stack()
has been added to the -mm mm-new branch.  Its filename is
     kmsan-drop-the-declaration-of-kmsan_save_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-drop-the-declaration-of-kmsan_save_stack.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: drop the declaration of kmsan_save_stack()
Date: Wed, 7 May 2025 18:00:10 +0200

This function is not defined anywhere.

Link: https://lkml.kernel.org/r/20250507160012.3311104-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/kmsan/kmsan.h~kmsan-drop-the-declaration-of-kmsan_save_stack
+++ a/mm/kmsan/kmsan.h
@@ -121,7 +121,6 @@ static __always_inline void kmsan_leave_
 	KMSAN_WARN_ON(--ctx->kmsan_in_runtime);
 }
 
-depot_stack_handle_t kmsan_save_stack(void);
 depot_stack_handle_t kmsan_save_stack_with_flags(gfp_t flags,
 						 unsigned int extra_bits);
 
_

Patches currently in -mm which might be from glider@google.com are

kmsan-apply-clang-format-to-files-mm-kmsan.patch
kmsan-fix-usage-of-kmsan_enter_runtime-in-kmsan_vmap_pages_range_noflush.patch
kmsan-drop-the-declaration-of-kmsan_save_stack.patch
kmsan-enter-the-runtime-around-kmsan_internal_memmove_metadata-call.patch
kmsan-rework-kmsan_in_runtime-handling-in-kmsan_report.patch

