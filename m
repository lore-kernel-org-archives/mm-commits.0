Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793597628;
	b=MwldtqfbfuS+yU5ZEqWMZe04/Z0c2Kr+f87xxa3d8rRhRUQjQrKQTgw6ye0gg4W7lx7I
	 r/yU0uRqYaCDXuobstGUGmvCVxSUrwKEelXcPMXIGMPSrxAooYbbxevcUtrV8fRZe1DLQ
	 aGBlLFtY6uWRJvTo9ssi2u6+fVVuI5eu6jbmMveuVvW5J+c1XZHjTISGAUJCTTwH31RAi
	 quc450ysdLUdPL3oxOSwwDn06qdYAtILnUTuhCEKawB1bD5k50Yi6oQIp4bpGraC8n9uB
	 oeYFyN+S/i8gMbzVJZZm3KL+WZar088Uw3HtQM68W4sskUWgRqVInhuTrfi9vUjdlOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793597628;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KZrr7dxDjC4+3eo6g2n9yj+6WYUVhDU5NWrI/qmnZ0Q=;
	b=rqkeoEAbD6K9n+9ob05007cnfpv/EhCwmv8bBfLnsS/6cIWPGd7lG+57f9+/s3sga3Iy
	 sv2lT92Nmbzgh24TfjcJreCDKJtK8RWfXvowL9FmBFX6h7jdV2aUV5gfC241cvHPj1JaK
	 zLThj80k6Wg1nzq1+oTtvT6NriC6GCDYbRuV+vE6JzNSt8OeeWFQwZz97j9xWdx03pcZG
	 VRUqBDTJKb2UX+SpMPC51Ue87Q4eRRoLXDRc9+84vW7SlXJaE7DBJM6TKYAaN4+4sXZ+7
	 XT5+cMIw7m2D0tx302qUY9791kHuMLln8W8WraZ3upoWjklViOka6WT3reG19gy12qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mnTVVdsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B71606A324;
	Mon,  2 Nov 2026 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mnTVVdsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B161A1F000C1;
	Mon,  2 Nov 2026 05:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793597627;
	bh=KZrr7dxDjC4+3eo6g2n9yj+6WYUVhDU5NWrI/qmnZ0Q=;
	h=Date:To:From:Subject;
	b=mnTVVdsQb1aXjUiUpJjbbaC3SpIyva+lY085Awc+6EKOjAiFHR79svuynYAOr782K
	 zfsCZtRVj7jbUunvn/VPc0d5D2iCNkNJWHGReNG3qF+AXZDIT2dHTQc0GyVdddq3bX
	 3rF/pX7vHWAnndfI1fYCyYC7WNOuJR4Bk4A5c04o=
Date: Sun, 01 Nov 2026 21:33:47 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,
	stable@vger.kernel.org,hughd@google.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-clamp-negative-used-block-samples-in-statfs.patch added to mm-nonmm-unstable branch
Message-Id: <20261102053347.B161A1F000C1@smtp.kernel.org>
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
Cc: <stable@vger.kernel.org>
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

