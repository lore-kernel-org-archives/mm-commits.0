Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B5382C6C
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 19:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716491271; cv=none; b=ptzq/P6szl1rDYnBDVlB44o3kp+ilSh00LG9d66eFmcGTy88PgOh1b/xMflINCwUCW7JBFIxHil1Q1Dj1dLCArG+yGW4VOAEFATle1Tr3laIb+z4PHx0fimM5SuN6PJoyqohKhu+u4Gks7lKMH2wTYC+OQCAtpAS1x/c8gaXjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716491271; c=relaxed/simple;
	bh=Qh2+peXCMXNhh2w6skOTSUfHSpyRqRS97ZSTSjV3AwI=;
	h=Date:To:From:Subject:Message-Id; b=m5LTWFQPotm5kHzkbr4Sx2kmN12T6fVRP06MFbzd2BKrG+VtpYMLUzu/7eibl69JW8g1kaUngNs6S2oAPWYj5BBREVXxlbiZFNxFEkUZipEENEKmy7v8PamujAWlAF6qV3PzGo4rIhplKTNC/c30rqrvb6Qb/TpQ+7lM8E9OYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sATu7ksg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sATu7ksg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543B0C2BD10;
	Thu, 23 May 2024 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716491271;
	bh=Qh2+peXCMXNhh2w6skOTSUfHSpyRqRS97ZSTSjV3AwI=;
	h=Date:To:From:Subject:From;
	b=sATu7ksgz36utvo1nrQkJK/lREs1FT9uIz+PzutGhNjtrIwNMULK3ZkGs22Um06aO
	 FMpV4O61t0ebk+VQWoWM2f416BRz+LB6wcX0l+1x7Hmy1Mq1htE0FX4uy7/A78AYW5
	 9eFusiCnKD18u+rUTfWEf0cnfab5rVD7qCBSv3nY=
Date: Thu, 23 May 2024 12:07:50 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,keescook@chromium.org,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch added to mm-nonmm-unstable branch
Message-Id: <20240523190751.543B0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch

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
Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()
Date: Thu, 23 May 2024 09:35:14 +0200

Use this_cpu_try_cmpxchg() instead of this_cpu_cmpxchg (*ptr, old, new) ==
old in try_release_thread_stack_to_cache.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).

No functional change intended.

Link: https://lkml.kernel.org/r/20240523073530.8128-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache
+++ a/kernel/fork.c
@@ -205,7 +205,9 @@ static bool try_release_thread_stack_to_
 	unsigned int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		if (this_cpu_cmpxchg(cached_stacks[i], NULL, vm) != NULL)
+		struct vm_struct *tmp = NULL;
+
+		if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
 			continue;
 		return true;
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are

fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch

