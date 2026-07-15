Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381D4B8DF8
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139654; cv=none; b=I5qsPBYJEKNupiYPGyl/tnUOlzi7O8ijlxmak4AIY686UdlED1JLi3iZjz+fUpOOTLX+Mxy4ZIEkUL2WpIzYfuRfi8dq4G3BhHc+MdZJXCMPst+0ZHyKDoEsTcDuuUz7N2PmKUwm5L4f9P4uQcV3pMibaL5Rg3kNlNTxEPo2XwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139654; c=relaxed/simple;
	bh=sAVi1X4CBRP87MFxWJBTMonprGJ4BhJ+nH7Mrt0RrTQ=;
	h=Date:To:From:Subject:Message-Id; b=V03qVlf1kJs7HZouXStPuuiXJg11OJqxqXXxqlVgiqmB3yr5NL6gZHAK+qQv/j0NMp8UFtlpQJrpFE/gqn+KzEvm3A19O8/ntpNbNcazMgCQwCQLj1ZW4MR5fZPnNlm+g7NI4eoMr3TgNCtlzkifnLT5VSMyp9Lqfkbstx+JOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1U9/uDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1U9/uDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8913E1F000E9;
	Wed, 15 Jul 2026 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139645;
	bh=W3G0HcJm+z24XRc08XKTGc69WlNiQVa2gXu/BFjcKK0=;
	h=Date:To:From:Subject;
	b=t1U9/uDkbCA5Ur9HAWwAqF4jL8WRI3KChvqZYzGKs8g1JVmLtRyAjueJBQMkR0dyv
	 ZKducJPErR/o6PpJWKUwVdsMSApDVY7i7i1fuijxz5EtDkFHSUz1rdvXc3eyTtkLEy
	 6pRl/jNgCbV/4NexkF264flklj6rEauoGfeqJhOw=
Date: Wed, 15 Jul 2026 11:20:45 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-enable-lock-context-analysis.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182045.8913E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: enable lock context analysis
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-enable-lock-context-analysis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-enable-lock-context-analysis.patch

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
Subject: xor: enable lock context analysis
Date: Wed, 15 Jul 2026 16:47:32 +0200

Patch series "misc lib/raid/ improvements v2".

This series improves the benchmark-based algorithm selection and adds
kunit benchmarks for both the XOR and raid6 libraries, and tidies up a few
very minor other bits.


This patch (of 8):

The code doesn't have any locking, so this is trivial.

Link: https://lore.kernel.org/20260715144825.95432-1-hch@lst.de
Link: https://lore.kernel.org/20260715144825.95432-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/Makefile       |    2 ++
 lib/raid/xor/tests/Makefile |    2 ++
 2 files changed, 4 insertions(+)

--- a/lib/raid/xor/Makefile~xor-enable-lock-context-analysis
+++ a/lib/raid/xor/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 obj-$(CONFIG_XOR_BLOCKS)	+= xor.o
--- a/lib/raid/xor/tests/Makefile~xor-enable-lock-context-analysis
+++ a/lib/raid/xor/tests/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_XOR_KUNIT_TEST) += xor_kunit.o
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

