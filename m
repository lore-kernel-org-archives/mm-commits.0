Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5045C33F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660036; cv=none; b=Jkm4pq+7XieABClf5hmdrl2aUbCEgyO0BwZdiizrj7BGJNLfGIXfcBryMwMLEtSb9OhdxEpjphm5XHLMcSe+PVkCVlGoU0rYPiKBytCkGDBsAxIbBBWd8QCx0VYjOVGoejc8Ljp8VsbDTObmpqFTPZGVD2rIfzwiyGETbp6pZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660036; c=relaxed/simple;
	bh=cEQzA6n56Y1FCVeTWWbmqYiUjAemqV/hF01Uuqnk7hk=;
	h=Date:To:From:Subject:Message-Id; b=LG9mFHMITT8NiloVM6XwQu6QIGptV3jkHJvlW4/iGsN0UEM6OTtElI8MyvQ+yjEAGccaUq4/0uJrntZGz5iAQa0G3GRp+iQVndp7u/BlH2y8572uP6U+DTdFid+75kcBa6Vs+3kny+MzcsI1jx3CuwIlARH7aE/MZ4bEsfb+nhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9a6t8PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9a6t8PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12340C4CEE0;
	Sun, 12 Jan 2025 05:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660036;
	bh=cEQzA6n56Y1FCVeTWWbmqYiUjAemqV/hF01Uuqnk7hk=;
	h=Date:To:From:Subject:From;
	b=M9a6t8PZsQT8Uqa1fzY7CHym75M/hwYqNN6lc9AftDhd71LAbEN271eOa+hswO7Vs
	 9DMfNC/jUkAvBT3KuRG0dj+I8y3M6LZwrF4Qu22AuRc9+MW1T4EgxCuTDU3an5QT08
	 I8TpX+wKWHJYY/RAVPkIPhdXvZWIwZg7tnqBCdBo=
Date: Sat, 11 Jan 2025 21:33:55 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + latencytop-use-correct-kernel-doc-format-for-func-params.patch added to mm-nonmm-unstable branch
Message-Id: <20250112053356.12340C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: latencytop: use correct kernel-doc format for func params
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     latencytop-use-correct-kernel-doc-format-for-func-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/latencytop-use-correct-kernel-doc-format-for-func-params.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: latencytop: use correct kernel-doc format for func params
Date: Fri, 10 Jan 2025 22:30:19 -0800

Use a ':' instead of a '-' after function parameters to eliminate
kernel-doc warnings.

kernel/latencytop.c:177: warning: Function parameter or struct member 'tsk' not described in '__account_scheduler_latency'
../kernel/latencytop.c:177: warning: Function parameter or struct member 'usecs' not described in '__account_scheduler_latency'
../kernel/latencytop.c:177: warning: Function parameter or struct member 'inter' not described in '__account_scheduler_latency'

Link: https://lkml.kernel.org/r/20250111063019.910730-1-rdunlap@infradead.org
Fixes: ad0b0fd554df ("sched, latencytop: incorporate review feedback from Andrew Morton")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/latencytop.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/latencytop.c~latencytop-use-correct-kernel-doc-format-for-func-params
+++ a/kernel/latencytop.c
@@ -158,9 +158,9 @@ account_global_scheduler_latency(struct
 
 /**
  * __account_scheduler_latency - record an occurred latency
- * @tsk - the task struct of the task hitting the latency
- * @usecs - the duration of the latency in microseconds
- * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
+ * @tsk: the task struct of the task hitting the latency
+ * @usecs: the duration of the latency in microseconds
+ * @inter: 1 if the sleep was interruptible, 0 if uninterruptible
  *
  * This function is the main entry point for recording latency entries
  * as called by the scheduler.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch

