Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFE7270ED7;
	Fri,  1 Aug 2025 21:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754083914; cv=none; b=BnVULk6y3WOA4lHj5psjJ7Bu73f8Ilzb96GI+MLW4r05toGvv92iz4L+6wT9HREkVNmHP3GpKERD55ZkUetFX5o7x8oRkF3g4UcQoCal4oT9H6PmGB6EwVb2dKb8Yg8orCe+fm836tvJvRYZQU/p67TE76O5RzuQOprGWja2Df0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754083914; c=relaxed/simple;
	bh=9q5dzBi3UbifeQA2YFFPAknXcxytFOsGnBLpXUJ304E=;
	h=Date:To:From:Subject:Message-Id; b=Mo9Wqq/ebkFZCD4ki4iM0UityFfyceIsdhTIdbvUgLYT3G9m6YdpPywE1NqY206T6lmAR/5bSlv0PCQan+3thM0nBfPAni3cEvJUNLJ2a94US4bWEAw8qXnwaESYe52UXJoNhXEiiI380IXksqf2BZsS3/r52UI1pKFWh5BikBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UhoEsNe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UhoEsNe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF09C4CEE7;
	Fri,  1 Aug 2025 21:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754083913;
	bh=9q5dzBi3UbifeQA2YFFPAknXcxytFOsGnBLpXUJ304E=;
	h=Date:To:From:Subject:From;
	b=UhoEsNe/0KuOMy4BcMa56xwhN6f5d5iH7tQGUsWjBd5mYbSQXKudKrKGnv2aa+vib
	 cZvK27JVVBp9x1Cj2Y41lsKwD24/3D9M1D2nzQMdTJVGyel2lPAL+l/kqxygNhoifC
	 HpBXTNC/13PVEEOZ/X2/Yc0kKv3aCahGSYRME0wY=
Date: Fri, 01 Aug 2025 14:31:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kuba@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801213153.7FF09C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
Date: Thu, 31 Jul 2025 02:57:18 -0700

When netpoll is enabled, calling pr_warn_once() while holding
kmemleak_lock in mem_pool_alloc() can cause a deadlock due to lock
inversion with the netconsole subsystem.  This occurs because
pr_warn_once() may trigger netpoll, which eventually leads to
__alloc_skb() and back into kmemleak code, attempting to reacquire
kmemleak_lock.

This is the path for the deadlock.

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn_once()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

Fix this by setting a flag and issuing the pr_warn_once() after
kmemleak_lock is released.

Link: https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org
Fixes: c5665868183fec ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock
+++ a/mm/kmemleak.c
@@ -470,6 +470,7 @@ static struct kmemleak_object *mem_pool_
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+	bool warn = false;
 
 	/* try the slab allocator first */
 	if (object_cache) {
@@ -488,8 +489,10 @@ static struct kmemleak_object *mem_pool_
 	else if (mem_pool_free_count)
 		object = &mem_pool[--mem_pool_free_count];
 	else
-		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
+		warn = true;
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+	if (warn)
+		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
 
 	return object;
 }
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch

