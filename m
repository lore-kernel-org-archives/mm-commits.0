Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0561B25A2A2
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788046179; cv=none; b=hv5Ff6nGPqFcuqx+K37vZKAFyuc46gGiSzmZJm3lWqBF4F60yUjnBnT243Q7gXBjSlWADo56NI8M6h9LzobFT0AW5VUsps3S0HwFpBYZwY33FdxlujQIk9ZvCfL9nqPovvuJkrSWFGVWjGJ1bXVzawulFgnbYOLAx35zybj2kNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788046179; c=relaxed/simple;
	bh=LwsN7Q/e8rF90HgVtZZeHRWVb8KswJWdx7m9nEr4+kU=;
	h=Date:To:From:Subject:Message-Id; b=IK0ch6n+iPGCo55LAIwhX5eotL8ihrSoaQ5enoy/iodjLFuCG7o47ZhF4XIodvIr/rJtd+KYdjqNawpXmtZC+nSX3e03ej7dh4BGw1ZcJV9JwK7MutDFeCkOtKeVzfKucp3TLK1LEAMXLMeaA1YLHFEKA39Z0HG1CZCu0Xn73tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKTn+MOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKTn+MOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA2E1F000E9;
	Sat, 29 Aug 2026 23:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788046177;
	bh=EYY/9ceZJ51GvI8TWikMZxv0StMC7mxHvHC9wfs6R40=;
	h=Date:To:From:Subject;
	b=nKTn+MOQRvhVqtadNHMQt0Xu2hp2VhCERD5SzKX7auvr6rGPvyffLg7SKWsLxPBf9
	 HAqEXtyDH9IF6L8Lr8lQpGxMWN6bUjfHUGwAXIaPpzRm5sXBBB9hT+rY2wjrCo+ss2
	 /B4LLMCwkxDMZdR1J7Gp3zhrhG38sNUTUa05+QmU=
Date: Sat, 29 Aug 2026 16:29:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-the-comment-about-which-sizes-share-a-slot.patch added to mm-new branch
Message-Id: <20260829232937.7CA2E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: fix the comment about which sizes share a slot
has been added to the -mm mm-new branch.  Its filename is
     percpu-fix-the-comment-about-which-sizes-share-a-slot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-the-comment-about-which-sizes-share-a-slot.patch

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
Subject: percpu: fix the comment about which sizes share a slot
Date: Wed, 19 Aug 2026 01:48:30 +0900

A percpu allocation is at least PCPU_MIN_ALLOC_SIZE bytes, and
__pcpu_size_to_slot() returns 1 for sizes below 16 bytes and 2 for sizes
from 16 to 31 bytes.

So fix the wrong comment.

Link: https://lore.kernel.org/20260818164831.3138490-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-fix-the-comment-about-which-sizes-share-a-slot
+++ a/mm/percpu.c
@@ -100,7 +100,7 @@
 
 /*
  * The slots are sorted by the size of the biggest continuous free area.
- * 1-31 bytes share the same slot.
+ * [PCPU_MIN_ALLOC_SIZE..15] bytes share the same slot.
  */
 #define PCPU_SLOT_BASE_SHIFT		5
 /* chunks in slots below this are subject to being sidelined on failed alloc */
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-mm_init-remove-zone_absent_pages_in_node.patch
percpu-fix-the-comment-about-which-sizes-share-a-slot.patch

