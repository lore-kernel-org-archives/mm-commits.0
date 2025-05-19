Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB5BA3D
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695283; cv=none; b=q2/KtFdA6anN1aVV69c6UQOLfOSJSwUmyHpZkVJfAZsHVPc4Xdi0EpuhQRaCLSRtkoDPwNZs3+kbfNdfPjT/Lc+dINn9EWIgFsDwh57BvMRx2uQlqs76c5Em0TJtFYqtoCnjJYrj+Zuq3W/kYvqxRMRO9w3M/6vYBTMGxu4dT6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695283; c=relaxed/simple;
	bh=2cYrVWffFUv2/5L5bxAV/Es4mJMnvjy6ixiKtwapCxU=;
	h=Date:To:From:Subject:Message-Id; b=GydReSZBtMtsy78assql/JQgKlGqn6buBRYQi37aacuYKuLTFgZnJrRWT85RRqvBwmP6mOARsKBKRsSO7eZz7TTx3+tlRgj+3Do4q7FiuOAbGHHOZBhcW5Lt2tc3NjCDulpqpTIQgnjVRHRySbvyFwoBR7Goe27C+N6W16xrIt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLQmQS0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLQmQS0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B45C4CEE4;
	Mon, 19 May 2025 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695282;
	bh=2cYrVWffFUv2/5L5bxAV/Es4mJMnvjy6ixiKtwapCxU=;
	h=Date:To:From:Subject:From;
	b=bLQmQS0GCENo/qOUKAlnYgiPV6yYL40pT1AF0uWosZL4m7IMaktA8e9WL1Hsb0obB
	 xg4Uduh/flT1bczNLLSTj1fNUbfVgwxLamjK6WFrbE61aYNWKLtIO7Nc+OeijXnANP
	 BlOa7n0WG7fLD6UJlAxU23JBtaSh32g6qUcviHJs=
Date: Mon, 19 May 2025 15:54:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pmladek@suse.com,john.ogness@linutronix.de,jani.nikula@intel.com,gregkh@linuxfoundation.org,sravankumarlpu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-format-kernel-doc-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20250519225442.A8B45C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic.c: format kernel-doc comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-format-kernel-doc-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-format-kernel-doc-comments.patch

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
From: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Subject: kernel/panic.c: format kernel-doc comments
Date: Fri, 16 May 2025 17:40:31 +0000

kernel-doc function comment don't follows documentation commenting style
misinterpreting arguments description with function description.

Please see latest docs generated before applying this patch
https://docs.kernel.org/driver-api/basics.html#c.panic

Link: https://lkml.kernel.org/r/20250516174031.2937-1-sravankumarlpu@gmail.com
Signed-off-by: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~kernel-format-kernel-doc-comments
+++ a/kernel/panic.c
@@ -277,12 +277,10 @@ static void panic_other_cpus_shutdown(bo
 }
 
 /**
- *	panic - halt the system
- *	@fmt: The text string to print
+ * panic - halt the system
+ * @fmt: The text string to print
  *
- *	Display a message, then perform cleanups.
- *
- *	This function never returns.
+ * Display a message, then perform cleanups. This function never returns.
  */
 void panic(const char *fmt, ...)
 {
_

Patches currently in -mm which might be from sravankumarlpu@gmail.com are

kernel-format-kernel-doc-comments.patch

