Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486214A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006489; cv=none; b=irfjR7qgkF63LXuXRqaqf9vHx/3+fO6w7MmAdMFEMI44xmd8PepjjXlUyrerMLfdH3GUr/q2Jlr5f4QBYaj6EmmkMhgxvJCmR1DwIKSsdiWD7vBDVyCNwYDw8QRj0rCL/6cBe1lddoZbMCf7GeGVAFdIPbcF09NCwRFixK7m96U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006489; c=relaxed/simple;
	bh=KcjoHJ53XU2pLSiHBnalCKeSRAP8GoGdh2in35xom24=;
	h=Date:To:From:Subject:Message-Id; b=r8bvdq00ly9dzLF0qJVcTRUde0r9SADYhFOnAQrLPZi0S4O7J90oYkNcSAWPm8Nt8DecDCaaWWqwve/+yq9Nh2xbwR5FsWoI+fOExdoV4jeuZYcb4KnSBjy0EC2v0O8akEGSrHz06Cfr0K6umP5ju1VMMgtLFp1bifPsAzboQIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jGZShB9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGZShB9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F9C4CED6;
	Thu, 16 Jan 2025 05:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006489;
	bh=KcjoHJ53XU2pLSiHBnalCKeSRAP8GoGdh2in35xom24=;
	h=Date:To:From:Subject:From;
	b=jGZShB9lBlF8wMdQA442Tgi1EEHjJ/mh1nYJN/OatJBOaT5P3aA3Nq1jbHXLQPSzG
	 i6JIaOLl0Qj2BtKW7f2DM5gB+q6Flk4Rz2Jo2usgATPFh3QZsvFMMd5jACE3rj6LUp
	 wGG0ajJwzGr7Mp6rBvSswdZb+G8NpO1dDu57NxiY=
Date: Wed, 15 Jan 2025 21:48:08 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] latencytop-use-correct-kernel-doc-format-for-func-params.patch removed from -mm tree
Message-Id: <20250116054809.691F9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: latencytop: use correct kernel-doc format for func params
has been removed from the -mm tree.  Its filename was
     latencytop-use-correct-kernel-doc-format-for-func-params.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


