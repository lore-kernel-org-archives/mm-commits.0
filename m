Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CA51F63FF
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875655; cv=none; b=sHYaIgCe0boOX+ws2F7LxA+c8EeniltwzLDFDAF13QnTQHvkQfsj8ZZLOSsiv2N/KZuHmtTTVC6T5vpYYGPysSXaiJMIiBM9mbfRHTQdwsuHx6t69I4/BvKZXFvXx10n/TQpgsdgsHm0FwwtV9g6xSbLy6pqaLnzoVYRbJGM81M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875655; c=relaxed/simple;
	bh=eQb/hvQhIV5d+P9wUSOp2yjjDeZ3KIfotlHkDqrcRZA=;
	h=Date:To:From:Subject:Message-Id; b=bBoAHM1HbjxAnTzLW6suSlUEOs/aLhD8lyvBLznTsTdsrvXX6UggLYzlT49l9C4wAN2RNTfDYpd1h2kADUmX8Ng/LLo1ayIv0Qq7CdAv72lnGaHZXiOYpZRtwYKAEL6yCV20etPXmhInUE2irdZcNLTNO+86zxRcNQOXyLIWP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0XKvOZDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0XKvOZDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A51C4CEF1;
	Tue,  7 Oct 2025 22:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759875654;
	bh=eQb/hvQhIV5d+P9wUSOp2yjjDeZ3KIfotlHkDqrcRZA=;
	h=Date:To:From:Subject:From;
	b=0XKvOZDgqXgsAXusxTjFYLwm1a6sIQaI8iBMlgKz6hMTsVDmmpzQ/0vT1r+dQRd3Y
	 mfI6V5HBLz7xd2Gy2u8M4n3KDYT7Sixe4aj1DVrmO7WsWfKikYJUQ0EgtpA0F7Kmmz
	 fHDq+yjUDnVim/RKz/gL+w5BBp48Sp7QVckOvLxc=
Date: Tue, 07 Oct 2025 15:20:54 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-rename-helper-for-setup-bad-slots.patch added to mm-new branch
Message-Id: <20251007222054.C1A51C4CEF1@smtp.kernel.org>
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
Date: Tue, 07 Oct 2025 04:02:34 +0800

The name inc_cluster_info_page is very confusing, as this helper is only
used during swapon to mark bad slots.  Rename it properly and turn the
VM_BUG_ON in it into WARN_ON to expose more potential issues.  Swapon is a
cold path, so adding more checks should be a good idea.

No feature change except new WARN_ON.

Link: https://lkml.kernel.org/r/20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch

