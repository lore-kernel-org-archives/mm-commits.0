Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D48015E5BB
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 21:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758748284; cv=none; b=YZYNeJlRAi3/QkyT24pS1PJmrhX47T+OuXjkD/T38CMxCjMdK2/vLpqPRLV2mYDxtiIq/su2H3rH3I7hNANCjg/mpnGTI7vFd2cdoCzQz3H5nn+4G8QI5PZovY7cTVHVY2tBJViO/4aRP8As546jGBzbAgQU5VccoY0Li77cjiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758748284; c=relaxed/simple;
	bh=C7ctoAvaSedb4qxfNPCI3xvxHJwFIlWTLlnhxY8Q1Sk=;
	h=Date:To:From:Subject:Message-Id; b=A2ycBo6CbIf2WLCPZc1bnirv1QD1GmJ3li/RHVrthCpsoZOB+K0tUb6lbPX5pdx2X6TOagMD3CIttcjPWaVCtgRkbZpqpD2auJ/YDZoKnJIysX9IBpoJEkEN7Plo9pj0xXXvuZYFL9//+l/m5Bkm0n4bxBp/bp+WR0qF18LN2OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1TzWQta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1TzWQta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1062FC4CEE7;
	Wed, 24 Sep 2025 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758748284;
	bh=C7ctoAvaSedb4qxfNPCI3xvxHJwFIlWTLlnhxY8Q1Sk=;
	h=Date:To:From:Subject:From;
	b=e1TzWQta+/y4f7dHlw9N3Z2vIUCFvTtI7G0q2tRhJxFhlhYpABdKfLQE5jvkMMH3X
	 PB+LBAXInr7WJLXhiFYbkTXADfoJGyomOykcFcea2rIuWMrvlGAAcIZop35tFqHM4g
	 4Zdp3pggyjDfMHy9tbKorn/zd7baiYQyV9eON63E=
Date: Wed, 24 Sep 2025 14:11:23 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,kees@kernel.org,david@redhat.com,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + copy_process-fixed-jump-logic-error.patch added to mm-nonmm-unstable branch
Message-Id: <20250924211124.1062FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: copy_process(): fix jump logic error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     copy_process-fixed-jump-logic-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/copy_process-fixed-jump-logic-error.patch

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
From: Edward Adam Davis <eadavis@qq.com>
Subject: copy_process(): fix jump logic error
Date: Wed, 24 Sep 2025 20:06:21 +0800

After futex_hash_allocate_default() fails, the logic should jump to
bad_fork_cancel_cgroup, not bad_fork_core_free.

Jumping to bad_fork_core_free would cause a siglock imbalance.

Link: https://lkml.kernel.org/r/tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~copy_process-fixed-jump-logic-error
+++ a/kernel/fork.c
@@ -2296,7 +2296,7 @@ __latent_entropy struct task_struct *cop
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created
_

Patches currently in -mm which might be from eadavis@qq.com are

copy_process-fixed-jump-logic-error.patch

