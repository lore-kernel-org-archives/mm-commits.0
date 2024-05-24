Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A871E864
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 02:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716519308; cv=none; b=igHzvfu9VxGy16N5HlWuAWbgbCX8XLmIlbmO9PjL2XcPmU0ebIHWjBxGcFIOfcf1hQRkdkxoswcuZI7GJL2/rCQsAEsw+O6/RNsNyriPmZi4zWpbAJelWBAvHyI4R+IS93QHI55Tar5++d9CumQysbbtIZk6dZdJd9DtgWnAbvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716519308; c=relaxed/simple;
	bh=i5wzy68B/P5dHE9wwm31RZ/ewtJp0spNbRkr170Yalg=;
	h=Date:To:From:Subject:Message-Id; b=HOi6vGmpso6ns8JdrbXK9ZSKgH8m+BzvGD5U+ghsAmjD+Tt8ETCUC5XkI1lmFTjlgq7EBnw22xHYx33t9Jv2BL+pZHjpvQ2n1oI6757QhY3bZjdnyEBex0aH/F12cKTXmNeiwE7aqnnuPZ49YungCO6HE55HuX34XeJAeBJ/LLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e6q7Ens6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e6q7Ens6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22597C2BD10;
	Fri, 24 May 2024 02:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716519308;
	bh=i5wzy68B/P5dHE9wwm31RZ/ewtJp0spNbRkr170Yalg=;
	h=Date:To:From:Subject:From;
	b=e6q7Ens6u1v/0xuLxnZe/xK47EghdD0ebrm/AnVB8UKwa5gtRQzqQ3U3txlm6e3wY
	 hZTWixDSlVnDOBGxN1KN1TbAUBthrsgYziQHAiBMlLn3xpcOO6KshjmDCBbImbx223
	 XV1Cypb9sTnDuGy4PKDqZs8cy19xZaeNi2aSAQV8=
Date: Thu, 23 May 2024 19:55:07 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240524025508.22597C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix
Date: Thu, 23 May 2024 23:43:49 +0200

Simplify the for loop a bit.

Link: https://lkml.kernel.org/r/20240523214442.21102-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Oleg Nestrov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix
+++ a/kernel/fork.c
@@ -207,9 +207,8 @@ static bool try_release_thread_stack_to_
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
 		struct vm_struct *tmp = NULL;
 
-		if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
-			continue;
-		return true;
+		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
+			return true;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from ubizjak@gmail.com are

fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

