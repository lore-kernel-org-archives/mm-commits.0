Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC17741BA61
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139662; cv=none; b=O7mx3SjkjQtuIRr8rugwrPl0Z5vhwgL9czQ6QojcKjOjAoLKZmcgu19jMqoKiHxns2+9YMRXKmFDds7sCHytBnPfaA7nPE125Vhcs6N7bERmxpa09UKM1Z45Li747GoFzvqY2OEc1JxlAdUzWnJN2b6HlHxXXkuCCZB+LpHsQ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139662; c=relaxed/simple;
	bh=taLmEAzur9H/6Q0Zt0G2mRsSLHjGZ69WqfE8AXTKYt0=;
	h=Date:To:From:Subject:Message-Id; b=mQEWiWeNoF8jg7OmD/4WUlG3qdKJ2eWUWa6TuNlI5RQzc7VO5+v3h5N4nZSbR/7+i7w3zLRhKj21k/RkX7VK5BAywwxUKFSXpX8bo5YwX70eJl3bD8Qz84BZgmy72h42i1b5fVDlt6k4pCCan3BPBNYmZhefM3AMtYrkcYdMzSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hnZ+N0Le; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hnZ+N0Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4BE1F00A3D;
	Wed, 15 Jul 2026 18:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139649;
	bh=4W7+wzg9zApw0qiMuCmDDzf6Oh5J9+gv8aZBcBwY/mE=;
	h=Date:To:From:Subject;
	b=hnZ+N0LefVdBpUJ89EP3EpqxADdGyPECGKcs/JHljpDaETRXLWJeJcvBU9NJk/iIi
	 ymz6zs5GL0S617mg7SS7rFRz8HxSN1kif/WzK1tOVJYdApMXqVwfU7RpOcMWwwv1Ko
	 h+X6/rFtELNrR0nE9Tr6hLcNEzBQKDWVqSXNvNMM=
Date: Wed, 15 Jul 2026 11:20:49 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-kunit-fix-a-spelling-error.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182049.CB4BE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor/kunit: fix a spelling error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-kunit-fix-a-spelling-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-kunit-fix-a-spelling-error.patch

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
Subject: xor/kunit: fix a spelling error
Date: Wed, 15 Jul 2026 16:47:34 +0200

Link: https://lore.kernel.org/20260715144825.95432-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/tests/xor_kunit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/raid/xor/tests/xor_kunit.c~xor-kunit-fix-a-spelling-error
+++ a/lib/raid/xor/tests/xor_kunit.c
@@ -85,7 +85,7 @@ static void xor_test(struct kunit *test)
 			xor_generate_random_data();
 
 		/*
-		 * If we're not using the entire buffer size, inject randomize
+		 * If we're not using the entire buffer size, inject randomized
 		 * alignment into the buffer.
 		 */
 		max_alignment = XOR_KUNIT_MAX_BYTES - len;
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

