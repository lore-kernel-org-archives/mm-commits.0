Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD223254A0
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773257080; cv=none; b=YeQKywWyDw7acVLtUOp49d8rb+bFcrUdPylBF0QJQR6PeKUUsYbk2DQpQVpa2bPYJWhtv5UZlHsho3MI7MzdxcfoBDkj7CWEKlfc6knZd8Rl1AgO31AFD53WnhT349UczuNtih85OfmBdC0CAAu1iFCUiOOCXH93ZBSRBnEFtSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773257080; c=relaxed/simple;
	bh=K42CDLC3Rm688x0SIfESXISo34t9k46lEaiboB6uJ5c=;
	h=Date:To:From:Subject:Message-Id; b=pY401D/bNKWrnok1eykkErCgsTQ9vFLfGVX+sHP6KChHTvH66nBLX5F0clLrzzm8uV3gb7XlBMMC7NDank+/yiwxkCP75ptW64b77Sr4eJD6Zf4pDDfYCpzk8DybtPyLCCgkI3r+H/bp26dPU5VCBy9Npf7/eXxO4iGHUbVoFVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yj6Pp4Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yj6Pp4Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A143C4CEF7;
	Wed, 11 Mar 2026 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773257080;
	bh=K42CDLC3Rm688x0SIfESXISo34t9k46lEaiboB6uJ5c=;
	h=Date:To:From:Subject:From;
	b=yj6Pp4Zc8bExGesHYn7JQCBQmlJRyyxacc5d0nXc/blkCNMS+dc5zyXPZS/gU9zsQ
	 Lt/1jtRhCSgwRIiCqkLEy1Q4Bbgvkb6kfBZBcAC2zHOrF286CzZx3LEAEMBOipP1OE
	 98vwEWW4B+2pMgQT5fVfVS37aOE9KvzHJW7oMIkg=
Date: Wed, 11 Mar 2026 12:24:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch added to mm-new branch
Message-Id: <20260311192440.6A143C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pagemap_ioctl: remove hungarian notation
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: pagemap_ioctl: remove hungarian notation
Date: Wed, 11 Mar 2026 20:07:37 +0200

Replace lpBaseAddress with addr and dwRegionSize with size.

Link: https://lkml.kernel.org/r/20260311180737.3767545-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-remove-hungarian-notation
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -113,13 +113,13 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *lpBaseAddress, long dwRegionSize)
+int wp_init(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		ksft_exit_fail_msg("ioctl(UFFDIO_REGISTER) %d %s\n", errno, strerror(errno));
@@ -127,8 +127,8 @@ int wp_init(void *lpBaseAddress, long dw
 	if (!(uffdio_register.ioctls & UFFDIO_WRITEPROTECT))
 		ksft_exit_fail_msg("ioctl set is incorrect\n");
 
-	wp.range.start = (unsigned long)lpBaseAddress;
-	wp.range.len = dwRegionSize;
+	wp.range.start = (unsigned long)addr;
+	wp.range.len = size;
 	wp.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp))
@@ -137,21 +137,21 @@ int wp_init(void *lpBaseAddress, long dw
 	return 0;
 }
 
-int wp_free(void *lpBaseAddress, long dwRegionSize)
+int wp_free(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
 		ksft_exit_fail_msg("ioctl unregister failure\n");
 	return 0;
 }
 
-int wp_addr_range(void *lpBaseAddress, int dwRegionSize)
+int wp_addr_range(void *addr, int size)
 {
-	if (pagemap_ioctl(lpBaseAddress, dwRegionSize, NULL, 0,
+	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN) < 0)
 		ksft_exit_fail_msg("error %d %d %s\n", 1, errno, strerror(errno));
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch
mm-rename-my_zero_pfn-to-zero_pfn.patch
arch-mm-consolidate-empty_zero_page.patch
mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch
userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

