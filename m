Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9247A1CEEAD
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488062; cv=none; b=KOerLau1AIld1E9hpo1TK1hsA62dS0K/dSLki00FRTmuY7acY6rwPm+qTkZakJKnTb7QU+q9BMtNwR9ZebCqZ/8MFXNqM0RLWPI1GY4fqo+NBy9dLhDkCegBo1+yTEng+SoSlKIy8hERJmAgpG01o2+epiXWHqsg/ZHITHxYfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488062; c=relaxed/simple;
	bh=v2n6ISWu1jhOrvGhyNP8uaYy8qKqG6cLIZLlk72xeIY=;
	h=Date:To:From:Subject:Message-Id; b=jkupCzMqBk1hvY5cfYwGekRIHR9VP8+07rJVmmVuamGdpxQJz5aOt1XZcfEvLb2wVyQ7ejA/HoHUX1dHPES+YUcLkrF7WZZ4wIqMl58d6Df0BIuR87sX50gEMe0aHtPpoT7w0dFuQWRNBTy6+XtG5tukVtpZRUHo4/dfRuS0Hcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qkUdgzYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qkUdgzYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C87EC4CECD;
	Fri,  1 Nov 2024 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730488062;
	bh=v2n6ISWu1jhOrvGhyNP8uaYy8qKqG6cLIZLlk72xeIY=;
	h=Date:To:From:Subject:From;
	b=qkUdgzYYoLTzu7/pmgGr3d91jGwU2KsicTISsN8JhfwSCt/m7/ENaxD1aVRz+3b1x
	 bQdvm3QLLqAds3EsW6lzsK1m58msDF6pKoRwdvSfI7xxo+4pdRXWkKF1gr0dKZ0fzU
	 WPp8MJlDCMfNKs3su5D38LMTPFtO5PAxDshGx6uo=
Date: Fri, 01 Nov 2024 12:07:41 -0700
To: mm-commits@vger.kernel.org,Yibo.Cai@arm.com,slp@redhat.com,lina@asahilina.net,kirill.shutemov@linux.intel.com,justin.he@arm.com,catalin.marinas@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101190742.1C87EC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
Date: Fri Nov  1 12:03:22 PM PDT 2024

coding style tweaks

Cc: Asahi Lina <lina@asahilina.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jia He <justin.he@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sergio Lopez Pascual <slp@redhat.com>
Cc: Yibo Cai <Yibo.Cai@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
+++ a/mm/memory.c
@@ -3081,18 +3081,20 @@ static inline int __wp_page_copy_user(st
 			update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
 	}
 
-	/* If the mm is a remote mm, copy in the page using access_remote_vm() */
-	if (current->mm != mm) {
-		if (access_remote_vm(mm, (unsigned long)uaddr, kaddr, PAGE_SIZE, 0) != PAGE_SIZE)
-			goto warn;
-	}
 	/*
-	 * This really shouldn't fail, because the page is there
-	 * in the page tables. But it might just be unreadable,
-	 * in which case we just give up and fill the result with
-	 * zeroes.
+	 * If the mm is a remote mm, copy in the page using access_remote_vm()
 	 */
-	else if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+	if (current->mm != mm) {
+		if (access_remote_vm(mm, (unsigned long)uaddr, kaddr,
+				     PAGE_SIZE, 0) != PAGE_SIZE)
+			goto warn;
+	} else if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+		/*
+		 * This really shouldn't fail, because the page is there
+		 * in the page tables. But it might just be unreadable,
+		 * in which case we just give up and fill the result with
+		 * zeroes.
+		 */
 		if (vmf->pte)
 			goto warn;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

