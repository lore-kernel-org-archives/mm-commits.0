Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE9B25745C;
	Thu, 22 May 2025 21:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747950101; cv=none; b=o8M0RW3Prg7iD18lUZxI9yqH/5PtzJ/DBqMFz5l+gybQymsrdJpJi9B6JDQHBjH1td9AtADV3RG/EJwJQxdtf1Ue7sAndtkdpo9OiZxUyVGiZGMthFk8KK0hBqgAuMq0KoWYOyiKR3MC42GIEQKWjzIdy2vHmiv/aS011DG1BCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747950101; c=relaxed/simple;
	bh=yipnwQ/QljiGv5Fam8/WxrnPVK9tye2rZzm+QFBjoi8=;
	h=Date:To:From:Subject:Message-Id; b=IZ0OwJUptTWHEOQcoYwU9G5jwiUGIPWfrjM4d5nrUeFfHTLKsiPq9est98GVKThhF5yKzTlaRflhLcCtNr5D0C8IUrM4klZ8aa4jV0riq4ruU17ER0TZSh7/b5HI5zvtSeD/vH7y4YwtiDWdPFQdglxwUX2Y5H3jm3dVY3Gl01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q35zAXEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q35zAXEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C713C4CEEB;
	Thu, 22 May 2025 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747950101;
	bh=yipnwQ/QljiGv5Fam8/WxrnPVK9tye2rZzm+QFBjoi8=;
	h=Date:To:From:Subject:From;
	b=Q35zAXEdwtgpt6YyhAzgclLe1m9mrwDOKlcrLouKVH46MMIQbwlwOwh1OjX1sFlqE
	 RXMIlmu5qOs8mWgoNd4MSGBt47mr+WxebZt/PgKqsTH2Tx21628EoqQdT/OB+yIHR1
	 9/4JvznSNCUiCRtdyZvjNnYEHSR5Us1fZqvsnG0Q=
Date: Thu, 22 May 2025 14:41:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch added to mm-new branch
Message-Id: <20250522214141.7C713C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: fix potensial buffer overflow in setup_clusters()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch

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
Subject: mm: swap: fix potensial buffer overflow in setup_clusters()
Date: Thu, 22 May 2025 20:25:53 +0800

In setup_swap_map(), we only ensure badpages are in range (0, last_page]. 
As maxpages might be < last_page, setup_clusters() will encounter a buffer
overflow when a badpage is >= maxpages.

Only call inc_cluster_info_page() for badpage which is < maxpages to fix
the issue.

Link: https://lkml.kernel.org/r/20250522122554.12209-4-shikemeng@huaweicloud.com
Fixes: b843786b0bd01 ("mm: swapfile: fix SSD detection with swapfile on btrfs")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: <stable@vger.kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-potensial-buffer-overflow-in-setup_clusters
+++ a/mm/swapfile.c
@@ -3208,9 +3208,13 @@ static struct swap_cluster_info *setup_c
 	 * and the EOF part of the last cluster.
 	 */
 	inc_cluster_info_page(si, cluster_info, 0);
-	for (i = 0; i < swap_header->info.nr_badpages; i++)
-		inc_cluster_info_page(si, cluster_info,
-				      swap_header->info.badpages[i]);
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+
+		if (page_nr >= maxpages)
+			continue;
+		inc_cluster_info_page(si, cluster_info, page_nr);
+	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++)
 		inc_cluster_info_page(si, cluster_info, i);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch
mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

