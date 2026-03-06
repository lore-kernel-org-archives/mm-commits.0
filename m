Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5003A6417
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821721; cv=none; b=ecGfQiY8mcp+M2xkxGT2Ihq6fcA58ogFMvnTBo88OMghmhspyqcFhefP2YL4472s5SQEvJwTJIQodMcWQi1nIaRI1YqSRqq5xi64miITejzpQFIn2sDzPbDWrkNHBqx00hIqLWkDrLAQ37k622llNvAqZAbQgBpv6r40PE8Wg2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821721; c=relaxed/simple;
	bh=a94r16Ednd+y4ZCX8LbcsTWPiaivJ8MaaAwywGCwHDI=;
	h=Date:To:From:Subject:Message-Id; b=ibx3WtxK2UgmVGRW9+Ff3UysvHCAk+6pxEVbthe3Ui2O1nd0DqEtjKm91CQp+73jqgI1JMY4cpZvnWe33phQ4pRhCSv0oypyufESGxGFuZ5Ey3QqxzH9jLTh7HGl784Ncc84AMtyhMnNyLQsoc4Xt9h7vQ3ffAVUVEN9luG+4+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kn10S5KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kn10S5KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873E5C4CEF7;
	Fri,  6 Mar 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772821720;
	bh=a94r16Ednd+y4ZCX8LbcsTWPiaivJ8MaaAwywGCwHDI=;
	h=Date:To:From:Subject:From;
	b=kn10S5KLlZIU07rh0+R/l7CqiCp9glcM+Q+Wkq+ON4n2Zr35oelWtK/ntXtyCmwO1
	 pzzwQnKCvxo4oJP5GxWGrqg8Scq54s+Z4RNRQwPUgcLB6pAmtP5GhV+QWpRqHcAMi5
	 uMQmEcdoqycBqOWyGwnCnjBtU9Lbh3wM7yBmd7f0=
Date: Fri, 06 Mar 2026 10:28:39 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bug-fix-inconsistent-capitalization-in-bug-message.patch added to mm-nonmm-unstable branch
Message-Id: <20260306182840.873E5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bug: fix inconsistent capitalization in BUG message
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bug-fix-inconsistent-capitalization-in-bug-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bug-fix-inconsistent-capitalization-in-bug-message.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib/bug: fix inconsistent capitalization in BUG message
Date: Fri, 6 Mar 2026 16:23:27 +0000

Use lowercase "kernel BUG" consistently in pr_crit() messages.  The
verbose path already uses "kernel BUG at %s:%u!" but the non-verbose
fallback uses "Kernel BUG" with an uppercase 'K'.

Link: https://lkml.kernel.org/r/20260306162327.2815553-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bug.c~lib-bug-fix-inconsistent-capitalization-in-bug-message
+++ a/lib/bug.c
@@ -254,7 +254,7 @@ static enum bug_trap_type __report_bug(s
 	if (file)
 		pr_crit("kernel BUG at %s:%u!\n", file, line);
 	else
-		pr_crit("Kernel BUG at %pB [verbose debug info unavailable]\n",
+		pr_crit("kernel BUG at %pB [verbose debug info unavailable]\n",
 			(void *)bugaddr);
 
 	return BUG_TRAP_TYPE_BUG;
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch

