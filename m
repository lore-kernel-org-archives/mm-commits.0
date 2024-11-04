Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C264C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694997; cv=none; b=IRV7nD2AKIYCtzCFg+8OnlEeAHHL9C/2fHwgUl5n0Ph78Xqpf1PCk8HFh5V8DtwnYTvYVH+WJlTj5FYagmdvJLvo+7QUNhfGrRsX1p/od8Jdpz2eJv8siRbL/X4GJAxvJhZh/7XnYJ9z4A+bpxNlb0E6szTWnUZkTAJoMxL7CNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694997; c=relaxed/simple;
	bh=WyDiSVTENYUX5mgJdMefdQi7bXsRa4rugHvLtn0n9lc=;
	h=Date:To:From:Subject:Message-Id; b=Lz8fjJJOqGdECHCxxO2Smx7d5WoA6KdCEoVWOYYSJDpBw/EFEZUkX6eX4uaw7fSekuH0VyCNJJJsaUZMxdv+sIj82O/UneqsaPfqMRODi6DHWKELic+OyKXmBBvyUfTKt3ss+2iE724ah17pnb8ZJdac02E/i0bAI0d6bZkfU0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtd5WUvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtd5WUvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9842C4CECE;
	Mon,  4 Nov 2024 04:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730694996;
	bh=WyDiSVTENYUX5mgJdMefdQi7bXsRa4rugHvLtn0n9lc=;
	h=Date:To:From:Subject:From;
	b=rtd5WUvgfDadcbc2BLObELufej8rKpw0/fFYfU7rQBlzFlqXiBilVKGBqZFLrWsDv
	 3B0cUdacJHmFn3QtFursqiC6RLRWpkKn8UnoZ4nxcjCSc15D51vCeZKl/lq48nZYN9
	 QRvxWDUuYGHMyCNoAyDRpGik3lGWHCFzoh1w9Tmc=
Date: Sun, 03 Nov 2024 20:36:36 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-refactor-mm_access-to-not-return-null-fix.patch removed from -mm tree
Message-Id: <20241104043636.D9842C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: procfs: prefer neater pointer error comparison
has been removed from the -mm tree.  Its filename was
     mm-refactor-mm_access-to-not-return-null-fix.patch

This patch was dropped because it was folded into mm-refactor-mm_access-to-not-return-null.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: procfs: prefer neater pointer error comparison
Date: Wed, 25 Sep 2024 08:48:27 +0100

We can compare a pointer to a known error code via PTR_ERR(ptr) == -EINVAL
or via ptr == ERR_PTR(-EINVAL) - the latter is neater and collects the
macro and constant in one, so refactor to use this form in
proc_mem_open().

Link: https://lkml.kernel.org/r/2fae1834-749a-45e1-8594-5e5979cf7103@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~mm-refactor-mm_access-to-not-return-null-fix
+++ a/fs/proc/base.c
@@ -841,7 +841,7 @@ struct mm_struct *proc_mem_open(struct i
 	put_task_struct(task);
 
 	if (IS_ERR(mm))
-		return PTR_ERR(mm) == -ESRCH ? NULL : mm;
+		return mm == ERR_PTR(-ESRCH) ? NULL : mm;
 
 	/* ensure this mm_struct can't be freed */
 	mmgrab(mm);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-defer-second-attempt-at-merge-on-mmap-fix.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

