Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC421401B;
	Tue,  5 Aug 2025 20:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425774; cv=none; b=ug5WqpJ+rJ19V6tpKssN214YfQ4+I3t+fy3R3ppq2rILzrVb9+MQT/Aocyl6C+P2FlqcqsLJ+jN/O2fDykEtlXZvl2F0ixYAJuZp7aAzsDqQqFzRRtHptOarbvnUeGi4+gsHmExwwlRcWiCLcT93YxS5aq+b0Wy9IuS/1pis4po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425774; c=relaxed/simple;
	bh=7HLKh9zGLKug3K1Cl2Db9nPGJvj8WxN/w2kxB2ilzQk=;
	h=Date:To:From:Subject:Message-Id; b=qFiZdD/NpOqVYgpTmBTQGBTBYLs90ZfpOaLlR81ZX3rjUkA3cmsOmV0OPJG2LzA6W1Pvfr9AGDgabGHAZS5bhrF0DDyJxcyJ6EFEAzzM4L4yFhWm96WLaUpAWMCPW3xS07heH8eLvyWuwmZ6baexfpdH1i/jfMyUV8k3frCSttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p4UkwRec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p4UkwRec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCF4C4CEF7;
	Tue,  5 Aug 2025 20:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754425774;
	bh=7HLKh9zGLKug3K1Cl2Db9nPGJvj8WxN/w2kxB2ilzQk=;
	h=Date:To:From:Subject:From;
	b=p4UkwRecg4tCCOV6OOLomCQQHTHGC77m39tL++Ygc3FQtbqJ0Q+JVpJ1h0Pp1NAhc
	 8E7s2AQHRC+2FyH6QU0SawK2ZcxWVjbSE3AXAQ3xL8xGgMn5akolwkQihMpn9oArZp
	 z6okjrAe8zhjHZv9c+X1cvf+XdFHGzy9JgKSCUcw=
Date: Tue, 05 Aug 2025 13:29:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kuba@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch removed from -mm tree
Message-Id: <20250805202934.3FCF4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-avoid-deadlock-by-moving-pr_warn-outside-kmemleak_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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


