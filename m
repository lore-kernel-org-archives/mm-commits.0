Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1122F9C37
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968175; cv=none; b=u+9xZOEl4eDvPZSI2hyZQKoz6AW7JhKYOd9YorRNFGLEUR3tNmC0iiypWKp0ynbLCunJTb2gx9aeSHel6PcmxsvFbwWKl5I1lsKqYW23ogs3I0+XdemN7VcwARWFRgbapNngb39fe345qqPZfKP0AX5FjY62Yd8sT9EELSH7+f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968175; c=relaxed/simple;
	bh=QviGmQ8mNWKeJL43AqpW5wicBrOSW0q9FiTbjlfeC1o=;
	h=Date:To:From:Subject:Message-Id; b=MnTM4eSpANlpjggO07R+99eGdIfGR9hYbDdfPixWNNYcts6JXBZF6VToygFhOEjBCWbvMKiiX+DoCTPdmifznmIQH+mBMTbz/eVdzma2DP1BS9mF0eoqULZPTf13HyQeCpVkrq0iYnl2dmhhLwzO9G+deIJ7C5HBJE6s6zH1hTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H+O2MDeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H+O2MDeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145DA1F00898;
	Tue,  9 Jun 2026 01:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968174;
	bh=wZt46LpvqOaIWI9qY3Zpl579p+UngBkSpiVWHabq4R0=;
	h=Date:To:From:Subject;
	b=H+O2MDeCnRDA2xVi7SXqkxj/uvl6ktR/acasRHEOqMxKHQrRIb4fKguHwTCtu2mep
	 yVdnrEkEelYfIBEDKPzCjX6P/JwvxDzy6PHW3vcA3sdlPE1S3bwrASSttIy2H2uv9m
	 r+b08dHhDmOaVnPSPc0Wuu0Xy1aKqtWQus0Qdt8M=
Date: Mon, 08 Jun 2026 18:22:53 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,rafael@kernel.org,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch removed from -mm tree
Message-Id: <20260609012254.145DA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: remove redundant swap device reference in alloc/free
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260323160822.1409904-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   68 +++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-redundant-swap-device-reference-in-alloc-free
+++ a/mm/swapfile.c
@@ -2138,7 +2138,16 @@ out:
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
@@ -2149,46 +2158,42 @@ swp_entry_t swap_alloc_hibernation_slot(
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
@@ -2196,7 +2201,6 @@ void swap_free_hibernation_slot(swp_entr
 
 	/* In theory readahead might add it to the swap cache by accident */
 	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-	put_swap_device(si);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
_

Patches currently in -mm which might be from youngjun.park@lge.com are


