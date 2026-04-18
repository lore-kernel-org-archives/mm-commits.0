Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E1819D8A8
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498721; cv=none; b=HXhsrHehj9Vv3UReZ54EEU1fAvx9hbe/JYZaCgof0hZZljbeTh85IWiAxqpvZ71o2Srj04OqjN7ZDmGkEsnmaZ5JGnQbnkTvG75YQCLYp9t6JETAU4nKJva6UfBQUel9zeKWh5BZS+HQFC6E4WwAQzSWOX0kFUKj/8TnbKpBlPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498721; c=relaxed/simple;
	bh=bVbeGPKeiv6tXCgZJyl81zA+id8LmnfM3xXSmk6Qook=;
	h=Date:To:From:Subject:Message-Id; b=R9BMax0+OxGq6XD2aldTFDfzioHrTW//RpTH8BqwL5HkOlco22j/GXlTVxyaIfjccY0wrk5RAGSEVD/eTXvWpRF+hykgvI3RX/svC9mYmI7JmJNrL+Xn9B0PV27/i2YxL/nbuAf0gCfX5pw74Z0pSGzaPAuDCNiurosQ31L1Sio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4UEqijc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4UEqijc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55578C19424;
	Sat, 18 Apr 2026 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498720;
	bh=bVbeGPKeiv6tXCgZJyl81zA+id8LmnfM3xXSmk6Qook=;
	h=Date:To:From:Subject:From;
	b=S4UEqijcNQZzuC60edd50VKWdURWnPjRre3Ve3jn+BAWGXKV2/9wMDMW8MWQAk62o
	 BQUix185AythtsWwCS/vsL6jHzyym7e7ad/0OpJE/8V6Z47/DhfP32/eU5iZ6dEblx
	 BS0u656OjQtlJSR/awlpPIpZqoIPTdulrNceK0RA=
Date: Sat, 18 Apr 2026 00:51:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch removed from -mm tree
Message-Id: <20260418075159.55578C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix kho_in_debugfs_init() to handle non-FDT blobs
has been removed from the -mm tree.  Its filename was
     kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: fix kho_in_debugfs_init() to handle non-FDT blobs
Date: Mon, 16 Mar 2026 04:54:34 -0700

kho_in_debugfs_init() calls fdt_totalsize() to determine blob sizes, which
assumes all blobs are FDTs.  This breaks for non-FDT blobs like struct
kho_kexec_metadata.

Fix this by reading the "blob-size" property from the FDT (persisted by
kho_add_subtree()) instead of calling fdt_totalsize().  Also rename local
variables from fdt_phys/sub_fdt to blob_phys/blob for consistency with the
non-FDT-specific naming.

Link: https://lore.kernel.org/20260316-kho-v9-4-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover_debugfs.c |   32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -122,24 +122,34 @@ __init void kho_in_debugfs_init(struct k
 	fdt_for_each_subnode(child, fdt, 0) {
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-		void *sub_fdt;
+		const u64 *blob_phys;
+		const u64 *blob_size;
+		void *blob;
 
-		fdt_phys = fdt_getprop(fdt, child,
+		blob_phys = fdt_getprop(fdt, child,
 					KHO_SUB_TREE_PROP_NAME, &len);
-		if (!fdt_phys)
+		if (!blob_phys)
 			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node %s prop fdt has invalid length: %d\n",
-				name, len);
+		if (len != sizeof(*blob_phys)) {
+			pr_warn("node %s prop %s has invalid length: %d\n",
+				name, KHO_SUB_TREE_PROP_NAME, len);
 			continue;
 		}
-		sub_fdt = phys_to_virt(*fdt_phys);
+
+		blob_size = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+		if (!blob_size || len != sizeof(*blob_size)) {
+			pr_warn("node %s missing or invalid %s property\n",
+				name, KHO_SUB_TREE_SIZE_PROP_NAME);
+			continue;
+		}
+
+		blob = phys_to_virt(*blob_phys);
 		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     sub_fdt, fdt_totalsize(sub_fdt));
+					     blob, *blob_size);
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
-				ERR_PTR(err));
+			pr_warn("failed to add blob %s to debugfs: %pe\n",
+				name, ERR_PTR(err));
 			continue;
 		}
 	}
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

