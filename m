Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E55B67A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724809687; cv=none; b=iTP7HY75U/naDmQHQH3OlqSTK0neJ5V3recLavvYIjTtjVuLDm+aav4RzSHbQZjMNfsHVW2CjGPqESuBVQAejaMGUEKjnV4Iu2Vm6nNdYIqGXp+Ml/lkJyWJPelf9K2KLzb4Ys6swOGssVtWQCS+tHNb3QvL0H6/cNxarqyW8w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724809687; c=relaxed/simple;
	bh=rRVlrtJE2aMVGhA+nmjF7PIwjzsn//1GBMlxsU/6yi0=;
	h=Date:To:From:Subject:Message-Id; b=Uy9jCH7xS2OpEB5PfCaznXXA87uzihwmNocm0CNgcfnmSgPXb/AwRO36+nHnBMbnYW536R2COCUvitBMnbFtsXy4LUJFqXBzrXzus8UC8TkNQoWnmOg4JWYw6j1R8SazWZdCkMpSABM/dNMzl1VNXU80bnWxjmmBD6qZl+kwOzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S8BYozS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S8BYozS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E9C32786;
	Wed, 28 Aug 2024 01:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724809687;
	bh=rRVlrtJE2aMVGhA+nmjF7PIwjzsn//1GBMlxsU/6yi0=;
	h=Date:To:From:Subject:From;
	b=S8BYozS6J5j3wLJMzILbdk6jfa/K2VTLtGQxQ6mGUDM/Ln3kkf4Ixmagho1MierbG
	 J0Rat2fnQGFCBJ7JAUeFvMaEnYWLyVP1PDeXyNu3XA6RZ/JqVWluW8AuCfJa/H0mCC
	 5n8biRnBD5cw+alMFjVaM/kTXRl7E2HEuUqMhkAk=
Date: Tue, 27 Aug 2024 18:48:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch added to mm-unstable branch
Message-Id: <20240828014807.5D4E9C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
Date: Sun, 25 Aug 2024 15:31:21 -0700 (PDT)

Fix all the
Unexpected gfp: 0x2 (__GFP_HIGHMEM). Fixing up to gfp: 0x1120d0
(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_HARDWALL|__GFP_RECLAIMABLE).
Fix your code!
warnings from kmalloc_fix_flags() from xas_split_alloc() from
shmem_split_large_entry().

Link: https://lkml.kernel.org/r/e2a2ba5d-864c-50aa-7579-97cba1c7dd0c@google.com
Fixes: a960844d5ac9 ("mm: shmem: split large entry if the swapin folio is not large")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/shmem.c~mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
+++ a/mm/shmem.c
@@ -1994,6 +1994,9 @@ static int shmem_split_large_entry(struc
 	void *alloced_shadow = NULL;
 	int alloced_order = 0, i;
 
+	/* Convert user data gfp flags to xarray node gfp flags */
+	gfp &= GFP_RECLAIM_MASK;
+
 	for (;;) {
 		int order = -1, split_order = 0;
 		void *old = NULL;
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch

