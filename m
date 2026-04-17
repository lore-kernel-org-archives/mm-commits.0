Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDA2E8897
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 05:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405331; cv=none; b=mJnhldv5FlWLimtH/AI1dTwIcBPhFZkgpd5XeCe/z7JcySccZNAezc7rs3IicAP989Hi+hdl7n/ozFKtF3+5QO0xEm5qWBWHrpPXudGdt/wR5vN8VrzeN9vJeXvfWWJseB/rXmzCpc4h8+Dtqz160wmZSwVdCnpQekZ5FX/cWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405331; c=relaxed/simple;
	bh=5HslYlDaq9o2QxFlwsDVMkdUJnszyOhNpNMk6aUT4Yo=;
	h=Date:To:From:Subject:Message-Id; b=L4/B6iUjOKTCVC9lvBlGwYexTyPgH9UQfQ7SJP8QOZ+5SJUQtyOpxcrwJETfnqANiUjFdwHQfIPcks7Dqh2yW4gB2AGCYOVzX7iVaV9mylBdi7ZKS5/YF/4t3ZbfhDKjl5sFJya/dK1P/0RaPENhTkBEsQ79nuUbtDHiJOQsHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCs7Qv8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCs7Qv8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D190AC19425;
	Fri, 17 Apr 2026 05:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776405331;
	bh=5HslYlDaq9o2QxFlwsDVMkdUJnszyOhNpNMk6aUT4Yo=;
	h=Date:To:From:Subject:From;
	b=ZCs7Qv8Eeq3WlSO0k9a0SgXIyrj1Q/lGiOq1X5UQqXQYexUCDWmkxgDcJzovxrorz
	 9CSIImdFZoX0aAQVbf46QgmxblhhnJWKBIGrVVTixKLCp6/9ivPW0sOeTX7CxoPGM5
	 qtGbdZHAS/wLR9sZBROjPocWXTwdY5wLxJgmiDT0=
Date: Thu, 16 Apr 2026 22:55:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kho-fix-error-handling-in-kho_add_subtree.patch removed from -mm tree
Message-Id: <20260417055530.D190AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix error handling in kho_add_subtree()
has been removed from the -mm tree.  Its filename was
     kho-fix-error-handling-in-kho_add_subtree.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: fix error handling in kho_add_subtree()
Date: Tue, 07 Apr 2026 10:01:47 -0700

Fix two error handling issues in kho_add_subtree(), where it doesn't
handle the error path correctly.

1. If fdt_setprop() fails after the subnode has been created, the
   subnode is not removed. This leaves an incomplete node in the FDT
   (missing "preserved-data" or "blob-size" properties).

2. The fdt_setprop() return value (an FDT error code) is stored
   directly in err and returned to the caller, which expects -errno.

Fix both by storing fdt_setprop() results in fdt_err, jumping to a new
out_del_node label that removes the subnode on failure, and only setting
err = 0 on the success path, otherwise returning -ENOMEM (instead of
FDT_ERR_ errors that would come from fdt_setprop).

Link: https://lore.kernel.org/20260407-kho_fix_send-v1-1-b21977feb960@debian.org
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-error-handling-in-kho_add_subtree
+++ a/kernel/liveupdate/kexec_handover.c
@@ -762,19 +762,24 @@ int kho_add_subtree(const char *name, vo
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
-			  &phys, sizeof(phys));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
+			      &phys, sizeof(phys));
+	if (fdt_err < 0)
+		goto out_del_node;
 
-	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
-			  &size_u64, sizeof(size_u64));
-	if (err < 0)
-		goto out_pack;
+	fdt_err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			      &size_u64, sizeof(size_u64));
+	if (fdt_err < 0)
+		goto out_del_node;
 
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
+	err = 0;
+	goto out_pack;
+
+out_del_node:
+	fdt_del_node(root_fdt, off);
 out_pack:
 	fdt_pack(root_fdt);
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

