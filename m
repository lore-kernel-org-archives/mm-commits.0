Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6733C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293154; cv=none; b=TMHXjlnSpQFWRyk1ZP1+H+7YEc0B69cLPf9S+lvSjjIfEWil913r/IFSvHuceuwVU1MDNBBbzBvj9SrZoFjMJwVmnI+hUjLGrOX2X3wDJs4ea/VZqTYxH3IDc5CUG2cAkeqdsQihSLSC93G7spvH+vL4c9w+5C48DbsHv74bb1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293154; c=relaxed/simple;
	bh=5eKmSW9Y4ZVK5eSX51f5cBgS6Dfg3n6KjtFM3UHXFPM=;
	h=Date:To:From:Subject:Message-Id; b=db3gGEedySotpUHRHxGJBTwl8k3+I0ObH00cMZmwgI+KDuM1FlO9+pfpB+3ghtximYCs/s1nxWX23Cypw7YUZOKWoXBG2U6MausVe16ZXS3CmplPBpw4Pq7zK+s3wfG9B8epYrhFlo8rfICCaERsw4T2GuP8nOmLioqIIh/h5Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aaBR3r6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aaBR3r6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604C3C32782;
	Tue, 25 Jun 2024 05:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293154;
	bh=5eKmSW9Y4ZVK5eSX51f5cBgS6Dfg3n6KjtFM3UHXFPM=;
	h=Date:To:From:Subject:From;
	b=aaBR3r6b5Be6nF6zV505JLBCIt0Hoi6VE3wmErl+siiP6oJxwAzB5hCdpPycD9YCG
	 quUz0Oq5NlSgr21XRVntkIpXICkwD3Gu2+33vDRoiX06pMEXiwUvinJ+nfhm9/GY2y
	 xlI7rJxnqJp9rizmB2HFa7uexOABEErfQ478KxvM=
Date: Mon, 24 Jun 2024 22:25:53 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,keescook@chromium.org,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch removed from -mm tree
Message-Id: <20240625052554.604C3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()
has been removed from the -mm tree.  Its filename was
     fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()
Date: Thu, 23 May 2024 09:35:14 +0200

Use this_cpu_try_cmpxchg() instead of this_cpu_cmpxchg (*ptr, old, new) ==
old in try_release_thread_stack_to_cache.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).

No functional change intended.

[ubizjak@gmail.com: simplify the for loop a bit]
  Link: https://lkml.kernel.org/r/20240523214442.21102-1-ubizjak@gmail.com
Link: https://lkml.kernel.org/r/20240523073530.8128-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/fork.c~fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache
+++ a/kernel/fork.c
@@ -205,9 +205,10 @@ static bool try_release_thread_stack_to_
 	unsigned int i;
 
 	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		if (this_cpu_cmpxchg(cached_stacks[i], NULL, vm) != NULL)
-			continue;
-		return true;
+		struct vm_struct *tmp = NULL;
+
+		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
+			return true;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from ubizjak@gmail.com are


