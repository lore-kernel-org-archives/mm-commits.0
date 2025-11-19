Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608A0258EFC
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592843; cv=none; b=pO7NDHM2jABo037evPdYk912DJmxM1vAlVYJlGuRj6dRg2qcmgIG2YDHnlIFhMfiO5EpMj8JJsWS0CGOLG9dIewognzaR4OlKp8XVuIN+iBDyDyqgIudTk2t1e5pcDZgXSvZWbzvLfrVzSd9+vSPwNcwP68OCAGfSc1Q5NnOq+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592843; c=relaxed/simple;
	bh=QlbqPXqQg6pOMCr7JxpRp2nSkADHpUZL7kBTqhBdJx0=;
	h=Date:To:From:Subject:Message-Id; b=TxuYNxJIeTBYSLHQa3Y9iZ9Cw3qqOsenBtdAMwXGrHbK7Tf7YOgJt8QJUpRFHAc8DMyzIzqhHgtqWCkDQVxSHFmTkN0Gqkp9L+E3CtKU9UYEPaaqw7GIlaNJDyYYjJS3LA+oSlnDFwiESqzy62tTK4dznytakbBf/OJHncgaSgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qKJvy43n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qKJvy43n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D42C4CEF5;
	Wed, 19 Nov 2025 22:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763592843;
	bh=QlbqPXqQg6pOMCr7JxpRp2nSkADHpUZL7kBTqhBdJx0=;
	h=Date:To:From:Subject:From;
	b=qKJvy43n5uPQhjRhF7hLAEPx4l06ThQ9Y6PqtAYwJ2appytmVawcOfCsNiFUNwi2k
	 j2mnPGlmebfOsbsfcN/AKnIGK8fQmBv5tsu/eHhA4obittT1sX/+2VA2+jMLXsrn1X
	 C6W2KEutSApXg99S338JCiOB9h0/u2Q4Ue/DBn8g=
Date: Wed, 19 Nov 2025 14:54:02 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch added to mm-nonmm-unstable branch
Message-Id: <20251119225402.E2D42C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Petr as a reviewer of hung task detector
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Petr as a reviewer of hung task detector
Date: Wed, 19 Nov 2025 19:08:22 +0800

Petr has been actively reviewing hung task detector patches lately.  It's
always good to have a fresh pair of eyes, so let's make it official.

I checked with him, and he's happy to be added.

Link: https://lkml.kernel.org/r/20251119110822.46566-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Petr Mladek <pmladek@suse.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-petr-as-a-reviewer-of-hung-task-detector
+++ a/MAINTAINERS
@@ -11669,6 +11669,7 @@ HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Lance Yang <lance.yang@linux.dev>
 R:	Masami Hiramatsu <mhiramat@kernel.org>
+R:	Petr Mladek <pmladek@suse.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/hung_task.h
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch

