Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879D27A904
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821722; cv=none; b=qZXU9iP01m6DiqWWzO/v2cEh66rsqOfkT9E87vHo3AMWnVUTeZqj2d+LiUcBV3Y0mSREZVnINo/5QDVo8KRErmB8iMlABv8Z2dN+/Jj/txdOpXLYYut6/Ec0eTv9RKvgEBFVZMWw5PDIY08zM5t4WmISC/xk20bsjXrrMOFI2vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821722; c=relaxed/simple;
	bh=luvEMkZO483m/Qu6Md8A0jehSd9Ewmxaw7KbDoB7HJQ=;
	h=Date:To:From:Subject:Message-Id; b=H+NvUnkLhe2zO3h6zi+LMFtOloJK605abUCVwR7UipskEz7PwbtwFG7J6eyiN55t6I8brvY4irEcErEXIbJVYx8WS74W+J+JuwGaVV5OiZS+NV8vFd0BUIIqgQtXLsMy8pRWkwH1fEHAmk+TYEKry+/g01znNjhFcGGbQq1dX3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EFveH6Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EFveH6Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D1C4CEF7;
	Fri,  6 Mar 2026 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772821722;
	bh=luvEMkZO483m/Qu6Md8A0jehSd9Ewmxaw7KbDoB7HJQ=;
	h=Date:To:From:Subject:From;
	b=EFveH6LrTusP4/kNC3iTtR5lYET78UuKCdy6yghb1n6pExPUfc5QooL4uwwfhRfxN
	 +c/HD3xKXhXrsMuGdsETYdwBdZNLnynjS5+OlHy0CNn8bTkwERdLFrTsBVS02HR8P5
	 8s7hHgWfM1ZWLBLatTPmoQQdi+/KXBFsIY4aE6Ug=
Date: Fri, 06 Mar 2026 10:28:42 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bug-remove-unnecessary-variable-initializations.patch added to mm-nonmm-unstable branch
Message-Id: <20260306182842.814D1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bug: remove unnecessary variable initializations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bug-remove-unnecessary-variable-initializations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bug-remove-unnecessary-variable-initializations.patch

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
Subject: lib/bug: remove unnecessary variable initializations
Date: Fri, 6 Mar 2026 16:24:18 +0000

Remove the unnecessary initialization of 'rcu' to false in
report_bug_entry() and report_bug(), as it is assigned by warn_rcu_enter()
before its first use.

Link: https://lkml.kernel.org/r/20260306162418.2815979-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bug.c~lib-bug-remove-unnecessary-variable-initializations
+++ a/lib/bug.c
@@ -263,7 +263,7 @@ static enum bug_trap_type __report_bug(s
 enum bug_trap_type report_bug_entry(struct bug_entry *bug, struct pt_regs *regs)
 {
 	enum bug_trap_type ret;
-	bool rcu = false;
+	bool rcu;
 
 	rcu = warn_rcu_enter();
 	ret = __report_bug(bug, bug_addr(bug), regs);
@@ -275,7 +275,7 @@ enum bug_trap_type report_bug_entry(stru
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	enum bug_trap_type ret;
-	bool rcu = false;
+	bool rcu;
 
 	rcu = warn_rcu_enter();
 	ret = __report_bug(NULL, bugaddr, regs);
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

