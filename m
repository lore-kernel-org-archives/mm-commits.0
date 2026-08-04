Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90814421237
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816334; cv=none; b=qkdfqQwgZQpFfbHNA91jM411gCCT5SLqyPH2DVSHAG4b1OluX5pfuMvA39Q+uF45yvGLIVggAwK7cQvyEo+JrN9SwvMIoudgUEcphABQlfLeSblivT3wmpTLc4vDFdPK97deyKBD3IOKzvgpX6ZBxm7dvI78Te79R/DkKpeN6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816334; c=relaxed/simple;
	bh=N0RL69Bl3l28fo9+btOsqUsO/tkxZ0Ph7h/lJUlDZjw=;
	h=Date:To:From:Subject:Message-Id; b=MQ9TFQP6E+I3KpJSfjaZeX/EKI6dm0rst0dcbAy3NyM6/OxzgB720t8J/p3gl/w5q0/i0VDRSNgfv8IfhEFzwYmNtsncA0Yiy7m8swhezdq5x6ouu48bkT7v8+nZwOvkgRqbTz8k13gacE9E/PFEt3SGK4yCRlSWsvGl8oEgPjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxIoFXKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxIoFXKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F1C1F00A3A;
	Tue,  4 Aug 2026 04:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816333;
	bh=+fndB0nVnirYc9A31tbW5HBBewXzbcoj5xmNw4BWZZg=;
	h=Date:To:From:Subject;
	b=ZxIoFXKNeFiXffiWVx4E0K9HwZwVYJKsVIyu07q8l/3Yp6OK/CJe5ITnuoqFBDhl5
	 +2NO6omk57xYdkvHXS7THGfH8OoLNipvPq3xJlJR8JSf5QogfU/mTHnNu51F/LlboJ
	 2TkMPSDRBleOoHHBF5CWkUtpmS5kV20C2K478w0U=
Date: Mon, 03 Aug 2026 21:05:32 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-kunit-fix-a-spelling-error.patch removed from -mm tree
Message-Id: <20260804040533.65F1C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor/kunit: fix a spelling error
has been removed from the -mm tree.  Its filename was
     xor-kunit-fix-a-spelling-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

