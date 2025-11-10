Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB6931B138
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799977; cv=none; b=FpxsKc7qe2Yuyp6DTyba2ocJx/HJeIXaK5rGFNHxXSSqcCj+vdu6p7V0cohHUfqwoSYz64C+Z43rzL4Ko7+YtjLaKEBa1vaIYX0bTbxCb6EWgNEdOqHLv/NboH3P8kcwZ3B0wUlc60agLg9SaOj5mEp7sxSmpm5jhdgfxEAtDF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799977; c=relaxed/simple;
	bh=hDbKyaN4zII/v0rYm+zkYNBne60gGmTEsHjQZGRFTKI=;
	h=Date:To:From:Subject:Message-Id; b=tHj+XfW3g1uaVtJpAwME1xuwDm3RoIfJktVyhHjtV44zJau1JYGK+jYyPgefAnmXk84F919/8YpjQsLSrrZeb29b0G58krkYOg24/3ZW9uvly7ckQoQfsiiLDzHVNGPqdRH++ddOI/cw1Naq8PjaQZiHkCKOk2GTU3DUxZokO1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIUWewBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIUWewBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89740C116D0;
	Mon, 10 Nov 2025 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762799976;
	bh=hDbKyaN4zII/v0rYm+zkYNBne60gGmTEsHjQZGRFTKI=;
	h=Date:To:From:Subject:From;
	b=qIUWewBD1yfQ1dFXDmTUa/U/V+NJJ2hIbtfTGU8yAzltyR9/uBxJdJaM9icWhpTC1
	 tHOjJmp7eM+R/5an9YcO1ZY/a3P5T8/klO4g7o/Uvb6pw01loCmwVUgNGYzdNdeYJ5
	 dfAPenVADdat0gUv0gT+AX8jkbI3LvjJ2sIX1Qyk=
Date: Mon, 10 Nov 2025 10:39:35 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch added to mm-new branch
Message-Id: <20251110183936.89740C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix
Date: Mon Nov 10 10:38:51 AM PST 2025

fix whitespace oddity

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix
+++ a/mm/khugepaged.c
@@ -1806,8 +1806,8 @@ static void retract_page_tables(struct a
 		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
 		 * it is still possible for a racing userfaultfd_ioctl() or
 		 * madvise() to have inserted ptes or markers.  Now that we hold
-		* ptlock, repeating the retractable checks protects us from
-		* races against the prior checks.
+		 * ptlock, repeating the retractable checks protects us from
+		 * races against the prior checks.
 		 */
 		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

