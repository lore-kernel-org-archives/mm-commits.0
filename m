Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A59359A66
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303196; cv=none; b=mH4w6aSEBXA8F/MclxY7JG7v4pCgrx8ZlK8S8zebXd7uFakzQwtGgN0zHq4hz9CjIGBBdKMnw/xpFMFExTYvV6HOy6Zyso7RrkT0BlzCRQyFgMb3tvjC6h5+VUL9V795+mwP1m1Qbx0Lpo/y10LrQOh84QCYDvPFn0RY6IE8Bc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303196; c=relaxed/simple;
	bh=tYHpC57lHANnZTZWTjXJrYraiU1uLk3H1y3K0O/3w7w=;
	h=Date:To:From:Subject:Message-Id; b=JjaYG+Sdug0ytLMegdwS5qUYOqtS8/sOg4XM0VXe6iSl1qkBwNg2UrOBWVuRojBhLcxKYi0O99D+FxRb1hXAmlGuiMN7x6oG5m/1aEn8abW2kYdV2dcemvxKyeDTz/rHNJq4sYJthggB/12CoTO6fqvJGIj4IJGwftE4K9n+j5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZwlBArX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZwlBArX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D875C4CEF7;
	Mon, 23 Mar 2026 21:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774303196;
	bh=tYHpC57lHANnZTZWTjXJrYraiU1uLk3H1y3K0O/3w7w=;
	h=Date:To:From:Subject:From;
	b=vZwlBArX2oV5BsLPpr+OjUNeQX4VC5odFnbs8ERsvqviNhtrjFEKj6E28qNpeK8jl
	 yotUUXjqKErDb7zgq8y0QLQ2niHbLVPo6R55h20jYfCUWrVQJ29Ls1uJHG/5jpUmP5
	 V/nNPIn7QIxcA879XlkHGc7HHfHdtOOFvpJ94x8Y=
Date: Mon, 23 Mar 2026 14:59:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch added to mm-nonmm-unstable branch
Message-Id: <20260323215956.4D875C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix kho_in_debugfs_init() to handle non-FDT blobs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20260316-kho-v9-4-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
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

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch
mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

