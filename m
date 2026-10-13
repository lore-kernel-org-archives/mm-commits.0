Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAFA481A98
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865979; cv=none; b=fWF5XZJAlurPhRxOgzb1TyyNlcPUFKMfYKVosZfZ1a8a0MAB7NYQbmudVbgRdxKbIH4xMk9Bw5JgRfIiV/hPaPQzQYIaZwF7bH7MT9XpdKcLD5CfEZFV7qZmxFLhNYlFMMICIFrcdpMIJ05Nqe7cTGdD77UUVJoMwc5xq+e/21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865979; c=relaxed/simple;
	bh=f6ucxPB2hrvApcCX9vlDj+VXSVGPrDY04nLYkMuKZnk=;
	h=Date:To:From:Subject:Message-Id; b=MZHGUYoTO5v9da3BkIJoHrfzEsCq2iKxjhx7uDRxHfhln1+36YlYojJkGnNWtUbunVi6Af30pMrhAUo55n4CQurshwp0TLcEBDHXZR3eH4gUjB2hNuQCgkESZFHfg+gWklKg4q5ivpGl0dB3tj16y5arWYb7sN+sJr/02useB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YeKgT7hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YeKgT7hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7B71F00893;
	Tue, 13 Oct 2026 04:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865977;
	bh=E8tlPVzumBBLcsqTrfeMIO5oRtB70JjdMyg4UJOJx8Q=;
	h=Date:To:From:Subject;
	b=YeKgT7hQaLrUJj5wBvGYBy5PE5GEFNZjynEIpXCvhjL7XRnu5Xz1Hm1NZqxQFv1w0
	 BxbM1aRdknvoqTxRQ6cBF9ScXkm5l6bZHWkNoSpsNCyREXyeH7CoZMZZjyQKimMhjB
	 /cObvO9hDNZSjlw1aY8WXA6uKzhG2KnKzGIYq1/k=
Date: Mon, 12 Oct 2026 21:32:57 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch removed from -mm tree
Message-Id: <20261013043257.8C7B71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: kmemleak: describe the metadata pool, not the early log
has been removed from the -mm tree.  Its filename was
     documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: Documentation: kmemleak: describe the metadata pool, not the early log
Date: Thu, 17 Sep 2026 06:47:35 -0700

Patch series "kmemleak: fix stale documentation and raise the verbose
default".

The first two patches fix statements in
Documentation/dev-tools/kmemleak.rst that do not match mm/kmemleak.c.

The third requires one more consecutive unreferenced scan before a
CONFIG_DEBUG_KMEMLEAK_VERBOSE kernel reports a leak on the console, to
avoid the last false positives I am seeing when running
CONFIG_DEBUG_KMEMLEAK_VERBOSE on a daily basis.


This patch (of 3):

commit c5665868183f ("mm: kmemleak: use the memory pool for early
allocations") removed the early log buffer in favour of a static pool of
kmemleak_object structures, but the documentation still describes the old
mechanism.

Fix the documentation by describing what the pool actually is, matching
the Kconfig help text.

Link: https://lore.kernel.org/20260917142210.90829-1-sj@kernel.org
Link: https://lore.kernel.org/20260917-b4-kmemleak-doc-v1-1-84fde6d1f749@debian.org
Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/dev-tools/kmemleak.rst |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-describe-the-metadata-pool-not-the-early-log
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -66,9 +66,14 @@ Memory scanning parameters can be modifi
 Kmemleak can also be disabled at boot-time by passing ``kmemleak=off`` on
 the kernel command line.
 
-Memory may be allocated or freed before kmemleak is initialised and
-these actions are stored in an early log buffer. The size of this buffer
-is configured via the CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option.
+Memory may be allocated or freed before kmemleak is initialised, so a
+static pool of metadata objects is used to track those allocations. Once
+kmemleak is fully initialised the pool becomes an emergency reserve, used
+whenever a metadata object cannot be allocated from the slab. The number
+of objects in the pool is configured via the
+CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE option. Exhausting it at run time
+prints "Cannot allocate a kmemleak_object structure" and disables
+kmemleak.
 
 If CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF are enabled, the kmemleak is
 disabled by default. Passing ``kmemleak=on`` on the kernel command
_

Patches currently in -mm which might be from leitao@debian.org are


