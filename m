Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD462E62BB
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715691; cv=none; b=isFeI4YQSzauMP3fxFGQP3VlMS/fNOcG6+IlSzXzl3nbObvkANRjVKwcFvtM7MeWOCTWuhXwOUUmyTaryxAVan+/kKg7HWABx81X7tcgD75eincEzjin+Zqixq3FjK6YO/EZhi9Ye8qhaCc8Pn7TUcqk1x/sqlTG6TBwlKIcPtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715691; c=relaxed/simple;
	bh=rlKvxUBdPPxyXhEcBYB9KczMR4TBvd4kcd04/klcNp0=;
	h=Date:To:From:Subject:Message-Id; b=P9B1jNPSCykD374wcQxDfmU4yWri+b2ImbJJ8fK9jqZH+E37ZAIzk+05b1q93wlZwUq7F3LCAX8EkPBetpBPSHRArRZGuXtvYvHkKP8FBqp88QOdGpRuS58ZewLVcwaQ7iBGTUVze3uQw7X6FHabtCaFhKjBJOSamzVP9fJMd+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CMsQEuOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CMsQEuOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7511C4CEE3;
	Thu,  3 Apr 2025 21:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715689;
	bh=rlKvxUBdPPxyXhEcBYB9KczMR4TBvd4kcd04/klcNp0=;
	h=Date:To:From:Subject:From;
	b=CMsQEuOUBBKYm6CfiUVFjP5clPbUfdNYGc88TJpkDlL6+X66OZDVt290Q+TBTXyWd
	 B8//dHLnnrQ690oOj/wB6x1zSQZJcFIGxfDKWoC3ICQFGlerFr5jAB5yYaWetP61WZ
	 LNpDNBUPsfshMaADYalyLpsKXktF/FCk3sGZe4i8=
Date: Thu, 03 Apr 2025 14:28:09 -0700
To: mm-commits@vger.kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch added to mm-nonmm-unstable branch
Message-Id: <20250403212809.C7511C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: task_stack.h: remove obsolete __HAVE_ARCH_KSTACK_END check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: task_stack.h: remove obsolete __HAVE_ARCH_KSTACK_END check
Date: Thu, 03 Apr 2025 14:33:03 +0200

Remove __HAVE_ARCH_KSTACK_END as it has been obsolete since removal of
metag architecture in v4.17.

Link: https://lkml.kernel.org/r/20250403-kstack-end-v1-1-7798e71f34d1@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-2-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task_stack.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/sched/task_stack.h~task_stackh-remove-obsolete-__have_arch_kstack_end-check
+++ a/include/linux/sched/task_stack.h
@@ -106,7 +106,6 @@ static inline unsigned long stack_not_us
 #endif
 extern void set_task_stack_end_magic(struct task_struct *tsk);
 
-#ifndef __HAVE_ARCH_KSTACK_END
 static inline int kstack_end(void *addr)
 {
 	/* Reliable end of stack detection:
@@ -114,6 +113,5 @@ static inline int kstack_end(void *addr)
 	 */
 	return !(((unsigned long)addr+sizeof(void*)-1) & (THREAD_SIZE-sizeof(void*)));
 }
-#endif
 
 #endif /* _LINUX_SCHED_TASK_STACK_H */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch

