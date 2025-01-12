Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5033F7
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660062; cv=none; b=OYh+ths4+dND6jBWzcBzTOJil1WCQ4+mw+ldGNmxve6VxZhH53VwRLxEMkiY6taUX+1kQXxAMkaSPUqe3Hx/ggZ4fIgcNze/xLDF8+j5gF16HBQc2QgAZjXQvLejrjj2gyfRp6J2krI7hwWA0gTgD0Qv31lgqaEmY3JgHE5AWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660062; c=relaxed/simple;
	bh=FdfjpcZwSbpHOCx1XpT+xP7vxSG0faQ1udcHLttef18=;
	h=Date:To:From:Subject:Message-Id; b=dk6KNYMQkuJvZ+zuhTzX9TVgVWawDeV6Wg4m/MsAw7sAsDJMKa7cFX4nuH3Q5AJ5IrEoolEZQplMB1/d46IL/f/TGKMPA2SnrmYtCUp7mQM9yModlN8PvGeIijOzeeemR5/7Gtmy2sOlPsq+25Zo1okW6R6VBNmcPl7B3FzJBm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xg1sa40W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xg1sa40W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B150C4CEE0;
	Sun, 12 Jan 2025 05:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660061;
	bh=FdfjpcZwSbpHOCx1XpT+xP7vxSG0faQ1udcHLttef18=;
	h=Date:To:From:Subject:From;
	b=xg1sa40WYOpE875WHmrQt2Ejrv4fnxbGtj2vDDqR9iPcClQBw+J5wfwMJhShmtgAs
	 3wVwV55Yn3gIUHkmost0XvhMwSmMgtk9HmMtMBUy5xfRuwZnRhCiYlu8iQ9iL4AXMh
	 q7/oxtxNrlZcjEeP1sf+RsQ6omGvOY3nJEMOhdaU=
Date: Sat, 11 Jan 2025 21:34:21 -0800
To: mm-commits@vger.kernel.org,frederic@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-modify-kernel-doc-function-name-to-match-code.patch added to mm-nonmm-unstable branch
Message-Id: <20250112053421.8B150C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kthread: modify kernel-doc function name to match code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-modify-kernel-doc-function-name-to-match-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-modify-kernel-doc-function-name-to-match-code.patch

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
Subject: kthread: modify kernel-doc function name to match code
Date: Fri, 10 Jan 2025 22:30:08 -0800

kthread.c:1073: warning: expecting prototype for kthread_create_worker(). Prototype was for kthread_create_worker_on_node() instead

Link: https://lkml.kernel.org/r/20250111063008.910712-1-rdunlap@infradead.org
Fixes: b1e125dcbcea ("kthread: Unify kthread_create_on_cpu() and kthread_create_worker_on_cpu() automatic format")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kthread.c~kthread-modify-kernel-doc-function-name-to-match-code
+++ a/kernel/kthread.c
@@ -900,7 +900,7 @@ fail_task:
 }
 
 /**
- * kthread_create_worker - create a kthread worker
+ * kthread_create_worker_on_node - create a kthread worker
  * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
kasan-use-correct-kernel-doc-format.patch
latencytop-use-correct-kernel-doc-format-for-func-params.patch
kthread-modify-kernel-doc-function-name-to-match-code.patch

