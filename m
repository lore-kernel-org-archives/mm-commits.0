Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B991FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988309; cv=none; b=UgcZ/1kjY6r5JbonNJa498l2oNjXODBV7Z0qUmAXvldLlQt7zZIFSIspvWxqNzoParDdxXYsbX2y+VuQ/6HbQnMncKuz/W818dLybrZPM51DEiXWJSduqn76uVmUqLwt1dNoMuF4eEJ+lZ99C+kfPJ0iS8r8jnD7uKlbrmMHmC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988309; c=relaxed/simple;
	bh=a46zV2AhspgUD7MrQgCu2gSjWOEu5El1g5EGs7Wm3Ok=;
	h=Date:To:From:Subject:Message-Id; b=rDWS5yGYS7cBEpiJFvOLTQCc/8+EjBh+he6sqSd3FIBJgQuEkNmW7Z1pfdRA/CWgY+trAAWHbDnqS7ghzBH6Q1kvXohyMYS7nyfZ1XU3APL3kZqOvtkAS010D4kUAFFteYCjbfILfhMHhC8F6KkuL6HBnhUUKO4TeG2M7qJQ0jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmWEW3+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmWEW3+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D064CC4CEE3;
	Mon,  7 Apr 2025 01:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988308;
	bh=a46zV2AhspgUD7MrQgCu2gSjWOEu5El1g5EGs7Wm3Ok=;
	h=Date:To:From:Subject:From;
	b=dmWEW3+0uhOC5DLW5a0FSP6Jv/g4+CiGw8coqbOBJ7/s4ESawyZ4hpoJKAxrI+Eoq
	 xUI5yfKd/N55uP+faCF5gUNhpIUpS4nGk2KCvM1ys42Jooy3sZGQ4CP6WcFhHX5jyc
	 sP9+iGBLfT/l1QoaZKaCXtnt/81rE/HyUYDxbB10=
Date: Sun, 06 Apr 2025 18:11:48 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch added to mm-new branch
Message-Id: <20250407011148.D064CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: enable swap_entry_range_free() to drop any kind of last ref
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch

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
Subject: mm: swap: enable swap_entry_range_free() to drop any kind of last ref
Date: Wed, 26 Mar 2025 00:25:22 +0800

The original VM_BUG_ON only allows swap_entry_range_free() to drop last
SWAP_HAS_CACHE ref.  By allowing other kind of last ref in VM_BUG_ON,
swap_entry_range_free() could be a more general-purpose function able to
handle all kind of last ref.  Following thi change, also rename
swap_entry_range_free() to swap_entries_free() and update it's comment
accordingly.

This is a preparation to use swap_entries_free() to drop more kind of last
ref other than SWAP_HAS_CACHE.

Link: https://lkml.kernel.org/r/20250325162528.68385-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref
+++ a/mm/swapfile.c
@@ -52,9 +52,9 @@
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entry_range_free(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
-				  swp_entry_t entry, unsigned int nr_pages);
+static void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
@@ -1462,7 +1462,7 @@ static unsigned char swap_entry_put(stru
 	ci = lock_cluster(si, offset);
 	usage = swap_entry_put_locked(si, offset, 1);
 	if (!usage)
-		swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
+		swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
 	unlock_cluster(ci);
 
 	return usage;
@@ -1492,7 +1492,7 @@ static bool swap_entries_put_nr(struct s
 	for (i = 0; i < nr; i++)
 		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	if (!has_cache)
-		swap_entry_range_free(si, ci, entry, nr);
+		swap_entries_free(si, ci, entry, nr);
 	unlock_cluster(ci);
 
 	return has_cache;
@@ -1511,12 +1511,18 @@ fallback:
 }
 
 /*
- * Drop the last HAS_CACHE flag of swap entries, caller have to
- * ensure all entries belong to the same cgroup.
+ * Drop the last ref(1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM) of swap entries,
+ * caller have to ensure all entries belong to the same cgroup and cluster.
  */
-static void swap_entry_range_free(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
-				  swp_entry_t entry, unsigned int nr_pages)
+static inline bool swap_is_last_ref(unsigned char count)
+{
+	return (count == SWAP_HAS_CACHE) || (count == 1) ||
+	       (count == SWAP_MAP_SHMEM);
+}
+
+static void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      swp_entry_t entry, unsigned int nr_pages)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned char *map = si->swap_map + offset;
@@ -1529,7 +1535,7 @@ static void swap_entry_range_free(struct
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(*map != SWAP_HAS_CACHE);
+		VM_BUG_ON(!swap_is_last_ref(*map));
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1552,7 +1558,7 @@ static void cluster_swap_free_nr(struct
 	ci = lock_cluster(si, offset);
 	do {
 		if (!swap_entry_put_locked(si, offset, usage))
-			swap_entry_range_free(si, ci, swp_entry(si->type, offset), 1);
+			swap_entries_free(si, ci, swp_entry(si->type, offset), 1);
 	} while (++offset < end);
 	unlock_cluster(ci);
 }
@@ -1595,11 +1601,11 @@ void put_swap_folio(struct folio *folio,
 
 	ci = lock_cluster(si, offset);
 	if (swap_only_has_cache(si, offset, size))
-		swap_entry_range_free(si, ci, entry, size);
+		swap_entries_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
 			if (!swap_entry_put_locked(si, offset + i, SWAP_HAS_CACHE))
-				swap_entry_range_free(si, ci, entry, 1);
+				swap_entries_free(si, ci, entry, 1);
 		}
 	}
 	unlock_cluster(ci);
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

