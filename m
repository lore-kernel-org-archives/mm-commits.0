Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837F1202C5C
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747695693; cv=none; b=fuCU5xGtBmpapd6Fjf4sPgwQQN5uUBAhU4y0Na2WYqJM5yuj07X/yx5ERgVJy/g7Qn81WdoLMMtSpfOt64/8EqUezAtShxH/DF791DGETKacDbjVbKuKNsd7e+KEBhfMizacU1i1XgBOuZynZOIL+dFJSL7zo1qIj5kmNnQDUp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747695693; c=relaxed/simple;
	bh=LEsPOJExktsWg+QE77Z9Wf/uiaNgVzIKv6kA7PMyS20=;
	h=Date:To:From:Subject:Message-Id; b=KaOb/NAYNkw5C2hSdGRfMYFDbXEV4m/pZXHQCjHiXOEskv3//Papr8+mwoGtjZtS+jQX6ABm01JGOyHAvvuWPvTzkdDhVDi3z/k8EdcCQVD5GvpBNJwdbE5BFbqRluE24/1WorWXF1XC+aZTtOUVEwpBplDRS9/QRm8rOsIozU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FuZ/Yqbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FuZ/Yqbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D8C4CEE4;
	Mon, 19 May 2025 23:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747695693;
	bh=LEsPOJExktsWg+QE77Z9Wf/uiaNgVzIKv6kA7PMyS20=;
	h=Date:To:From:Subject:From;
	b=FuZ/YqbvtyEeBVjDUp0PzWCnUKBBYcocUh76RvC5aoaznPsO+7TVDOhJgJS7hrUaa
	 +sB2Ck6j/f5S+VFtEL+oS7ANuhfwUWjuvgIXcF6+3UMTo12+n42V6oypJeJMR3Om7o
	 r1S/xV2CdkXts6IqEWWB727/UnTG4Ti9r/CJyrcY=
Date: Mon, 19 May 2025 16:01:32 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch added to mm-new branch
Message-Id: <20250519230133.4D0D8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: only remove inode from swaplist when it's swapped page count is 0
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch

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
Subject: mm: shmem: only remove inode from swaplist when it's swapped page count is 0
Date: Sat, 17 May 2025 01:09:38 +0800

Even if we fail to allocate a swap entry, the inode might have previously
allocated entry and we might take inode containing swap entry off
swaplist.  As a result, try_to_unuse() may enter a potential dead loop to
repeatedly look for inode and clean it's swap entry.  Only take inode off
swaplist when it's swapped page count is 0 to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-5-shikemeng@huaweicloud.com
Fixes: b487a2da3575b ("mm, swap: simplify folio swap allocation")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505161438.9009cf47-lkp@intel.com
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0
+++ a/mm/shmem.c
@@ -1651,8 +1651,8 @@ try_split:
 		BUG_ON(folio_mapped(folio));
 		return swap_writepage(&folio->page, wbc);
 	}
-
-	list_del_init(&info->swaplist);
+	if (!info->swapped)
+		list_del_init(&info->swaplist);
 	mutex_unlock(&shmem_swaplist_mutex);
 	if (nr_pages > 1)
 		goto try_split;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch

