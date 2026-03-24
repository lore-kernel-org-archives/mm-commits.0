Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E6335AC0C;
	Tue, 24 Mar 2026 21:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388473; cv=none; b=NGNSfNgTc+Zr8RVFBoutrriDsQv71LSctlWfuTYLw0c94lejy4sQ9AzgE0vC3qnQk3vmv993GKI/eL1dg0CBHwpvca2wEkbCdkfDg8ukkSFfQh/gtjmxAVoKtxh3dZKVs1DUnIRMaXXHX8AGFw/XFqU8tVpbmU4nZzUqv2O8p5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388473; c=relaxed/simple;
	bh=bweIcAyabg5TG1diVnVNaGrd6gYn+9SwZSe6VcLlZDA=;
	h=Date:To:From:Subject:Message-Id; b=lxnU/Km6dGKc4/vzN7+iMBVCFL+G3osC4yAs84/2IB4MxBBTTHPDdSL4C77jhVd319Rn55qC9XG+bXqrR3AQR4G4nPJAJUXnFYLdO+hTgm28R7Lcz75t+bdVC+2osclU1PJJTMTFC1v8LROObf+SirDaQUyLosfjt909sJgckoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X7Y43cO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X7Y43cO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21B1C19424;
	Tue, 24 Mar 2026 21:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388473;
	bh=bweIcAyabg5TG1diVnVNaGrd6gYn+9SwZSe6VcLlZDA=;
	h=Date:To:From:Subject:From;
	b=X7Y43cO1TAmvMW+Vt0w0ZxUOk/fE0/y92O37cEUWA1aBotZhBg3L09ivcm9hSFurC
	 jhTPJjy0nVURpxwIQdxDK+Dr/BWNnJv+23nf+0UR7LGZBM2SSBA/rtpuicY1dvWdSs
	 M0WNAOwt9XukyTxxSlEHXl+LqqUPx9pINn5GFgQE=
Date: Tue, 24 Mar 2026 14:41:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,mail@carstengrohmann.de,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-speed-up-hibernation-allocation-and-writeout.patch removed from -mm tree
Message-Id: <20260324214112.E21B1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: speed up hibernation allocation and writeout
has been removed from the -mm tree.  Its filename was
     mm-swap-speed-up-hibernation-allocation-and-writeout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: speed up hibernation allocation and writeout
Date: Mon, 16 Feb 2026 22:58:02 +0800

Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
hibernation has been using the swap slot slow allocation path for
simplification, which turns out might cause regression for some devices
because the allocator now rotates clusters too often, leading to slower
allocation and more random distribution of data.

Fast allocation is not complex, so implement hibernation support as well.

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
performance is several times better [1]:
6.19:               324 seconds
After this series:  35 seconds

Link: https://lkml.kernel.org/r/20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Reported-by: Carsten Grohmann <mail@carstengrohmann.de>
Closes: https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org/
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swap-speed-up-hibernation-allocation-and-writeout
+++ a/mm/swapfile.c
@@ -1926,8 +1926,9 @@ out:
 /* Allocate a slot for hibernation */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
-	struct swap_info_struct *si = swap_type_to_info(type);
-	unsigned long offset;
+	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
 
 	if (!si)
@@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
 			/*
-			 * Grab the local lock to be compliant
-			 * with swap table allocation.
+			 * Try the local cluster first if it matches the device. If
+			 * not, try grab a new cluster and override local cluster.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, NULL);
+			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+			if (pcp_si == si && pcp_offset) {
+				ci = swap_cluster_lock(si, pcp_offset);
+				if (cluster_is_usable(ci, 0))
+					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+				else
+					swap_cluster_unlock(ci);
+			}
+			if (!offset)
+				offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);
_

Patches currently in -mm which might be from kasong@tencent.com are


