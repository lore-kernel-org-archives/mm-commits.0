Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211E2DCF61
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770064176; cv=none; b=RR/zahbgHBYHRIhhic4IvyflqacJtM0UbWLZLGA8+Hs+avEnIm/JI4Sz40NK4zjdfR/7qvMoVd5NTOZF/Bi2KhnBZrK7IeHJ26bMX2Kz8+czwp2CZ9uf4u3pG2htoS1Ps+HCUfAZBEYFlL1QgBhrexVNyMqmuqCmF/4p87oVRi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770064176; c=relaxed/simple;
	bh=ON3NXgzD87g8B7XokN0yj64WRcP/x6ByQ6U9TL2dsT0=;
	h=Date:To:From:Subject:Message-Id; b=QRs3mYIQf1Kwxu2xvK9EpCpIJz2rqpHlMe8U/wYlcAAjZ+EPWAZVY/ceUzvdNn4DGrqVmQVS4f0q63za+fFcXqZ56JztqQjuIhXKYZvlfXNwF+4QX5wAriZUxvimtIRX5cZPpETOrvYy43+ZKgbGnMcu36M6KCqVBFLKOko2SF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zk9+98Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zk9+98Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3900CC116C6;
	Mon,  2 Feb 2026 20:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770064176;
	bh=ON3NXgzD87g8B7XokN0yj64WRcP/x6ByQ6U9TL2dsT0=;
	h=Date:To:From:Subject:From;
	b=Zk9+98Nhc57aiz9dA7Zg17s0hnRpUBLXkkGn1nXX+BzYe0PEY5021uPAmR7kIe7ya
	 XrMPJcjTNCwa8cyyoQLvImi+YwITjtXyLe6KGhgV8bEDLUP2MVfZNhdYbCQVd+laoZ
	 uzH24y0SgUO1n8NbB36k4eJLpWuYWLRob99xoV0s=
Date: Mon, 02 Feb 2026 12:29:35 -0800
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,mhiramat@kernel.org,akpm@linux-foundation.org,zhouwenhao7600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch added to mm-nonmm-unstable branch
Message-Id: <20260202202936.3900CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: objpool: fix the overestimation of object pooling metadata size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch

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
From: zhouwenhao <zhouwenhao7600@gmail.com>
Subject: objpool: fix the overestimation of object pooling metadata size
Date: Mon, 2 Feb 2026 21:28:46 +0800

objpool uses struct objpool_head to store metadata information, and its
cpu_slots member points to an array of pointers that store the addresses
of the percpu ring arrays.  However, the memory size allocated during the
initialization of cpu_slots is nr_cpu_ids * sizeof(struct objpool_slot). 
On a 64-bit machine, the size of struct objpool_slot is 16 bytes, which is
twice the size of the actual pointer required, and the extra memory is
never be used, resulting in a waste of memory.  Therefore, the memory size
required for cpu_slots needs to be corrected.

Link: https://lkml.kernel.org/r/20260202132846.68257-1-zhouwenhao7600@gmail.com
Fixes: b4edb8d2d464 ("lib: objpool added: ring-array based lockless MPMC")
Signed-off-by: zhouwenhao <zhouwenhao7600@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: wuqiang.matt <wuqiang.matt@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/objpool.c~objpool-fix-the-overestimation-of-object-pooling-metadata-size
+++ a/lib/objpool.c
@@ -142,7 +142,7 @@ int objpool_init(struct objpool_head *po
 	pool->gfp = gfp & ~__GFP_ZERO;
 	pool->context = context;
 	pool->release = release;
-	slot_size = nr_cpu_ids * sizeof(struct objpool_slot);
+	slot_size = nr_cpu_ids * sizeof(struct objpool_slot *);
 	pool->cpu_slots = kzalloc(slot_size, pool->gfp);
 	if (!pool->cpu_slots)
 		return -ENOMEM;
_

Patches currently in -mm which might be from zhouwenhao7600@gmail.com are

objpool-fix-the-overestimation-of-object-pooling-metadata-size.patch

