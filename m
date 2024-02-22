Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6C328E3
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560093; cv=none; b=f5eA9dDoj2+/Lg/FngMeL9gB3zJbBe4AAJ1HnHjuyMZAZEzy0f1G1PgRrMJB4aIjr6ua8gJhWJQTmldDCVjCanlLBIEkNmO6Osx89RH/G+mGy4tu/7etErC6QB2krPhOTSP1lVcr2vHakxxx5ZeyUCCMcyBUGC82xtn8KaYL/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560093; c=relaxed/simple;
	bh=x9/rxEcri5ZrqB7l5Rq86CulCXoPZ7AH23f5Lnss7qI=;
	h=Date:To:From:Subject:Message-Id; b=thBUcMRBhEkjiRLOS9CD5OOrBgcZCXxbmzy/+Vurw4/XHhj32olUBv/zgoHC/OWgiR+JXpatjukdSAuiJwpWLtAGu+NGHkABQ75NWYbZ6UxXZizRwohkqPfO6vIe/fbC9uCXK8aFlDqS9jTWOFdYA6eNsRuumopFa8yQoFcguQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=du5PBz27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="du5PBz27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6F0C433C7;
	Thu, 22 Feb 2024 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560092;
	bh=x9/rxEcri5ZrqB7l5Rq86CulCXoPZ7AH23f5Lnss7qI=;
	h=Date:To:From:Subject:From;
	b=du5PBz279udYbl2LoN2fzSDG/XS7jkTDUDeCu0tDcjz5B0WS5S1CF2QHSRv1MEWrz
	 wD76wHSV6+kYfaJ5uTYEEszZzc+IAh6JRhXfnpXjaR6v41RMKFfRCpiYWza8HX+YVX
	 MWOwZ4L73oZelsatfletvY+m5q4h7aj/5vJmHrEA=
Date: Wed, 21 Feb 2024 16:01:32 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch removed from -mm tree
Message-Id: <20240222000132.CE6F0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempolicy: clean up minor dead code in queue_pages_test_walk()
has been removed from the -mm tree.  Its filename was
     mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mempolicy: clean up minor dead code in queue_pages_test_walk()
Date: Mon, 22 Jan 2024 10:25:04 +0100

Commit 2cafb582173f ("mempolicy: remove confusing MPOL_MF_LAZY dead code")
removes MPOL_MF_LAZY handling in queue_pages_test_walk(), and with that,
there is no effective use of the local variable endvma in that function
remaining.

Remove the local variable endvma and its dead code. No functional change.

This issue was identified with clang-analyzer's dead stores analysis.

Link: https://lkml.kernel.org/r/20240122092504.18377-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/mempolicy.c~mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -654,7 +654,6 @@ static int queue_pages_test_walk(unsigne
 {
 	struct vm_area_struct *next, *vma = walk->vma;
 	struct queue_pages *qp = walk->private;
-	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
 
 	/* range check first */
@@ -682,9 +681,6 @@ static int queue_pages_test_walk(unsigne
 	    !(flags & MPOL_MF_STRICT))
 		return 1;
 
-	if (endvma > end)
-		endvma = end;
-
 	/*
 	 * Check page nodes, and queue pages to move, in the current vma.
 	 * But if no moving, and no strict checking, the scan can be skipped.
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


