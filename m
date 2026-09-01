Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4017D3382F7
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299695; cv=none; b=GJ/FWCKXNTHHIzoMf5X5xLKDb143uQMqPG9zKdJxOUVvXwO8FxrSRc0c0c5OTrMsyTkkyMQPJjqZKROsAJ2XDBpQ0reuIuM/7Lno375yFvMAaPw31/PDYNNMF3JLafaE6pVnSiwWdu4KsN3U9AxRvZektqmIyvnjAZG0KXDKF2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299695; c=relaxed/simple;
	bh=KyTHS691hGiVUCVrdlfJ2w9i6sqJxw8RQ2qQfTx5KUk=;
	h=Date:To:From:Subject:Message-Id; b=qXmJDBpBdwBl07MrX5Y47x0yW79gjIRuPpwKDPo0M/O3OX6gRzVbh9HtB1O7DIu0q5uBah2BslGcQb7Bt+dejZ2/GZPiKwbi0N21gdFM6tunJzA/JqkTd+vLBZ8LeFQOpW7l96i30UXP1un7JlSP+0oK1SJvFpfE5mtwQWL0WJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZLzK8KMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZLzK8KMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7911F00A3E;
	Tue,  1 Sep 2026 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299693;
	bh=0XoKbWmx7+JChmQU5aBlDBR6DzdFWrAvF0afem2+K90=;
	h=Date:To:From:Subject;
	b=ZLzK8KMRaFcfCv5/z++FL3DpHKFW1wALwF/gElEOA/EEHOQJCKaD4NTUsxDuF4B/h
	 UHLNPXin60LNYWF0MWvjrFerwe5DyrSlSAd9ECVvYPksyOW6WEjvX4Sn1Id6lPWYMe
	 VmK5+Vc8+3nXRMq2Ki0AF4cosWnDg971SEikfMFg=
Date: Tue, 01 Sep 2026 14:54:53 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch added to mm-new branch
Message-Id: <20260901215453.BB7911F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
has been added to the -mm mm-new branch.  Its filename is
     percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch

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
Subject: percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
Date: Wed, 2 Sep 2026 01:53:03 +0900

pcpu_build_alloc_info() clears mask and unconditionally sets it to
cpu_possible_mask.  Nothing uses it in between, so cpumask_clear() has no
effect.

Remove unnecessary cpumask_clear().

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-4-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info
+++ a/mm/percpu.c
@@ -2828,7 +2828,6 @@ static struct pcpu_alloc_info * __init _
 	/* this function may be called multiple times */
 	memset(group_map, 0, sizeof(group_map));
 	memset(group_cnt, 0, sizeof(group_cnt));
-	cpumask_clear(&mask);
 
 	/* calculate size_sum and ensure dyn_size is enough for early alloc */
 	size_sum = PFN_ALIGN(static_size + reserved_size +
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

