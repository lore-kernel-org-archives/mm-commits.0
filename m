Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9B73382F7
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299697; cv=none; b=ZDrF7RA1AliDbxLdSH+H0Vq5FGeLEuayFZ5dBpXeggiY14L6nktN28mYTLFM2+xUCbDM/xxXGUjSCdwNMQEolKbmI68i9ndX1emBUpsoHGBfjV93hopPqNqkbOl1qTZ/dlrrYWmFAf5VH01s7dt86i9r6UDP6D6eeXk6OE4aKCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299697; c=relaxed/simple;
	bh=JgW00RJ7pbr5ttqPxBvF/z6qAFG37Hs5FV9JZWLm8VU=;
	h=Date:To:From:Subject:Message-Id; b=mDRczILpOQ9jp5CZQSyysqhHFVUFEHNbtDwwXrCHnddDW3iie7OTKs8hDVo7Kw4RwGR4AKtD83+8gEa5R4YmWQaqAAgVRApvewxZRvd4MMk63yfSnjeFZpT0ADdOt916TeR8K+QOP1+PrN9DKLzCNElTfLwQnTksj6SeJ3QX5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uXQikyCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uXQikyCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8C61F000E9;
	Tue,  1 Sep 2026 21:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299695;
	bh=KL3bWPNNj36B6axjrHB70XJXD6zlGlJ3RhAUmRjreXU=;
	h=Date:To:From:Subject;
	b=uXQikyCSq0qmg/fgd1MvP5Kf1U6tbWWGD2ihQs1u4F6RiZYIWP+zCfMb+3ChPu6w5
	 pHiqeYPLhwRVixrqiNZjiwLEkgF6Gdy0LZfPLDNk4IPersZJG+9fzhwl66ClzbZu91
	 C4Z2h6DXr7u51ida4aKXtPchiNfqCPZY0ABy9lZU=
Date: Tue, 01 Sep 2026 14:54:55 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch added to mm-new branch
Message-Id: <20260901215455.9C8C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: remove unnecessary return in pcpu_populate_pte()
has been added to the -mm mm-new branch.  Its filename is
     percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: remove unnecessary return in pcpu_populate_pte()
Date: Wed, 2 Sep 2026 01:53:04 +0900

Since commit c6f239796b55 ("mm/memblock: add memblock_alloc_or_panic
interface"), pcpu_populate_pte() no longer has an error label after the
return statement, so the return statement has no effect.

Remove unnecessary return.

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-5-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/percpu.c~percpu-remove-unnecessary-return-in-pcpu_populate_pte
+++ a/mm/percpu.c
@@ -3178,8 +3178,6 @@ void __init __weak pcpu_populate_pte(uns
 		new = memblock_alloc_or_panic(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
 		pmd_populate_kernel(&init_mm, pmd, new);
 	}
-
-	return;
 }
 
 /**
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

