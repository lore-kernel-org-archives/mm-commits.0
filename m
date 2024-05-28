Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791745012
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931896; cv=none; b=Jt7v11HPDKdrgPYM8cycyIdBG1M4uiI/5A9e3wOTZI+QkYZlxOsS4EgyBb9FDL8f3I3wL6cV1T9uIZ3e6wyhoiZbxkoZdaZkCj9W8IMxfKYRVg67Xn5OliI4YIqHenwqBtzqnrUX8gZJFdhRUis0AzCyZi0wM6t/7PNCN10HwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931896; c=relaxed/simple;
	bh=gDRoDRDYWPJfNIVZ2bQZgkuaLOOma1vbj/RN9FLDsBk=;
	h=Date:To:From:Subject:Message-Id; b=nSpmdrs/tptY0wixzv8BDunj2Tou4uTfYskoYrjQ5qEmS/SOYJNJHBtBUVdmj1c85YTQHoeYtpLH6SxRQnLNpD62aIJUToWk0U8FPpc5y5l3GA4ncFr7fbwxgKprHNwvP4BZYnIN+adBDcUQJOtcQKzKnNm7o6S/R1g0Y0NdrRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q53uUPRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q53uUPRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DE5C3277B;
	Tue, 28 May 2024 21:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716931895;
	bh=gDRoDRDYWPJfNIVZ2bQZgkuaLOOma1vbj/RN9FLDsBk=;
	h=Date:To:From:Subject:From;
	b=Q53uUPRrNlNbVc5SNNwP1Nl+Heq8MgYZSVd4v1eIJv7cR+6MzJG9EXHsR4Y9UoDMx
	 ViI0toobKJR5ic8KZTvtG7dj13s+k7q+X28oDFNoTvJ/OoaecFLDgbs46jeunRZzT7
	 1D0UbzbBWo40EblsfzlpHhbBwsThg8Y23cqGOwGY=
Date: Tue, 28 May 2024 14:31:35 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-plistc-enforce-memory-ordering-in-plist_check_list.patch added to mm-nonmm-unstable branch
Message-Id: <20240528213135.99DE5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/plist.c: enforce memory ordering in plist_check_list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

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
From: I Hsin Cheng <richard120310@gmail.com>
Subject: lib/plist.c: enforce memory ordering in plist_check_list
Date: Sun, 26 May 2024 22:01:39 +0800

There exists an iteration over a plist in plist_check_list(), and memory
dependency exists between variables "prev", "next" and "prev->next".  As
plist is used in the scheduling subsystem, we should guarantee the memory
ordering between multiple processors.

Using macro "WRITE_ONCE()" can help us to ensure the memory ordering as
it was stated in "Documentation/memory-barriers.txt".

Link: https://lkml.kernel.org/r/20240526140139.17220-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/plist.c~lib-plistc-enforce-memory-ordering-in-plist_check_list
+++ a/lib/plist.c
@@ -47,8 +47,8 @@ static void plist_check_list(struct list
 
 	plist_check_prev_next(top, prev, next);
 	while (next != top) {
-		prev = next;
-		next = prev->next;
+		WRITE_ONCE(prev, next);
+		WRITE_ONCE(next, prev->next);
 		plist_check_prev_next(top, prev, next);
 	}
 }
_

Patches currently in -mm which might be from richard120310@gmail.com are

lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

