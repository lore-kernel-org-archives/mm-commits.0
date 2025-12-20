Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DE92FE075
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268337; cv=none; b=VLZ1b5TPgSLf1KCykUf4Bk8FP4gPtbCtlDXQWfQyN2Rg76CJT7XHDtSrlldX9uxhpsIS42PRMXMzx1HFDpihaiURpOMlkskAa4o4CxB1ljUKgyAz+s3pwKHhGpb3Sr/N0OMD9Et6Y1WMJ6dx4kSCDakQmLMr1XZr3UrkpD5tL0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268337; c=relaxed/simple;
	bh=X22yw+x4Gb698c+n8GEkP/OIh+LKYVigxm/GBvK6G38=;
	h=Date:To:From:Subject:Message-Id; b=Y1TbKL8UozC+d6COi8iDqZqIDwgPzrA+BrxwI6HgHJTnSAyabjW6EDihCrlPgIyKLSphQU4zeg5XQcE3jM7+iJzIbkGmV+qNCYAjGvUQh9CfMHXrDz0pKPj/EF3qI2EpEt6zYy2o9O4xBnnYM5rdZ9XvcPIzkgY940SK2IMNZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlZlQgUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlZlQgUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886B2C4CEF5;
	Sat, 20 Dec 2025 22:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268337;
	bh=X22yw+x4Gb698c+n8GEkP/OIh+LKYVigxm/GBvK6G38=;
	h=Date:To:From:Subject:From;
	b=DlZlQgUzDtm1QFUAdCKeVa4JQb9rFqHDBzOzEqK2igMa7SHetSDzpQLGQIn8oeSYg
	 8T7XV1Z4MBcDh/XuKYPKwAF/eKruTobeNhyf50oaV2Q3hiWpT3+DgCr1O/7vkyi8Fx
	 CFge1kPlZWAfkHf9vAQbrKG7NfFkKTGBq+w3PbWY=
Date: Sat, 20 Dec 2025 14:05:37 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-no-longer-needed-_swap_info_get.patch added to mm-new branch
Message-Id: <20251220220537.886B2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove no longer needed _swap_info_get
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-no-longer-needed-_swap_info_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-no-longer-needed-_swap_info_get.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

