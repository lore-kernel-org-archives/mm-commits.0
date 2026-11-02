Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793597602;
	b=uatrL8DIbjZhGNALf9a1+2jGqZhHuw3tCwzMOdh8lgOuQBP6L9gt1QmUeOwesnX3WnaT
	 8a1u2cwD5hrklzJC2MxAkJxVS4K1pSmX/ufTI8SUmNp/HxwW0fEqachKG/BtSBnufjYqI
	 xlumgrA5MZ4XIoUQXIv39VZhuEA0Bollx/7JgSsuzCNT+KEiRt3CUmwWM7lkg4eSdadIf
	 nR5ZGmd6PjBOk+rViZ6mZZFmnl/Q2PVbJN1Px8VGo8jf+IKYhAeGZfhbUkL//EbuLWAR0
	 R2oFo6KxIcVDs8dKlN8WWx0wLl1TsHYEWlfqcmPEAprFSmaYWtzZMY73nmq1qlLqgmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793597602;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=r88G5NBnMnmcfdv6fh8gE8hrTWNwkgndeIDVkATE0e8=;
	b=tVZsdmVf1dVa4nZQNVBAkizKTw7v7VDSZy/wb9Zp1wjJ0+ImPh3lqmk/eUe6uYKnVHgY
	 5KbsQj7F3kcaXytvC3Tz2RP7A3c9AOERgxbTXdTKbL3Oim5VhGB+PuMH1/3OAaY6eqbc8
	 Xa6aSwIJA64XnUMlzKPss+t27l29M2nnAf1p8p4gRUAQzDQsHArePXR9G09CXrXA4K30a
	 jjnpqO6VV4+kAMoaUcKZv79uX7EhB9yWYAb0tjAMxtZGxzEEicUUYfojlEB9tkafYN+sc
	 nNTKEfwv9neSg0keULdhh9QxEjkqgpKfYD+wedWmLkH1FHXnSjD2jNzwgo1IUiFVRxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vF7PtJgM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4D6606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 05:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vF7PtJgM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2521F000C1;
	Mon,  2 Nov 2026 05:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793597601;
	bh=r88G5NBnMnmcfdv6fh8gE8hrTWNwkgndeIDVkATE0e8=;
	h=Date:To:From:Subject;
	b=vF7PtJgMzHlDNtu9bxp0sJaWZqJ1g4FezprFGHzPNs8+eVnf4yBD498776rWP+9my
	 fjrxV/uJSIFp6Tclrhi0KE+vgmuUu+xVYfpunlu+gxKboAAo4Yh7Rqde51My1+bqIA
	 JhxMB/8/ztv1REF4sjsEVfFf9TMuBcZLmbqQ2dPw=
Date: Sun, 01 Nov 2026 21:33:20 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,hughd@google.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-clamp-negative-used-block-samples-in-statfs.patch added to mm-nonmm-unstable branch
Message-Id: <20261102053321.1D2521F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: shmem: clamp negative used-block samples in statfs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     shmem-clamp-negative-used-block-samples-in-statfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-clamp-negative-used-block-samples-in-statfs.patch

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: shmem: clamp negative used-block samples in statfs
Date: Wed, 28 Oct 2026 05:18:26 +0000

percpu_counter_sum() holds the counter lock while scanning the per-CPU
values, but local updates can still proceed. Concurrent allocation and
freeing on different CPUs can therefore produce a negative sample even
though the number of used tmpfs blocks cannot be negative.

shmem_statfs() subtracts this sample from max_blocks, reporting more free
blocks than the filesystem's total. With a one-page file being written
and truncated on separate CPUs, GNU df reports negative used space, for
example 67108864 total bytes, -28672 used and 67137536 available.

Use percpu_counter_sum_positive() to clamp a negative sample to zero.
This keeps the existing best-effort accounting in statfs and does not
change allocation or limit enforcement.

Link: https://lore.kernel.org/20261028051826.23058-1-dennylin0707@gmail.com
Fixes: 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for used blocks")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@kernel.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-clamp-negative-used-block-samples-in-statfs
+++ a/mm/shmem.c
@@ -4018,7 +4018,7 @@ static int shmem_statfs(struct dentry *d
 		buf->f_blocks = sbinfo->max_blocks;
 		buf->f_bavail =
 		buf->f_bfree  = sbinfo->max_blocks -
-				percpu_counter_sum(&sbinfo->used_blocks);
+				percpu_counter_sum_positive(&sbinfo->used_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
mm-migrate-untag-addresses-when-querying-page-nodes.patch
fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

