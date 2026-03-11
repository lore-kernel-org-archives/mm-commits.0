Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D552DF128
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 21:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773264271; cv=none; b=f5g3fNbyYL/Lz2mS4idsb2bnwvSTcTlVkkUXagmFPI4puXJ5gHBsO8qD/2uuA3ftI1AVDn7g8PoZkRW0SVyaPGhyw3CJE7GLbLMR3XNtqEQcGqQDPQH/188ybfPL00IOxvkjyCgl+IUOdH39f7TikZ4fH60LX6698Y1OK2ZG5D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773264271; c=relaxed/simple;
	bh=rWvQyJs8AooPwTDgwddiPfNh27ufN1s3iLmi981pSdU=;
	h=Date:To:From:Subject:Message-Id; b=hGXzaPqjDukK2QHM1ei1TF1MVgaXQBJIjom4udyryCkGwNbrQp7qV46KVwR/TyQmp0CL0NIijqmAyuA45vPllvEF1uBhY8dNE2oYhM2RwznM+zYWds3gNErt0PsQDHOPUoCvs+IFlqy7hfL7WSUdC7X6XMRE+qEoeGR71siVMo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=poD1cU1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="poD1cU1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A60C4CEF7;
	Wed, 11 Mar 2026 21:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773264270;
	bh=rWvQyJs8AooPwTDgwddiPfNh27ufN1s3iLmi981pSdU=;
	h=Date:To:From:Subject:From;
	b=poD1cU1O5r3kvd0d9Sfs0Q4HAM29mlmg2d1XuPQdwamgQaDgZwpiJMYdGenN7ByYp
	 UhRZSe2h+XIVTNVB3gkguNwwx/ewzA5pLH57cxeU6N0aBiGgzhAatfdUkdPVHbZMxB
	 /Z7rj8yu7iTB4gJB75vtP+rw2Xu4KT6lpG9OuFDc=
Date: Wed, 11 Mar 2026 14:24:29 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch added to mm-new branch
Message-Id: <20260311212430.69A60C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
Date: Wed, 11 Mar 2026 10:22:41 +0800

remove redundant comment, per Barry

Link: https://lkml.kernel.org/r/20260311022241.177801-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
+++ a/mm/swapfile.c
@@ -623,10 +623,8 @@ static struct swap_cluster_info *isolate
 	spin_unlock(&si->lock);
 
 	if (found && !cluster_table_is_alloced(found)) {
-		/* Table of non-free cluster must be allocated. */
-		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
-
 		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
 		return swap_cluster_alloc_table(si, found);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch

