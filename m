Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D8E2882CE
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761247176; cv=none; b=VEzH+s4t+f+LIFkUUim+Oxb6Pf30gOm5uqt+ey2PztYGEQemkDA32v4CwYfFlsBv6CviFCkt/09pgIB+RYjhNRYwfErWcU3Crio4xC8bjMVXLc1RcUC3CEUm0TBRA6INliOXRW+NGpo4pvSo3BLxmG6Qd2QHioxEx04NfpwJ/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761247176; c=relaxed/simple;
	bh=CeXEWcw2Y7W4Aizh08N3vu6Pyoc0wWeuU/rZzIqR5sA=;
	h=Date:To:From:Subject:Message-Id; b=FwW26JfIxe1usr1ucHN/+VKHpGlfZv1btqKwVBrMTY3XV6QWBZKSdBXTD+tUYMihLYtUkwa3F/In8vYz9DjCvWw+t+uyCowMLRLZpRLkQRaYkfjpfaNsvZWSzSijUEXtIm9G4UwI4bvBL0Y0k+cFCJ6kuaHemiCpj8j7E/PIcJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QhEVTcvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QhEVTcvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B05C4CEE7;
	Thu, 23 Oct 2025 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761247176;
	bh=CeXEWcw2Y7W4Aizh08N3vu6Pyoc0wWeuU/rZzIqR5sA=;
	h=Date:To:From:Subject:From;
	b=QhEVTcvWEjdFI86EaosAe9NJKVkPhUzmU/cEPm80H/386+liu+gv8GJyl+2+ohiSN
	 rYULyVB36t6z4oS2gFlDjpU59rTSEq1diFWtHQl2bFrxg3TumOM9ShVcWZutwWRbZ4
	 CwZgdv4Dj3f46oTmVIDRYl0CXBij8zDOkC8w8UAk=
Date: Thu, 23 Oct 2025 12:19:35 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-helper-for-setup-bad-slots.patch added to mm-new branch
Message-Id: <20251023191935.E7B05C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: rename helper for setup bad slots
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-rename-helper-for-setup-bad-slots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-rename-helper-for-setup-bad-slots.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: rename helper for setup bad slots
Date: Fri, 24 Oct 2025 02:00:40 +0800

The name inc_cluster_info_page is very confusing, as this helper is only
used during swapon to mark bad slots.  Rename it properly and turn the
VM_BUG_ON in it into WARN_ON to expose more potential issues.  Swapon is a
cold path, so adding more checks should be a good idea.

No feature change except new WARN_ON.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-2-a709469052e7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-helper-for-setup-bad-slots
+++ a/mm/swapfile.c
@@ -751,14 +751,14 @@ static void relocate_cluster(struct swap
 }
 
 /*
- * The cluster corresponding to page_nr will be used. The cluster will not be
- * added to free cluster list and its usage counter will be increased by 1.
- * Only used for initialization.
+ * The cluster corresponding to @offset will be accounted as having one bad
+ * slot. The cluster will not be added to the free cluster list, and its
+ * usage counter will be increased by 1. Only used for initialization.
  */
-static int inc_cluster_info_page(struct swap_info_struct *si,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr)
+static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
+				       unsigned long offset)
 {
-	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
@@ -772,8 +772,8 @@ static int inc_cluster_info_page(struct
 
 	ci->count++;
 
-	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
-	VM_BUG_ON(ci->flags);
+	WARN_ON(ci->count > SWAPFILE_CLUSTER);
+	WARN_ON(ci->flags);
 
 	return 0;
 }
@@ -3396,7 +3396,7 @@ static struct swap_cluster_info *setup_c
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	err = inc_cluster_info_page(si, cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(cluster_info, 0);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3404,12 +3404,12 @@ static struct swap_cluster_info *setup_c
 
 		if (page_nr >= maxpages)
 			continue;
-		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = inc_cluster_info_page(si, cluster_info, i);
+		err = swap_cluster_setup_bad_slot(cluster_info, i);
 		if (err)
 			goto err;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

