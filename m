Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1831BE46
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251856; cv=none; b=lY7leQP8UmfG+F1xHwfGxeCsDkRTNSHn2Wp+EZ4bsSRAvxRbQU5oMaLtZhAYzsJeycC3Gy8Zoe7wXoN5MKh/J787b7yuCFGFfz9A7sZwElKnektxi0p8nlV+LeVdycCSg3aIwdsCvXxpcyV7WSTZEBHQC7zmOUOxBlJ41b00YdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251856; c=relaxed/simple;
	bh=vNEtguGHw7Bcs2jEWIwk8HOn3Po5XigSxAerO1r/nyo=;
	h=Date:To:From:Subject:Message-Id; b=F6JhKW4IvNfPLrXwVCwTsUT9mCIO+S8OGPLplTi1ZxNQOy3ztGRbynkrfUyL5GPJ/jnfK0T8Vn0LDM4XzhRM0vyuPiXWfDqYyb80pvOFcBawa6vh9q1lIuenNhVInfrHx9hbp8M9BkR+kDbBBei1QTE31Irq+UWrP4UaS3cE0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ReK3JX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ReK3JX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D185C4CECD;
	Wed, 30 Oct 2024 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730251856;
	bh=vNEtguGHw7Bcs2jEWIwk8HOn3Po5XigSxAerO1r/nyo=;
	h=Date:To:From:Subject:From;
	b=0ReK3JX70V/JhQJ6xvm6/QDZOrSqJPscM5i0NVAKc2mjeQOijsBJzoo678+jSpwBp
	 oxRHzpN6kFMjo1FOWR2B1P8/aX8oFvYLMYHJT91Nr4kZYmtemW0dAYZKIZelG7Ck3T
	 qP7148k3zGhvGHjk+cojIvMt5B2iJLw8Sr/jYwUA=
Date: Tue, 29 Oct 2024 18:30:55 -0700
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,vmalik@redhat.com,torvalds@linux-foundation.org,rostedt@goodmis.org,mikel@mikelr.com,leo.yan@arm.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + objpool-fix-to-make-percpu-slot-allocation-more-robust.patch added to mm-hotfixes-unstable branch
Message-Id: <20241030013056.6D185C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: objpool: fix to make percpu slot allocation more robust
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     objpool-fix-to-make-percpu-slot-allocation-more-robust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/objpool-fix-to-make-percpu-slot-allocation-more-robust.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: objpool: fix to make percpu slot allocation more robust
Date: Mon, 28 Oct 2024 12:26:27 +0900

Since gfp & GFP_ATOMIC == GFP_ATOMIC is true for GFP_KERNEL | GFP_HIGH, it
will use kmalloc if user specifies that combination.  Here the reason why
combining the __vmalloc_node() and kmalloc_node() is that the vmalloc does
not support all GFP flag, especially GFP_ATOMIC.  So we should check if
gfp & (GFP_ATOMIC | GFP_KERNEL) != GFP_ATOMIC for vmalloc first.  This
ensures caller can sleep.  And for the robustness, even if vmalloc fails,
it should retry with kmalloc to allocate it.

Link: https://lkml.kernel.org/r/173008598713.1262174.2959179484209897252.stgit@mhiramat.roam.corp.google.com
Fixes: aff1871bfc81 ("objpool: fix choosing allocation for percpu slots")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/all/CAHk-=whO+vSH+XVRio8byJU8idAWES0SPGVZ7KAVdc4qrV0VUA@mail.gmail.com/
Cc: Leo Yan <leo.yan@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: Mikel Rychliski <mikel@mikelr.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/lib/objpool.c~objpool-fix-to-make-percpu-slot-allocation-more-robust
+++ a/lib/objpool.c
@@ -74,15 +74,21 @@ objpool_init_percpu_slots(struct objpool
 		 * warm caches and TLB hits. in default vmalloc is used to
 		 * reduce the pressure of kernel slab system. as we know,
 		 * mimimal size of vmalloc is one page since vmalloc would
-		 * always align the requested size to page size
+		 * always align the requested size to page size.
+		 * but if vmalloc fails or it is not available (e.g. GFP_ATOMIC)
+		 * allocate percpu slot with kmalloc.
 		 */
-		if ((pool->gfp & GFP_ATOMIC) == GFP_ATOMIC)
-			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
-		else
+		slot = NULL;
+
+		if ((pool->gfp & (GFP_ATOMIC | GFP_KERNEL)) != GFP_ATOMIC)
 			slot = __vmalloc_node(size, sizeof(void *), pool->gfp,
 				cpu_to_node(i), __builtin_return_address(0));
-		if (!slot)
-			return -ENOMEM;
+
+		if (!slot) {
+			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
+			if (!slot)
+				return -ENOMEM;
+		}
 		memset(slot, 0, size);
 		pool->cpu_slots[i] = slot;
 
_

Patches currently in -mm which might be from mhiramat@kernel.org are

objpool-fix-to-make-percpu-slot-allocation-more-robust.patch

