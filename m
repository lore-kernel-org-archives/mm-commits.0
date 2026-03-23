Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23021382F27
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 22:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774306137; cv=none; b=K67vufosMRKZQZivibx48icY+evywgjnxPXqWvQClZ314lCpSF5sCUUSfGwkxEJso2FTB4XuKyC7s2IZJYgSZ7C+ZGVkL+V/tXvEKcjyNdvY3B9wjBUuXxrYBLMfieQwgz0ClVeO8RYqODREd2EFkVS0C3kWssW2aApSih20P+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774306137; c=relaxed/simple;
	bh=BJCwWeLGaKzllloYob2XjscK0cwBEkl78RhnMPHO/hA=;
	h=Date:To:From:Subject:Message-Id; b=cFb3uXOuk5DN/DptUFjHksxqKpc/jrBCQ2Z7GFmAFcZ/s1t4BF1arVuqfsI9dimQ88Ldu6zbzsQlLWeyPIvs18TgJIiCdua1d4eHRKBB9NWAdvikoQv1OiiF2z0iBILYoFUagX08GkwDcgeHHZeCucIEPMjAJY4OGLCDhhk+Z8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PzKW6KEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PzKW6KEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF85C4CEF7;
	Mon, 23 Mar 2026 22:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774306136;
	bh=BJCwWeLGaKzllloYob2XjscK0cwBEkl78RhnMPHO/hA=;
	h=Date:To:From:Subject:From;
	b=PzKW6KEPRDGvftVPb+e79JtYZPml1mbdfPjrKBh3QueDdEgTIZcnXBDM2XdXViWcS
	 Ftz0op6hgsiRk8Gsm4pDVjOz2oKig2jadEmcxF4ruFKA13KFeOVTqPK+qim3LMkVi3
	 AuSK7RZXvTob5jZEb6hbxOxJdeHmYl9zRVlKqLUk=
Date: Mon, 23 Mar 2026 15:48:56 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,rafael@kernel.org,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch added to mm-new branch
Message-Id: <20260323224856.AEF85C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove redundant swap device reference in alloc/free
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swap: remove redundant swap device reference in alloc/free
Date: Tue, 24 Mar 2026 01:08:22 +0900

In the previous commit, uswsusp was modified to pin the swap device when
the swap type is determined, ensuring the device remains valid throughout
the hibernation I/O path.

Therefore, it is no longer necessary to repeatedly get and put the swap
device reference for each swap slot allocation and free operation.

For hibernation via the sysfs interface, user-space tasks are frozen
before swap allocation begins, so swapoff cannot race with allocation. 
After resume, tasks remain frozen while swap slots are freed, so
additional reference management is not required there either.

Remove the redundant swap device get/put operations from the hibernation
swap allocation and free paths.

Also remove the SWP_WRITEOK check before allocation, as the cluster
allocation logic already validates the swap device state.

Update function comments to document the caller's responsibility for
ensuring swap device stability.

Link: https://lkml.kernel.org/r/20260323160822.1409904-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   68 +++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-redundant-swap-device-reference-in-alloc-free
+++ a/mm/swapfile.c
@@ -2077,7 +2077,16 @@ out:
 }
 
 #ifdef CONFIG_HIBERNATION
-/* Allocate a slot for hibernation */
+/**
+ * swap_alloc_hibernation_slot() - Allocate a swap slot for hibernation.
+ * @type: swap device type index to allocate from.
+ *
+ * The caller must ensure the swap device is stable, either by pinning
+ * it (SWP_HIBERNATION) or by freezing user-space.
+ *
+ * Return: a valid swp_entry_t on success, or an empty entry (val == 0)
+ * on failure.
+ */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
 	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
@@ -2088,46 +2097,42 @@ swp_entry_t swap_alloc_hibernation_slot(
 	if (!si)
 		goto fail;
 
-	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Try the local cluster first if it matches the device. If
-			 * not, try grab a new cluster and override local cluster.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-			if (pcp_si == si && pcp_offset) {
-				ci = swap_cluster_lock(si, pcp_offset);
-				if (cluster_is_usable(ci, 0))
-					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-				else
-					swap_cluster_unlock(ci);
-			}
-			if (!offset)
-				offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
-		}
-		put_swap_device(si);
+	/*
+	 * Try the local cluster first if it matches the device. If
+	 * not, try grab a new cluster and override local cluster.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	if (pcp_si == si && pcp_offset) {
+		ci = swap_cluster_lock(si, pcp_offset);
+		if (cluster_is_usable(ci, 0))
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+		else
+			swap_cluster_unlock(ci);
 	}
+	if (!offset)
+		offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+	if (offset)
+		entry = swp_entry(si->type, offset);
+
 fail:
 	return entry;
 }
 
-/* Free a slot allocated by swap_alloc_hibernation_slot */
+/**
+ * swap_free_hibernation_slot() - Free a swap slot allocated for hibernation.
+ * @entry: swap entry to free.
+ *
+ * The caller must ensure the swap device is stable.
+ */
 void swap_free_hibernation_slot(swp_entry_t entry)
 {
-	struct swap_info_struct *si;
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
 	pgoff_t offset = swp_offset(entry);
 
-	si = get_swap_device(entry);
-	if (WARN_ON(!si))
-		return;
-
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
@@ -2135,7 +2140,6 @@ void swap_free_hibernation_slot(swp_entr
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
_

Patches currently in -mm which might be from youngjun.park@lge.com are

maintainers-add-myself-as-reviewer-for-swap.patch
mm-swap-pm-hibernate-fix-swapoff-race-in-uswsusp-by-pinning-swap-device.patch
mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch

