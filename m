Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8C71553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011032; cv=none; b=VJ0+3mpi19lY8/lW9ZtJlk5htohjI4vIEx2Tbz1aZOOqnknD4x2CTqsTqdvegSNGboJ9R2FMJWtxY6hEiducC+qJI3nbLkm5ex4MMPm5eGhL18eOHz3G5EzYcFFDaJgUODeaG9MXK99CEjHCr6KoC70YhOwAqaDAzMIABxQ6prI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011032; c=relaxed/simple;
	bh=T+7jYIgVO3XLJLqjYRFjdry/iJ0wtbAn7Byy7bCsPU8=;
	h=Date:To:From:Subject:Message-Id; b=QzUU0ExK6Klfb+B+fb76AMNqL63JU1eprsDrSPRCrPJ8t+W02NYn0dhmLwJ2aadfQBssxPkWAD0SfRW5fLeoPJ6R+LeGli6TsR0+aOAJ+3Pa9TTiHHlszIEfMmiOJIdk9NK0082FAcKr1rQfMOqlE+GNPYn8aS7fa7IGWZwsbfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogNRtyfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogNRtyfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A9CC4CEE4;
	Mon, 12 May 2025 00:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011032;
	bh=T+7jYIgVO3XLJLqjYRFjdry/iJ0wtbAn7Byy7bCsPU8=;
	h=Date:To:From:Subject:From;
	b=ogNRtyfd2PIXyzpVV3lBUCLCA4c3yvqCTi8+a+pGY9ouK3TcPN1bp+8ZD7+AFnmvt
	 1xCkhPfsBiLghdgUADSgRhD2g0GuflTFtegpdSLmlLbD6d2lF6GMnhbB83sUpn9t61
	 lfcsecTtGI6RSGyM4jZEABR9qjsSAIcQlFJWOMRE=
Date: Sun, 11 May 2025 17:50:31 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch removed from -mm tree
Message-Id: <20250512005031.E5A9CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: use swap_entries_free() to free swap entry in swap_entry_put_locked()
has been removed from the -mm tree.  Its filename was
     mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1356,9 +1356,11 @@ out:
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
 
@@ -1390,7 +1392,7 @@ static unsigned char swap_entry_put_lock
 	if (usage)
 		WRITE_ONCE(si->swap_map[offset], usage);
 	else
-		WRITE_ONCE(si->swap_map[offset], SWAP_HAS_CACHE);
+		swap_entries_free(si, ci, entry, 1);
 
 	return usage;
 }
@@ -1469,9 +1471,7 @@ static unsigned char swap_entry_put(stru
 	unsigned char usage;
 
 	ci = lock_cluster(si, offset);
-	usage = swap_entry_put_locked(si, offset, 1);
-	if (!usage)
-		swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
+	usage = swap_entry_put_locked(si, ci, entry, 1);
 	unlock_cluster(ci);
 
 	return usage;
@@ -1570,8 +1570,8 @@ static void cluster_swap_free_nr(struct
 
 	ci = lock_cluster(si, offset);
 	do {
-		if (!swap_entry_put_locked(si, offset, usage))
-			swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
+		swap_entry_put_locked(si, ci, swp_entry(si->type, offset),
+				      usage);
 	} while (++offset < end);
 	unlock_cluster(ci);
 }
@@ -1616,10 +1616,8 @@ void put_swap_folio(struct folio *folio,
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


