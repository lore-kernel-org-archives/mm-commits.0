Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853E3595D;
	Sun, 15 Jun 2025 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750026448; cv=none; b=kXcAqPbis3+s6C7dv+MU4mvGmrKyjz2zj6qqsvjb/o29ms8eNPGBjMwObJegjBoKu9dd+4YfMllTORnwvBGBFCHRlZDJJVjs1TzkKoNz+BBSl65/HV7DxUKxnugMgLH+eXgte3+LmDGYyw9Dk63ehjrN+jLhBnLib93REa3x5CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750026448; c=relaxed/simple;
	bh=Ti2tWXgYquKm+hm4cVFqUv6NDx2Lay7K6lVwWq1TWiA=;
	h=Date:To:From:Subject:Message-Id; b=EQ12DTWfd9ibtCsY6UeUtyPFFz4vGw4DXw1S87LhoJDKcNqJCt/c8IOiU7rHn1FhqSzF+SiVmK6xI747KgtALzAdf4c93PcW6HSF06Q3buUhputzFZOlPT/zW30FUFFWcoSLk7cXkSCao5gmhI2S/fRstLZUOjPN1UhhIrk/RAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Esajpv6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Esajpv6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB31C4CEE3;
	Sun, 15 Jun 2025 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750026447;
	bh=Ti2tWXgYquKm+hm4cVFqUv6NDx2Lay7K6lVwWq1TWiA=;
	h=Date:To:From:Subject:From;
	b=Esajpv6ivdsUsvkq1QjWradxjmvukWRk9hIs1Stx0GWaZk5szzZ+ArunZJRSorfyg
	 ZJBDPydWWPxNxmI+89S9tj24X8HQEe+XADH0m3T5OmQfQLDggzB8dQXC/uSb/wtPS9
	 JO8Dkq6rCDrG+NzT2AXeiXzMLqHM5rCQ1bskK7S0=
Date: Sun, 15 Jun 2025 15:27:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcache-remove-unnecessary-select-min_heap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250615222727.9CB31C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcache: remove unnecessary select MIN_HEAP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bcache-remove-unnecessary-select-min_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcache-remove-unnecessary-select-min_heap.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcache: remove unnecessary select MIN_HEAP
Date: Sun, 15 Jun 2025 04:23:53 +0800

After reverting the transition to the generic min heap library, bcache no
longer depends on MIN_HEAP.  The select entry can be removed to reduce
code size and shrink the kernel's attack surface.

This change effectively reverts the bcache-related part of commit
92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API
functions").

This is part of a series of changes to address a performance regression
caused by the use of the generic min_heap implementation.

As reported by Robert, bcache now suffers from latency spikes, with P100
(max) latency increasing from 600 ms to 2.4 seconds every 5 minutes. 
These regressions degrade bcache's effectiveness as a low-latency cache
layer and lead to frequent timeouts and application stalls in production
environments.

Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20250614202353.1632957-4-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Acked-by: Coly Li <colyli@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/bcache/Kconfig~bcache-remove-unnecessary-select-min_heap
+++ a/drivers/md/bcache/Kconfig
@@ -5,7 +5,6 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
-	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
_

Patches currently in -mm which might be from visitorckw@gmail.com are

revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
revert-bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcache-remove-unnecessary-select-min_heap.patch
lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

