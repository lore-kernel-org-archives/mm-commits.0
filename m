Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB91FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988311; cv=none; b=WJBQcZpdM2Ii6dhaFRdtvboa+/1o/5chvCTahpGxDpF7giZ9sCzreFzokmSb6RDDJAGS7stxybnpbYYenqLV5zGyvSKEDDR0k7GrX7osSt1NkS7OJZvfcWAZbbgVFQs+KUUAgFbTuuQhAMAk+ZCM0rEXCscg5PIL7NbBaywcXxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988311; c=relaxed/simple;
	bh=2AaEpoaeIoETfKE0ET58EIENNzPVb6e3BZPh+0kuR8A=;
	h=Date:To:From:Subject:Message-Id; b=NTJ8vK7+0zk99U8NdQCt6Xt/CuCUziC1BTdV5TzDNtl2sWAJ1Dn9zl5SlVIkaHFkSwbzDpjAkKbiVfT2MARJBn97WuCKQVgNW9P+uJ74nhGiEUs7f2ISYsW/w9gHFMdawojphCMR0gHgUgTc2QHpkomITkj7FHroNAI3GVyS+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U2Y2dDIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U2Y2dDIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1316C4CEE3;
	Mon,  7 Apr 2025 01:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988311;
	bh=2AaEpoaeIoETfKE0ET58EIENNzPVb6e3BZPh+0kuR8A=;
	h=Date:To:From:Subject:From;
	b=U2Y2dDIJ5AEAzRhr54unl0aeyfoDUyyX3JofceuyYf+s24KxO5A1C8d9rwgJkpYH1
	 nnQ6ZXAIeraglGJN/9xNiC0zOw/RJbirtUBstIMAORRHWmv7Z7Lrjt/X2BGHWQF4ax
	 bGo8Dx1BylP/mT8jIGnsSa/vBMu4j7Vi5ok3dO2Y=
Date: Sun, 06 Apr 2025 18:11:50 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch added to mm-new branch
Message-Id: <20250407011150.F1316C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: use swap_entries_free() to free swap entry in swap_entry_put_locked()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: swap: use swap_entries_free() to free swap entry in swap_entry_put_locked()
Date: Wed, 26 Mar 2025 00:25:23 +0800

In swap_entry_put_locked(), we will set slot to SWAP_HAS_CACHE before
using swap_entries_free() to do actual swap entry freeing.  This introduce
an unnecessary intermediate state.  By using swap_entries_free() in
swap_entry_put_locked(), we can eliminate the need to set slot to
SWAP_HAS_CACHE.  This change would make the behavior of
swap_entry_put_locked() more consistent with other put() operations which
will do actual free work after put last reference.

Link: https://lkml.kernel.org/r/20250325162528.68385-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked
+++ a/mm/swapfile.c
@@ -1347,9 +1347,11 @@ out:
 }
 
 static unsigned char swap_entry_put_locked(struct swap_info_struct *si,
-					   unsigned long offset,
+					   struct swap_cluster_info *ci,
+					   swp_entry_t entry,
 					   unsigned char usage)
 {
+	unsigned long offset = swp_offset(entry);
 	unsigned char count;
 	unsigned char has_cache;
 
@@ -1381,7 +1383,7 @@ static unsigned char swap_entry_put_lock
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		WRITE_ONCE(si->swap_map[offset], SWAP_HAS_CACHE);
+		swap_entries_free(si, ci, entry, 1);
 
 	return usage;
 }
@@ -1460,9 +1462,7 @@ static unsigned char swap_entry_put(stru
 	unsigned char usage;
 
 	ci = lock_cluster(si, offset);
-	usage = swap_entry_put_locked(si, offset, 1);
-	if (!usage)
-		swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
+	usage = swap_entry_put_locked(si, ci, entry, 1);
 	unlock_cluster(ci);
 
 	return usage;
@@ -1557,8 +1557,8 @@ static void cluster_swap_free_nr(struct
 
 	ci = lock_cluster(si, offset);
 	do {
-		if (!swap_entry_put_locked(si, offset, usage))
-			swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
+		swap_entry_put_locked(si, ci, swp_entry(si->type, offset),
+				      usage);
 	} while (++offset < end);
 	unlock_cluster(ci);
 }
@@ -1603,10 +1603,8 @@ void put_swap_folio(struct folio *folio,
 	if (swap_only_has_cache(si, offset, size))
 		swap_entries_free(si, ci, entry, size);
 	else {
-		for (int i = 0; i < size; i++, entry.val++) {
-			if (!swap_entry_put_locked(si, offset + i, SWAP_HAS_CACHE))
-				swap_entries_free(si, ci, entry, 1);
-		}
+		for (int i = 0; i < size; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
 	}
 	unlock_cluster(ci);
 }
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

