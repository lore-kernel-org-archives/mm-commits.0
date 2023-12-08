Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79655027D
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8wwta8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2126FC433CA;
	Fri,  8 Dec 2023 19:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702064632;
	bh=j50XS9FANnBA5QzmwhHMcRXl49ItKH4hyfmN3xSdM/U=;
	h=Date:To:From:Subject:From;
	b=c8wwta8OwFaGDFJfJYDFd1AamvIPlE5HMQLK0eHPBRMVYsw9W/DJgKDN1NweVnDYy
	 HPGxmG+z60cPztwODkinX5l3MmKmcoV+iSRs+VD8tKXNFTo6jR+f/r2HL7TYBNdoHV
	 NSxq+I0KxcH9aVqgaQa+GeM6fxhuMDSaDh18UxsE=
Date: Fri, 08 Dec 2023 11:43:51 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-remove-redundant-task_uninterruptible.patch added to mm-nonmm-unstable branch
Message-Id: <20231208194352.2126FC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: remove redundant TASK_UNINTERRUPTIBLE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-remove-redundant-task_uninterruptible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-remove-redundant-task_uninterruptible.patch

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
From: Kevin Hao <haokexin@gmail.com>
Subject: fork: remove redundant TASK_UNINTERRUPTIBLE
Date: Fri, 8 Dec 2023 16:41:15 +0800

TASK_KILLABLE already includes TASK_UNINTERRUPTIBLE, so there is no
need to add a separate TASK_UNINTERRUPTIBLE.

Link: https://lkml.kernel.org/r/20231208084115.1973285-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-remove-redundant-task_uninterruptible
+++ a/kernel/fork.c
@@ -1580,7 +1580,7 @@ static void complete_vfork_done(struct t
 static int wait_for_vfork_done(struct task_struct *child,
 				struct completion *vfork)
 {
-	unsigned int state = TASK_UNINTERRUPTIBLE|TASK_KILLABLE|TASK_FREEZABLE;
+	unsigned int state = TASK_KILLABLE|TASK_FREEZABLE;
 	int killed;
 
 	cgroup_enter_frozen();
_

Patches currently in -mm which might be from haokexin@gmail.com are

fork-remove-redundant-task_uninterruptible.patch

