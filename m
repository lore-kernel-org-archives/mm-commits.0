Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FC84AD4C3
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788381883; cv=none; b=X/783+N0fNd7dsVoHUOQX6FYiZvDzts2193WDrPLKyDNe6oELnVz9WDyXDaSnwbEwnKQHL2t9P1bZ2C7vGIMcpdXNqb8t71QwjlkIu/qiDOjOSFDwDhgF8kpUIaGsInzTawP03NLyl2GGzkFE7g+7EDUtOfEA48jajEEIB0Se40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788381883; c=relaxed/simple;
	bh=5o6LTc9O3cmVAXinz68fuBfjfiTnwCHCjUegdsV1sl8=;
	h=Date:To:From:Subject:Message-Id; b=X/rhUzztvi19iDCpMnVCvwU0TqD6HrC/j9T6CLOKlc3PbsLDPP9lxGLkLNT/z6hvwpWTsEFM1YhZNL+bzeUvJRglOcJAsBXznXJKKNXqKSKjaa1vZjEq9Kmp7GVN5LGvYH0gZiJP8Yr7LAmIbhnWxB/c+vL73k7UbpRmTRhvT+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b87xwigu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b87xwigu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B841F00A3D;
	Wed,  2 Sep 2026 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788381881;
	bh=v6gnDvc2EgZ1SPCYB/W76G/IiWKKTZNVC1eEiJIJv2c=;
	h=Date:To:From:Subject;
	b=b87xwiguM5Q6ZdC3oIVrbg4+VAl9dmpWNFD2Opau8tknMehcUgP3oyQfBKscRcydT
	 yfwF3IMBBYCYbsb3VTW7ndahaJJIyLwO10u8pYx1IOxKhSdxyeyawsXuaN4ni1wwKw
	 XSyFsBP6d8HZ8/pyyxCR/H51F9QtV1iiE3e8aJs4=
Date: Wed, 02 Sep 2026 13:44:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,ljs@kernel.org,hch@lst.de,hannes@cmpxchg.org,djwong@kernel.org,david@kernel.org,cem@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iomap-simplify-writepages-reclaim-guard.patch added to mm-new branch
Message-Id: <20260902204440.F2B841F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iomap: simplify writepages reclaim guard
has been added to the -mm mm-new branch.  Its filename is
     iomap-simplify-writepages-reclaim-guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomap-simplify-writepages-reclaim-guard.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: iomap: simplify writepages reclaim guard
Date: Wed, 2 Sep 2026 21:16:51 +0800

Now that kswapd can no longer reach filesystem writeback (pageout()
returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
context in iomap_writepages() indicates a VM regression, simplify the
check by removing PF_KSWAPD.

Link: https://lore.kernel.org/20260902131653.1338227-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-simplify-writepages-reclaim-guard
+++ a/fs/iomap/buffered-io.c
@@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_
 	 * Writeback from reclaim context should never happen except in the case
 	 * of a VM regression so warn about it and refuse to write the data.
 	 */
-	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
-			PF_MEMALLOC))
+	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))
 		return -EIO;
 
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch

