Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7492433BBCD
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299691; cv=none; b=lxhErPGmvKj7IYqi52AS0j2uIWxRUI1QQEIr5yuL+IjIrBIBhdl+AIfpH/S1bzdYpc6vVNNS7eSW2lsko89vD4lxlavZt6XkoI/A5pFVvc0zrZ5c3SQez0zsPV5ihnS9iHMa5sr5HiF49JdHYvqp0UhhEpMHX3+bFsCzVe/G2Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299691; c=relaxed/simple;
	bh=cyIHjCkVbe+W9d5Y3U9Wy0udBGAwhQaNW1x7Rb2LZXQ=;
	h=Date:To:From:Subject:Message-Id; b=CHvvDyRyRq/QYg2OvXUCjcQn86bsATvkMDrfEcz0xfuHbNMtwccTxtAFxrCkTvK39bPUEdmUVUiun3sisCB0ncz/yybZo4LrNqjE3Oj5juuVz2X5aUqJU7ZDkYbC5O9OyZR2+LBWiA+Z87iWsL7G/b2f0VoQjrgRVkq91ckdogo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XaXWWVmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XaXWWVmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C501F000E9;
	Tue,  1 Sep 2026 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299690;
	bh=AGwtqv5v//unSl9BQcxearFojauPYz0MBY/aX4Kt4vs=;
	h=Date:To:From:Subject;
	b=XaXWWVmSOdB7g53P6q3RzoBPi7CcixnbP74Jagh7slQjEr52r0jpmdkjONQQVKOmD
	 +HauHfCZrsD29KgbxhssXQ7ShVGbygnfoqN5vy9EZjymiHUs0vHuwfHrKcZpeKHn90
	 IiUK+dN4Rt8QaC2WF8viTTdBK5VKtkRnE6ac43lA=
Date: Tue, 01 Sep 2026 14:54:49 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-redundant-assignments-to-bits.patch added to mm-new branch
Message-Id: <20260901215449.E4C501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: remove redundant assignments to bits
has been added to the -mm mm-new branch.  Its filename is
     percpu-remove-redundant-assignments-to-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-redundant-assignments-to-bits.patch

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
Subject: percpu: remove redundant assignments to bits
Date: Wed, 2 Sep 2026 01:53:01 +0900

Patch series "percpu: remove code with no effect".

While reading the percpu initialization path, I found some minor
cleanups for unnecessary initializations and an obsolete return
statement.

No functional change.


This patch (of 4):

pcpu_chunk_refresh_hint() and pcpu_find_block_fit() set bits to 0 and
later call pcpu_next_md_free_region() or pcpu_next_fit_region(), which
unconditionally set *bits to 0.  Nothing uses it in between, so the
assignments have no effect.

Remove redundant assignments.

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20260901165307.1026248-2-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/percpu.c~percpu-remove-redundant-assignments-to-bits
+++ a/mm/percpu.c
@@ -758,7 +758,6 @@ static void pcpu_chunk_refresh_hint(stru
 		chunk_md->contig_hint = 0;
 	}
 
-	bits = 0;
 	pcpu_for_each_md_free_region(chunk, bit_off, bits)
 		pcpu_block_update(chunk_md, bit_off, bit_off + bits);
 }
@@ -1122,7 +1121,6 @@ static int pcpu_find_block_fit(struct pc
 		return -1;
 
 	bit_off = pcpu_next_hint(chunk_md, alloc_bits);
-	bits = 0;
 	pcpu_for_each_fit_region(chunk, alloc_bits, align, bit_off, bits) {
 		if (!pop_only || pcpu_is_populated(chunk, bit_off, bits,
 						   &next_off))
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

