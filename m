Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04B156F57
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738021099; cv=none; b=l2F0kTA/2jJJ/L6exELqFK0SJ4sIx09upT2qrgyKkslKHCQfC4TVgjp3VMM70GNMcGMNSIamA6p2AMe34tgKVNN/tdCjE6917xFgLi/+3NlYBdpeeEfT8bs3ugzlIpyhrvg59dop8rEuWeicLOSIJ3/FPtdhM8Ns1wmPvVTHzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738021099; c=relaxed/simple;
	bh=YbG23ieK4JA2HpahplX5tNF4uBLQ6wly2eVHhk318Ik=;
	h=Date:To:From:Subject:Message-Id; b=OEp322HH1zyM6NdQT5+Q+cHBuueFqzCId4QjGHhwdHW7vXhk0MjTZNTxT6cazrRt6zKhdq3pPaMVgnBSmB4L9ryd9r3fdM148OX7+TsMLMgvg/XPkqZ/jBOLMzlib/ugrW5N8iFqt6ogk3js2SDYIawKas/wKl+h6onYit4cjVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNmfbZGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNmfbZGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE8FC4CED2;
	Mon, 27 Jan 2025 23:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738021098;
	bh=YbG23ieK4JA2HpahplX5tNF4uBLQ6wly2eVHhk318Ik=;
	h=Date:To:From:Subject:From;
	b=wNmfbZGm0oB08ftC4ZijX9eRxtMI7t15vCziZDg8nBFmbXCvWWxDhzOGzxdbvIWuW
	 i+/ihFN+lxkTwytHaLYxs8m7t3uae9vfFXsu2Z4URlXxR1KNU0+il3WqUpDvTSBlvP
	 GCa0W5H0b19jDh350eaeviV09xgAUxk87paZ5NhU=
Date: Mon, 27 Jan 2025 15:38:17 -0800
To: mm-commits@vger.kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-fix-trivial-typo-in-comment.patch added to mm-unstable branch
Message-Id: <20250127233818.4BE8FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: fix trivial typo in comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_kill-fix-trivial-typo-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-fix-trivial-typo-in-comment.patch

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
From: Carlos Llamas <cmllamas@google.com>
Subject: mm/oom_kill: fix trivial typo in comment
Date: Thu, 23 Jan 2025 19:35:22 +0000

Update 'give' -> 'given' in the description of oom_reap_task_mm().

Link: https://lkml.kernel.org/r/20250123193523.1496909-1-cmllamas@google.com
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_kill-fix-trivial-typo-in-comment
+++ a/mm/oom_kill.c
@@ -563,7 +563,7 @@ static bool __oom_reap_task_mm(struct mm
 }
 
 /*
- * Reaps the address space of the give task.
+ * Reaps the address space of the given task.
  *
  * Returns true on success and false if none or part of the address space
  * has been reclaimed and the caller should retry later.
_

Patches currently in -mm which might be from cmllamas@google.com are

mm-oom_kill-fix-trivial-typo-in-comment.patch

