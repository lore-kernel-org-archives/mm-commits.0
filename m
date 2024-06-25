Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641D33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719292970; cv=none; b=fKrmsNy7UrhGq1Q+r0eZQ5s3fVIDuSXctPs0YkcuQuVVe2VKHw3sJbgmkRg3e/zMOP+Pdcw56fTyyTEp/8Nn3SpWKpclrVumUbH57BJkM5ZdQBD9mETBl0iSfZxAqUghtjmgz5d5Yge6maT60PtghZyY/c7dPdweDfuXGOUqA1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719292970; c=relaxed/simple;
	bh=TMleEk9/AWQWcxpcXv/w5LeBjrnSh0xfIFXeSV//Vzg=;
	h=Date:To:From:Subject:Message-Id; b=mz8Vn5DTLbvkFf2LeiNnIPxVILo8gt/62V+1H4KrbkRkhZTp6lTO6RVYch8Hkh86qVu/PIZco3c5x0ewJD8Q+7d+SpokXrqhezWJ0b9vhRFZw+OILNFn4k0z12Uq0n5bu75kYKi3wXtigHlRNsAdoCG/EYftAVRfyqVhf9Mrl70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7JomN0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7JomN0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00235C32782;
	Tue, 25 Jun 2024 05:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719292970;
	bh=TMleEk9/AWQWcxpcXv/w5LeBjrnSh0xfIFXeSV//Vzg=;
	h=Date:To:From:Subject:From;
	b=n7JomN0IcdLlWMVhAayF0+JApvJPNaHOQhgXqs0/7l0lfL7Kx6rlhrJO5YVrW5U8r
	 cW5a+wRDKoAYr8uPf1FRLtjsB3hp0y7q0lUkspTUs80gQsJ8C1IZMpvHnzWxSMxwFK
	 LB5RO+eRMcg9Qv19GODtXdPFXnt7dGzBLn2VN2Bg=
Date: Mon, 24 Jun 2024 22:22:49 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch removed from -mm tree
Message-Id: <20240625052250.00235C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix
has been removed from the -mm tree.  Its filename was
     fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache-fix.patch

This patch was dropped because it was folded into fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch

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

