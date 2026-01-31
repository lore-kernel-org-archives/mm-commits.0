Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A863E38B7BF
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898424; cv=none; b=HQ9s1xsxyRE4pbZDsxMtilskfsKCtu3i6py+EJbIL8vdnpBaBoa5YvaHhA18C7aPt9E8q1SDCWifXrWn5H789dO2rARd8z0uiQCZ1Pzj/BAI28giHCKtrhA/kOLXD/2jD23V1a8CcOqiOV5F7XFRJf9yNJpJw+2m6udzPnQIOKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898424; c=relaxed/simple;
	bh=3XMwHCHtMZhmKRvC4rg1YLla2W3Bcv3CTjCav3A5gUE=;
	h=Date:To:From:Subject:Message-Id; b=VIhPqldhENM/Z+cRVQbkExeEeiefAC8QQUpQf2jNB0+aMQH0UuZaVZqoBv1YFm6qi2HTW5B0GNqiKafnqs9iqRJbLNnA3KLnN1xBCviMAiOzTZjhkwcqgFS74ohoq53dQcxnUtHBc3zkZa3A8o9WxP6sR1phNUwFC6X8YkRTfDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mS4U6nXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mS4U6nXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD47C4CEF1;
	Sat, 31 Jan 2026 22:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898424;
	bh=3XMwHCHtMZhmKRvC4rg1YLla2W3Bcv3CTjCav3A5gUE=;
	h=Date:To:From:Subject:From;
	b=mS4U6nXqIf5fONAu8ZrW+FaYMvNB3utaAnaCajpU4hUshgZNPeSaB0v+SE+DPsHgW
	 i3vpbE/p4FF1sHFUHU3zLU5rfwO0LQcEXcJKH+nYBFNm6Xkthf01f0v44vVvy+24Eh
	 M+LgTP0Rl4+/F+ncXpD21dIMkIl6Wi4tg6qlNJP8=
Date: Sat, 31 Jan 2026 14:27:03 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-no-longer-needed-_swap_info_get.patch removed from -mm tree
Message-Id: <20260131222704.7DD47C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove no longer needed _swap_info_get
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-no-longer-needed-_swap_info_get.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove no longer needed _swap_info_get
Date: Sat, 20 Dec 2025 03:43:48 +0800

There are now only two users of _swap_info_get after consolidating these
callers, folio_free_swap and swp_swapcount.

folio_free_swap already holds the folio lock, and the folio must be in the
swap cache, _swap_info_get is redundant.

For swp_swapcount, it should use get_swap_device instead.  get_swap_device
increases the device ref count, which is actually a bit safer.  The only
current use is smap walking, and the performance change here is tiny.

And after these changes, _swap_info_get is no longer used, so we can
safely remove it.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-19-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   47 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-no-longer-needed-_swap_info_get
+++ a/mm/swapfile.c
@@ -83,9 +83,7 @@ bool swap_migration_ad_supported;
 #endif	/* CONFIG_MIGRATION */
 
 static const char Bad_file[] = "Bad swap file entry ";
-static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
-static const char Unused_offset[] = "Unused swap offset entry ";
 
 /*
  * all active swap_info_structs
@@ -1600,41 +1598,6 @@ void folio_put_swap(struct folio *folio,
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	unsigned long offset;
-
-	if (!entry.val)
-		goto out;
-	si = swap_entry_to_info(entry);
-	if (!si)
-		goto bad_nofile;
-	if (data_race(!(si->flags & SWP_USED)))
-		goto bad_device;
-	offset = swp_offset(entry);
-	if (offset >= si->max)
-		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]) &&
-	    !swap_cache_has_folio(entry))
-		goto bad_free;
-	return si;
-
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-	goto out;
-bad_offset:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	goto out;
-bad_device:
-	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
-	goto out;
-bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
-out:
-	return NULL;
-}
-
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long offset)
@@ -1794,7 +1757,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1824,6 +1787,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1858,11 +1822,12 @@ unlock_out:
 static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si = _swap_info_get(entry);
+	struct swap_info_struct *si;
 
-	if (!si)
-		return false;
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_entry_swapped(si, entry);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

