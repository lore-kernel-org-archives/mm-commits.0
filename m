Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26E4F610;
	Mon, 12 Feb 2024 23:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780110; cv=none; b=ZviS7ELztHyx9rGWO15eFUE2SS3BeaZBQE1cIInJKBrrmE2NYQc6wT9SRaCE8xYh2bRKDqo9GlwJCDsTlPRso1TjFUpiDYmnmeFIVOJJ/2I0zC6NEyu3DzrQKuxI+9+Vo0P5IVNmTWH5YTFCcTyzJM1dhvspM/5Wwf6RawPGFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780110; c=relaxed/simple;
	bh=M+NK3H9EAiRTnxuj1er58hwV2l+kEdV/fbZVFA3drmM=;
	h=Date:To:From:Subject:Message-Id; b=UxJaOn5n8ZAh10wftGemtoPGdZLBko1CjvnQNz4BseujtFRc8dsCtxGiG8+Ee+q5hq6fgbqj/bnPmprQnMvhUnNzryzSaq9xpLa4fZ1N5nE5oc1b9V9JbwjcE/vg5h2NmDW1IvX2UtjvHoCcRaLY8tV0+byZf5/hFrOZkPY2xC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ia8ck2Sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ia8ck2Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE37FC433C7;
	Mon, 12 Feb 2024 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707780109;
	bh=M+NK3H9EAiRTnxuj1er58hwV2l+kEdV/fbZVFA3drmM=;
	h=Date:To:From:Subject:From;
	b=ia8ck2SbzDuPE4SMrtpmXtFJXAFJPgCQfaqvLfo5GwBXPZ/kVQH+/pdi3OZiw+Qi/
	 SqIcksbC7wlrJSGsrQcY816aJHvHqYaVzfQouaTZ4bWI8iIQwIZ9WZoatrR+E1AFA2
	 ezEyWz4S+qgEg/MVK5JcUQ/mGyRhY5XHB2LgoFfU=
Date: Mon, 12 Feb 2024 15:21:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch removed from -mm tree
Message-Id: <20240212232149.BE37FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: add display flag for VM_MAYOVERLAY
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: fs/proc/task_mmu: add display flag for VM_MAYOVERLAY
Date: Thu, 8 Feb 2024 14:18:05 +0530

VM_UFFD_MISSING flag is mutually exclussive with VM_MAYOVERLAY flag as
they both use the same bit position i.e 0x00000200 in the vm_flags.  Let's
update show_smap_vma_flags() to display the correct flags depending on
CONFIG_MMU.

Link: https://lkml.kernel.org/r/20240208084805.1252337-1-anshuman.khandual@arm.com
Fixes: b6b7a8faf05c ("mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-add-display-flag-for-vm_mayoverlay
+++ a/fs/proc/task_mmu.c
@@ -681,7 +681,11 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_HUGEPAGE)]	= "hg",
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
 		[ilog2(VM_MERGEABLE)]	= "mg",
+#ifdef CONFIG_MMU
 		[ilog2(VM_UFFD_MISSING)]= "um",
+#else
+		[ilog2(VM_MAYOVERLAY)]	= "ov",
+#endif /* CONFIG_MMU */
 		[ilog2(VM_UFFD_WP)]	= "uw",
 #ifdef CONFIG_ARM64_MTE
 		[ilog2(VM_MTE)]		= "mt",
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch

