Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D03E0243
	for <mm-commits@vger.kernel.org>; Thu,  9 Apr 2026 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748526; cv=none; b=RvTAbf4GibqbipRelwdYVz2IKKgGQOjrpcMy69SCLUG5I2PDA2JVfVegDALTYTTfPD/ptgrfl3kP381Rkj7rBfLdpSKKqFVVGNRIoJFutRCObdZLn8L4KcdiCYGZjXb1YVOnfbUEi9f+ioUaKVh8EqKD2kbix9/lm/Cuoz6cKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748526; c=relaxed/simple;
	bh=C/NgmAtiaZGe9/YCmzgugYyjheo+ntIChzh25ddw5rw=;
	h=Date:To:From:Subject:Message-Id; b=patvmiqnNdbs4//WyzEVDmZhvMMOwldnx3PBkrcQ0dHYfUJYZ1IWyJlfru1RXEm71dRDS4e20ls0UcbcRkNPgL7/RrZn3y0EMSSM2LrTT6JaNbfbmam9xs4KdcLF8n2ppZW95hFFfvWTzudiuWoa5N0+vOny4kc+t8d9BjXv1/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3Fq7wQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3Fq7wQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D308EC2BC9E;
	Thu,  9 Apr 2026 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775748525;
	bh=C/NgmAtiaZGe9/YCmzgugYyjheo+ntIChzh25ddw5rw=;
	h=Date:To:From:Subject:From;
	b=v3Fq7wQeujSNsxe2MgpqyEuufb/BUqZo3h9LohWrQpzLaXmkd0QP1b9HwwCvc/xH6
	 AwqU4rdK63dJXqqJ7AzZrLaIbfZocxD3qm4chZHx/9AZPsveZh/Q/uIhbiiM8JNCtx
	 QNppGIAqItOqh/ufa9dB9sPafagBjUcwGwr/rm14=
Date: Thu, 09 Apr 2026 08:28:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-kexec-metadata-track-previous-kernel-chain-fix.patch added to mm-unstable branch
Message-Id: <20260409152845.D308EC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: call kho_kexec_metadata_init() for both boot paths
has been added to the -mm mm-unstable branch.  Its filename is
     kho-kexec-metadata-track-previous-kernel-chain-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-kexec-metadata-track-previous-kernel-chain-fix.patch

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
Link: https://lkml.kernel.org/r/20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org
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

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-kexec-metadata-track-previous-kernel-chain-fix.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

