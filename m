Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E185F1A83F9
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695692; cv=none; b=kH7FM6zw6jrmkRjeJx7m9h/5xH3VEWZ8uTmU3QWLjm7DMwww7oGC6g5QSeTP6cCwDAxhqZyZNgyvHOmUtBoZNSjg+vCB7NLR3BybXhVI4T4KKf7bbnZ7UHer/TIKyiS/TE8+1vjLPnxUICu09H3KwCkKhDmbiHol9x8Cc7r9TtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695692; c=relaxed/simple;
	bh=aI9eOtsgombrSxfYEZBk8XRhhR+GeM5wXqhlvQtkSVY=;
	h=Date:To:From:Subject:Message-Id; b=DtXLRECb5cPhRhUBjdX9m2rakHDUKsasgH9NzkbDBNVis8r8Pfhz+x3zRSheZh8O3JShTnlrpRbd3GSYBM7RkrFZ/dWPiRJmyT75xFV3zqydVWnm+eFNtONXl6Bcococ9Eqr86JM57zq1SW5Aq86fv0s1avEoHw7KSnATcfYdxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TReJi70s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TReJi70s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48622C4CEE4;
	Mon, 19 May 2025 23:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695691;
	bh=aI9eOtsgombrSxfYEZBk8XRhhR+GeM5wXqhlvQtkSVY=;
	h=Date:To:From:Subject:From;
	b=TReJi70sY1lBTG2rZgKE6AYmj21gtWi1sXIhFgGVVK5qWY276fkIS3PEPlCsfW+Q2
	 3pk08j7Uq1tpqFbMXKmN6fjiD+Gq9uWjge3MenwsOenohDUfI/Tv93CbF+wSk67Xsj
	 tjSh1E8UjKAiN/FBN/yGbNeNYOLXoh4mzpJiGerA=
Date: Mon, 19 May 2025 16:01:30 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch added to mm-new branch
Message-Id: <20250519230131.48622C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: Fix potential dead loop in shmem_unuse()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/shmem: Fix potential dead loop in shmem_unuse()
Date: Sat, 17 May 2025 01:09:37 +0800

If multi shmem_unuse() for different swap type is called concurrently, a
dead loop could occur as following:

shmem_unuse(typeA)               shmem_unuse(typeB)
 mutex_lock(&shmem_swaplist_mutex)
 list_for_each_entry_safe(info, next, ...)
  ...
  mutex_unlock(&shmem_swaplist_mutex)
  /* info->swapped may drop to 0 */
  shmem_unuse_inode(&info->vfs_inode, type)

                                  mutex_lock(&shmem_swaplist_mutex)
                                  list_for_each_entry(info, next, ...)
                                   if (!info->swapped)
                                    list_del_init(&info->swaplist)

                                  ...
                                  mutex_unlock(&shmem_swaplist_mutex)

  mutex_lock(&shmem_swaplist_mutex)
  /* iterate with offlist entry and encounter a dead loop */
  next = list_next_entry(info, swaplist);
  ...

Restart the iteration if the inode is already off shmem_swaplist list to
fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-4-shikemeng@huaweicloud.com
Fixes: b56a2d8af9147 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-potential-dead-loop-in-shmem_unuse
+++ a/mm/shmem.c
@@ -1505,6 +1505,7 @@ int shmem_unuse(unsigned int type)
 		return 0;
 
 	mutex_lock(&shmem_swaplist_mutex);
+start_over:
 	list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
 		if (!info->swapped) {
 			list_del_init(&info->swaplist);
@@ -1523,13 +1524,15 @@ int shmem_unuse(unsigned int type)
 		cond_resched();
 
 		mutex_lock(&shmem_swaplist_mutex);
-		next = list_next_entry(info, swaplist);
-		if (!info->swapped)
-			list_del_init(&info->swaplist);
 		if (atomic_dec_and_test(&info->stop_eviction))
 			wake_up_var(&info->stop_eviction);
 		if (error)
 			break;
+		if (list_empty(&info->swaplist))
+			goto start_over;
+		next = list_next_entry(info, swaplist);
+		if (!info->swapped)
+			list_del_init(&info->swaplist);
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

