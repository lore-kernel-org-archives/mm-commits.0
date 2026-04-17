Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B308F2744F
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 05:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776404984; cv=none; b=VJ5b88D7fW9FOEAf7s3wjfkgJvekMusFNJYzD8u04JVrPD5/6KMIFrYMHqAD8RkJ9MwqYQMvnwlLxVROeKIJTC9na41GM6CYhIlBCmH0yqnWThgHBsSIG0V9jTtisJrPCB6APSD60e1wkYN1uMJ2mrrfrkK+tFlfxJTaU6UCMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776404984; c=relaxed/simple;
	bh=kjrWZJbcX/4TMFbBYbCG0kYP6KjHXOFRXKbmmVl5gPQ=;
	h=Date:To:From:Subject:Message-Id; b=nppDgKVngGPVSiqolg4C6gppUhR79xbOk051wQuHXsUmF0bb5AzomsmQ91IJkUo1luno8nkI+46DwkVahQt15Buw1Jb8AF9/QD2u4MbdrxgxYCFt73mHZhpKrDHRr1tn/M8yS1Hg1bJc5ELMO1/BtnT7yjDEm71NvILb/Uz8EOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gm5Q0e+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gm5Q0e+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1BAC19425;
	Fri, 17 Apr 2026 05:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776404984;
	bh=kjrWZJbcX/4TMFbBYbCG0kYP6KjHXOFRXKbmmVl5gPQ=;
	h=Date:To:From:Subject:From;
	b=gm5Q0e+M+ufURH0vuRbYoXywERncxu+jLLUKGNuceb+WYKOL8/CUuq9ucPmI6+gHY
	 oNByn9fr/XVRR4lkvs3ay7NAxOBeLR1wG56QZPZWlso1EkRpZRtRs2uh3QZ+jjTIiJ
	 XZrYZsjHeCxZEG1C80s0+Tch4VNAxMhGM5vX6a+I=
Date: Thu, 16 Apr 2026 22:49:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-kexec-metadata-track-previous-kernel-chain-fix.patch removed from -mm tree
Message-Id: <20260417054943.2F1BAC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: call kho_kexec_metadata_init() for both boot paths
has been removed from the -mm tree.  Its filename was
     kho-kexec-metadata-track-previous-kernel-chain-fix.patch

This patch was dropped because it was folded into kho-kexec-metadata-track-previous-kernel-chain.patch

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: call kho_kexec_metadata_init() for both boot paths
Date: Thu, 09 Apr 2026 03:31:40 -0700

kho_kexec_metadata_init() was placed after the fdt check, causing it to
run only on the fresh boot path (no incoming FDT) and skipping metadata
initialization on the KHO restore path.

The original patch[1] was based on commit 5c9e55fecf93658 ("Add linux-next
specific files for 20260312"), which included commit d7176a010afce8 ("kho:
fix deferred init of kho scratch").  That commit has since been rebased
and reworked in linux-next, changing the code flow so that
kho_kexec_metadata_init() is no longer reached on the restore path.

Fix this by moving the call before the fdt check so it runs regardless of
whether an incoming FDT is present.

Link: https://lore.kernel.org/all/20260309-kho-v8-5-c3abcf4ac750@debian.org/ [1]
Link: https://lore.kernel.org/20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-kexec-metadata-track-previous-kernel-chain-fix
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1519,15 +1519,15 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
 	}
 
-	err = kho_kexec_metadata_init(fdt);
-	if (err)
-		goto err_free_fdt;
-
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
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
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

