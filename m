Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC2C1FBE8C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 04:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001632; cv=none; b=FSJaEYkvjjOxE1pdzWJpyivVyIcSdP4iwz3A8osNBhRrm3fPBWry6yB6BIC24un/D8bOBo/8Ac0qV7ge+S6y6qLKjGW15ATZ84iLB3dpZVgzYT3O3Qvfr6IYcT2oS1L2sf2dE0XW0s2UlJGiyLJNZXCohmmT4z3JGmummz1bvHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001632; c=relaxed/simple;
	bh=8Zkpvc7ijs6rVmbZcwNEjqQeMGGFmNFnkQ2nj3JeX10=;
	h=Date:To:From:Subject:Message-Id; b=atDYW+MqQ6XiFQWhRMQ1KQpfK4tfx6Ly+mVa9+Z0/NNG+hmyJ5x53pwAIJjG6Vt6JPIZJiTARoNBBGdqK/fJRIQkeCZt1dS4Q/wjAownXUUBRyIBDyWtJoyAqE4EF6BRbXBur9rTnwjpg+wiemzqwmj6dgfklNZQq887+ekAf9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsszqCH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsszqCH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4EEC4CEDD;
	Mon,  7 Apr 2025 04:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744001632;
	bh=8Zkpvc7ijs6rVmbZcwNEjqQeMGGFmNFnkQ2nj3JeX10=;
	h=Date:To:From:Subject:From;
	b=wsszqCH828oRhVsTYMmnO1fvjMr/kVb8RXRAdWTLqvcuZTpQNkE6OjKyBdmgWMHWw
	 +hMscxUvLw+FsYcX0RNPqr+35a0RHCviA/+GRM6gRdcqvLtu/VTAXW/VBgMddaeSuI
	 HdyAv+MOXdQEzbGoeOfzlKNFlUdAIGU27sLvksEM=
Date: Sun, 06 Apr 2025 21:53:51 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,aardelean@baylibre.com,mingo@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-move-read-write-definitions-to-linux-typesh.patch added to mm-nonmm-unstable branch
Message-Id: <20250407045351.DA4EEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: move READ/WRITE definitions to <linux/types.h>
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-move-read-write-definitions-to-linux-typesh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-move-read-write-definitions-to-linux-typesh.patch

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
From: Ingo Molnar <mingo@kernel.org>
Subject: kernel.h: move READ/WRITE definitions to <linux/types.h>
Date: Mon, 24 Mar 2025 12:50:24 +0200

Patch series "kernel.h: Move out a couple of macros and constants".

kernel.h hosts a couple of macros and constants that may be better placed.
Do that.  Also add missing documentation.  No functional changes
intended.


This patch (of 2):

Headers shouldn't be forced to include <linux/kernel.h> just to
gain these simple constants.

Link: https://lkml.kernel.org/r/20250324105228.775784-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20250324105228.775784-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ----
 include/linux/types.h  |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kernel.h~kernelh-move-read-write-definitions-to-linux-typesh
+++ a/include/linux/kernel.h
@@ -41,10 +41,6 @@
 
 #define STACK_MAGIC	0xdeadbeef
 
-/* generic data direction definitions */
-#define READ			0
-#define WRITE			1
-
 #define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
 
 #define u64_to_user_ptr(x) (		\
--- a/include/linux/types.h~kernelh-move-read-write-definitions-to-linux-typesh
+++ a/include/linux/types.h
@@ -136,6 +136,10 @@ typedef s64	ktime_t;
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
+/* generic data direction definitions */
+#define READ			0
+#define WRITE			1
+
 /*
  * The type of an index into the pagecache.
  */
_

Patches currently in -mm which might be from mingo@kernel.org are

kernelh-move-read-write-definitions-to-linux-typesh.patch

