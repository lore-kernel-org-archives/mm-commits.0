Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA60A4C77BD
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139665; cv=none; b=Qa92M9E5PAARRfCB7vWkvQwKXTJ5lWdbysSwMM8gUZfg0XDMntJF/w2FrwkC34nqK6+bliGlcJB2UyeJu0c3Q0WlDsnSzQmkh4r61yawS1CrO6TL7FeUTC23mLIgXrlaks8yeUXEWqtVlm9ooSChFNMSzacTIyyweD3+bLdwYgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139665; c=relaxed/simple;
	bh=nEuSZji+d2bBcu4Umxlt39p+lZ8LffJqaKmQHaG7ub8=;
	h=Date:To:From:Subject:Message-Id; b=lVuiVlyA2FovfKbjlk7RSDij+ZxjYSK1KLjcFlu90ku7dYVncni6fcJy7Qs+se8eJcFJQkLHzlay66yZkxmUV1xip0llVBSnOyK8AN4IlJAtrhYL6oVR6fLB1GF7FSSzOGVU5l8dwt18V7rOxmDL2ER8jkwH9dcYEqeo7EefBzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YxKNvuFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YxKNvuFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6101F00A3F;
	Wed, 15 Jul 2026 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139654;
	bh=1xZMlS+hSaWBLRTWpwMQKr39sLfpjVPRUHciVC6x4Ug=;
	h=Date:To:From:Subject;
	b=YxKNvuFGyRHj7BuEm6eJPFaGonQDwnU5zfXPIHqb/78OcG06VIqZEeIwhdqb4HB4I
	 XJ37JvqEMgntR5SHKub2jWPAaq6CWQlnzJpL/dnRsyE2Qc/nW/l1K67GI5r/1FrqfE
	 tuvGZLB5Ye0FDQig7WsQnqcmvw2gux9FsoVH2DFg=
Date: Wed, 15 Jul 2026 11:20:53 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-enable-lock-context-analysis.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182054.2E6101F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: enable lock context analysis
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-enable-lock-context-analysis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-enable-lock-context-analysis.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: enable lock context analysis
Date: Wed, 15 Jul 2026 16:47:36 +0200

The code doesn't have any locking, so this is trivial.

Link: https://lore.kernel.org/20260715144825.95432-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/raid/raid6/Makefile~raid6-enable-lock-context-analysis
+++ a/lib/raid/raid6/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
xor-enable-lock-context-analysis.patch
xor-improve-the-runtime-selection-benchmark.patch
xor-kunit-fix-a-spelling-error.patch
xor-kunit-add-a-benchmark.patch
raid6-enable-lock-context-analysis.patch
raid6-defer-implementation-selection-when-built-in.patch
raid6-improve-the-runtime-selection-benchmark.patch
raid6-kunit-add-a-benchmark.patch

