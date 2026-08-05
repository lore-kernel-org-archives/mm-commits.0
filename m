Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871A13C0604
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896729; cv=none; b=JMRrTt4GqSZbyb87Ii1BoF9auCBa9LC6wlsdMHGLqxTZkKG7ldrcfqqeJxIhLhfw23ONqT23V+JaPPifq4pwstER833+55tD8AobDg2yphIt6LAiz4HyehdzOFrwIjz5fFWvPhaLAmjGo6YfmA0FepR3mcnHTwwu28SmEqK86SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896729; c=relaxed/simple;
	bh=8iFxd4RrzRID/XuuG2Cv0brA3W6uNmlZw1h5qLr+RtU=;
	h=Date:To:From:Subject:Message-Id; b=Ri6o+FNKBmFFdx4UYsq/eFIQ6R4sySZS+P/k9SAaOydzSo/0qtmB8R48YFYNNGg4RLjN9EqmzEZWABTOKE9gzmqW8m++t+9zryMTn5/YR74sWqSPx69yWmSUV6Uwvb185/YW1bLVRrqM5olMTapE9H3xQjWNgl7Xcu9rf/u9Q38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nzsoK/Yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nzsoK/Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502F21F00A3A;
	Wed,  5 Aug 2026 02:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896728;
	bh=3EiUW55zHOIu5laRDoACZDqpBb0YYGcFeAdRdxkWJu0=;
	h=Date:To:From:Subject;
	b=nzsoK/YyouctQqF7ImLveRNtP0a/EDbkL57RXEE7btijc7JtvOL3xdMR8vNE8zLvh
	 w+Dmmqh+51etiwMU/K6HYDD8fZudNTAlMpxPYIon6F4UgYmR99oU1h30I1Q4YKpDDH
	 XSJDcHAvrpUt9dq2zPk6EQvvLCOp9KvhuHaOpsY8=
Date: Tue, 04 Aug 2026 19:25:27 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch removed from -mm tree
Message-Id: <20260805022528.502F21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
has been removed from the -mm tree.  Its filename was
     mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
Date: Mon Jul 27 05:31:14 PM PDT 2026

hmm doesn't currently build well with MMU_NOTIFIER=n:

With microblaze
https://download.01.org/0day-ci/archive/20260702/202607021433.DYT5fDqE-lkp@intel.com/config
(CONFIG_MMU_NOTIFIER=n):

mm/hmm.c: In function 'hmm_range_fault_unlocked_timeout':
mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Quoting Stanislav:

:  Documentation/mm/hmm.rst explicitly states:
: 
:  "Address space mirroring's main objective is to allow duplication of a
:  range of CPU page table into a device page table; HMM helps keep both
:  synchronized.  A device driver that wants to mirror a process address
:  space must start with the registration of a mmu_interval_notifier"
: 
:  I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER
:  is the right thing to do.

So select MMU_NOTIFIER if hmm.c is to be compiled.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier
+++ a/mm/Kconfig
@@ -1252,6 +1252,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

