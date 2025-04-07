Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800E91FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988319; cv=none; b=cDrfBv4W11YLY9qkgKqYXdxaI6tEPUoqA2NIFkDGB4tJoFRUq/Ur/pnLoLCti7aX8gY8Us9617mtr6AtI+Hd4cfds6GkXH/FaVxcSrEFnrS6S324JeN1uA8P0Ap19GcBTPZTC1R9+sZIqAfj1frfnoEBif2L5JlrH9jmqXSf+7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988319; c=relaxed/simple;
	bh=hmmKTXLnPlFfRYfCeBaKF6qPc1swmIfs0Q4bqZv7cTQ=;
	h=Date:To:From:Subject:Message-Id; b=jqAdrH/R+D6ZIcmOfYp3lBoCrNX5y/rKq/8Eeu5U09WdEvPQG7twSxfARQ5VjFJ6GW56Dvs7P/yPRFz7JPXHeS8cNDtW8F+5Z2YB/pFnjpgc8dmv5nvKNkFLdD6WpJYvsOfZkGZuMPhbacqT0wf3Il0VpF0avT4tJ1VbQWQzKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQcag2SU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQcag2SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F33C4CEE3;
	Mon,  7 Apr 2025 01:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988319;
	bh=hmmKTXLnPlFfRYfCeBaKF6qPc1swmIfs0Q4bqZv7cTQ=;
	h=Date:To:From:Subject:From;
	b=XQcag2SUn26T8gVvcYvMRhHUmU7/FN59iSuYkGgddiy59jqL9RzZUhcL29a7kCdCl
	 pCdrUDJW3j9WsI9O0sndnf0NQZbrH8Y+ZJwIHhp6rVR88bTLHHLKEIqQSzAYpoNzFs
	 G3RMlYVh5Kw+cZqVcOj3xoIrWl0SEZmrC8+8Pvos=
Date: Sun, 06 Apr 2025 18:11:58 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch added to mm-new branch
Message-Id: <20250407011158.F2F33C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: factor out helper to drop cache of entries within a single cluster
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch

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
Subject: mm: swap: factor out helper to drop cache of entries within a single cluster
Date: Wed, 26 Mar 2025 00:25:27 +0800

Factor out helper swap_entries_put_cache() from put_swap_folio() to serve
as a general-purpose routine for dropping cache flag of entries within a
single cluster.

Link: https://lkml.kernel.org/r/20250325162528.68385-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster
+++ a/mm/swapfile.c
@@ -1454,6 +1454,22 @@ put_out:
 	return NULL;
 }
 
+static void swap_entries_put_cache(struct swap_info_struct *si,
+				   swp_entry_t entry, int nr)
+{
+	unsigned long offset = swp_offset(entry);
+	struct swap_cluster_info *ci;
+
+	ci = lock_cluster(si, offset);
+	if (swap_only_has_cache(si, offset, nr))
+		swap_entries_free(si, ci, entry, nr);
+	else {
+		for (int i = 0; i < nr; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	}
+	unlock_cluster(ci);
+}
+
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1594,8 +1610,6 @@ void swap_free_nr(swp_entry_t entry, int
  */
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	int size = 1 << swap_entry_order(folio_order(folio));
 
@@ -1603,14 +1617,7 @@ void put_swap_folio(struct folio *folio,
 	if (!si)
 		return;
 
-	ci = lock_cluster(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else {
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	unlock_cluster(ci);
+	swap_entries_put_cache(si, entry, size);
 }
 
 int __swap_count(swp_entry_t entry)
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

