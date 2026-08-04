Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798793E8C74
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816332; cv=none; b=fLqcInSCgWuHXe9FK3Ar4HILascAMCFJitK8UjUR5HI2ykq7oYCini1OqS6akNInlwbmfXOB8wjnQBX+88PR6JbF0U4eVrEQqtplKDL9F2HSCC/3Lq5ldZj3Z9uxU4fFbKjLveuLct66kI/fgKrNqiFBKdTp8/wfrhNluLpLnUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816332; c=relaxed/simple;
	bh=UONm6LQlsXR9q3tFHd5eAl8KklwFrtQGfsazUVrrXnE=;
	h=Date:To:From:Subject:Message-Id; b=Puq+Z6FCAwBfuON1t6W+8t0BtqrADRbnnUmhFS4cfQVbpg12YJ5fc5PYGN1XnMBy3qen866aVOeZ+iXQzSaV8hBTo7WBNRzRZDcSinn5TJZ7NT4KlALvL1Odspun+q7Jlicr0axyz1ZfFYQHb0y6PRxxWnMdHjHgm85OO5H4B8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tGr82X6z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tGr82X6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB211F000E9;
	Tue,  4 Aug 2026 04:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816331;
	bh=qsjkfzFCwFqm5OL3ATYQ7ViH8+da2tOC0sabXBmXZpw=;
	h=Date:To:From:Subject;
	b=tGr82X6zL8eWcLxR7mFhWZY5KN1CCN8gaO9G9/BWIUwX80haC+qI/dy4u0yPjshtY
	 vLID/owhRUlvBD5vGShjetYwksrvGWD1HjYDrs78gzd8/0PDu8j9gMVUzLxhzBS0fo
	 XZGeQUAjxLPEbhF8crpyL8wpu6mFEi/bx6bu5j6s=
Date: Mon, 03 Aug 2026 21:05:30 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-enable-lock-context-analysis.patch removed from -mm tree
Message-Id: <20260804040531.3EB211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: enable lock context analysis
has been removed from the -mm tree.  Its filename was
     xor-enable-lock-context-analysis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

