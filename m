Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47012D8DD0
	for <mm-commits@vger.kernel.org>; Thu,  9 Apr 2026 22:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775772501; cv=none; b=BfCRh9F6duQ6z0I/PeSVyzfmsqfst6+fbSlYtmEjoBQIS4zrOyz0rxenCkxlsao65adv6phQqjPJZ7rz5nhlVQfdfa50tdZkpuS97OYt5Wae5GP3uXzom8/8fuAWanKMJaW/L30OHtuBQEBK4oPcdbQ8cx8ITS5rtYscHnrBNl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775772501; c=relaxed/simple;
	bh=morlIX2x4Ba+4dcxdFo8myDYOV5RRVklzzRugT1QAiU=;
	h=Date:To:From:Subject:Message-Id; b=nm7+q8q+zOlKMX40qklQs9Qq7fByP1C3NLnWptGm/IVScBgX+LIQM74Bl8MH58hz/OaX6CtlO1xyFHF95RwDiKeiHaifmpXGTUkjm/qJk+bO9Ieo6a5BNZ9erl30R9pMMbozkRiMIfxzhvw03Rg/3a5UYSE4+Se2/dYfruf3a5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xA7Z47Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xA7Z47Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62554C4CEF7;
	Thu,  9 Apr 2026 22:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775772501;
	bh=morlIX2x4Ba+4dcxdFo8myDYOV5RRVklzzRugT1QAiU=;
	h=Date:To:From:Subject:From;
	b=xA7Z47GcZSB3CfTfldSDG3LiRJdu9qNuj1AqbkgsynEGIUaWUuWJHK0dj2dSp3Pjh
	 mDAaJgmNPFkzuHrYoRX7V0NRPWgV0ECotxKamu3cMtJH/EM3pu/9b4X/fFmvohnxkW
	 5ygV6j47/ti3x5oBDpjYIwqCq30tyY/DcdPbPE24=
Date: Thu, 09 Apr 2026 15:08:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-error-handling-in-kho_add_subtree.patch added to mm-unstable branch
Message-Id: <20260409220821.62554C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix error handling in kho_add_subtree()
has been added to the -mm mm-unstable branch.  Its filename is
     kho-fix-error-handling-in-kho_add_subtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-error-handling-in-kho_add_subtree.patch

This patch will later appear in the mm-unstable branch at
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

Link: https://lkml.kernel.org/r/20260407-kho_fix_send-v1-1-b21977feb960@debian.org
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

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-kexec-metadata-track-previous-kernel-chain-fix.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

