Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386B3ACEFE
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 05:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784526924; cv=none; b=cV1jh2DZNGeNuLAv0SeTCRUe/sdQuN7fFs1qOuu4fVM83X6sWACcHEHdUiaMco7pe/tS0StaohC1iu3yKvzRl2IPLRhhYxzX7d4VuuL+P2WtqNAMINxqaJcwcyHnJuo7EjLp/wWWZUD+P9s1yQcKtdW5tjygj9oQozJMMPwFWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784526924; c=relaxed/simple;
	bh=sy/C1SHKbxIsvjxliV/aviWbDHGs44H3MQ7Zv3HuSOY=;
	h=Date:To:From:Subject:Message-Id; b=RX5G3WQSriILuGrYjW56biZMGY+ydzToNdrSRcJUX/emlSXpz98K5CemehMdjkSWzlH2pKAYu5avTNB9sqWkGcFjphGud1FAV60M1rV2x6cJpeFUR8rzR05MZjgLveoPstjkLNH9lXGwK5GWE084gVpR9uFDVz3LNqS5RRzNN+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SgiKT/UB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SgiKT/UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCE41F000E9;
	Mon, 20 Jul 2026 05:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784526907;
	bh=OARHM0l69/v79FgMNDYeaZFV5G32HofZVSytQe6AjpM=;
	h=Date:To:From:Subject;
	b=SgiKT/UB09dlHOCnRa15q3/SBCIIFR5RrCSWyTKwYI5OIbVbdM4au45sjU9+uecSM
	 9xYwDBwfDN9Wg/QpM+SB836qhxgiAisfld+d5yfLd6Yo6tqOyWMZtlrrw6NW0Ktk/s
	 BKcRzfwiwkfPy9FDKEuuyaFgWwyugYg24G7onwT4=
Date: Sun, 19 Jul 2026 22:55:07 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mike.kravetz@oracle.com,david@kernel.org,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-release-subpool-on-fill_super-failure.patch added to mm-new branch
Message-Id: <20260720055507.6BCE41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: release subpool on fill_super failure
has been added to the -mm mm-new branch.  Its filename is
     hugetlbfs-release-subpool-on-fill_super-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-release-subpool-on-fill_super-failure.patch

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
From: Yichong Chen <chenyichong@uniontech.com>
Subject: hugetlbfs: release subpool on fill_super failure
Date: Mon, 20 Jul 2026 10:18:59 +0800

hugetlbfs_fill_super() allocates a hugepage subpool when size or min_size
mount options are specified.  hugepage_new_subpool() may also reserve huge
pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses hugepage_put_subpool()
and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com
Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-release-subpool-on-fill_super-failure
+++ a/fs/hugetlbfs/inode.c
@@ -1419,7 +1419,8 @@ hugetlbfs_fill_super(struct super_block
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch
hugetlbfs-release-subpool-on-fill_super-failure.patch
fat-release-buffer-head-after-rebuilding-parent.patch

