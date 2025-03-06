Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC8119E971;
	Thu,  6 Mar 2025 05:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239472; cv=none; b=L6kOdTiu0zVhTOjeWiEe2kKZvs1A4i+Fxm/owp7qWBvwoa6JeSRkVMXAfwDzADLEiuqwrYu75VBVe3gwAaH0SrxEZwxhkwrxpQ4n1+9on9OIfCJguFofJeztxwV0y7AJBcvKP5h/eht1iNJsgy92cjLyE33C5eFhIUowYGe2j3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239472; c=relaxed/simple;
	bh=S2l8rV+bdh4PUE44lsR8vKLHeLZo+PZ4iBQ7YAAQ5d0=;
	h=Date:To:From:Subject:Message-Id; b=aN5hUJKIU1cIKEx7eXw45L7G5LzyZXjn+HhBZf+7fONZ7Uxaw6DSBZMSpKRbzkqIVJiBgQSgZcW78hw2/VAvNFtFkJeQxbvLSjtOkBPjIHiSv0JRUqHbjRbMIuC/mzc/DNz1YYzypq/JicyPbozIzJMozfEUC00dEcQXy0WJKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e8vywQwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e8vywQwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75271C4CEE4;
	Thu,  6 Mar 2025 05:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239472;
	bh=S2l8rV+bdh4PUE44lsR8vKLHeLZo+PZ4iBQ7YAAQ5d0=;
	h=Date:To:From:Subject:From;
	b=e8vywQwGhlVeRvU56zTPCiVQWHEBvOcjIhK89RQ8FrBnx74ebxf3A1p6xD1cpHYVl
	 1pegTlod/CcPqdjCduXW/4+SeTJqid575PKkTt50aXNRNRr+LlisBRPYVRXRdyKGV0
	 uG52VyHt+yyuz1MJkZrObxv7kiMMrGYJolgHNdKQ=
Date: Wed, 05 Mar 2025 21:37:51 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,hch@infradead.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch removed from -mm tree
Message-Id: <20250306053752.75271C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't skip arch_sync_kernel_mappings() in error paths
has been removed from the -mm tree.  Its filename was
     mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: don't skip arch_sync_kernel_mappings() in error paths
Date: Wed, 26 Feb 2025 12:16:09 +0000

Fix callers that previously skipped calling arch_sync_kernel_mappings() if
an error occurred during a pgtable update.  The call is still required to
sync any pgtable updates that may have occurred prior to hitting the error
condition.

These are theoretical bugs discovered during code review.

Link: https://lkml.kernel.org/r/20250226121610.2401743-1-ryan.roberts@arm.com
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Fixes: 0c95cba49255 ("mm: apply_to_pte_range warn and fail if a large pte is encountered")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c  |    6 ++++--
 mm/vmalloc.c |    4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-dont-skip-arch_sync_kernel_mappings-in-error-paths
+++ a/mm/memory.c
@@ -3051,8 +3051,10 @@ static int __apply_to_page_range(struct
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(*pgd) && !create)
 			continue;
-		if (WARN_ON_ONCE(pgd_leaf(*pgd)))
-			return -EINVAL;
+		if (WARN_ON_ONCE(pgd_leaf(*pgd))) {
+			err = -EINVAL;
+			break;
+		}
 		if (!pgd_none(*pgd) && WARN_ON_ONCE(pgd_bad(*pgd))) {
 			if (!create)
 				continue;
--- a/mm/vmalloc.c~mm-dont-skip-arch_sync_kernel_mappings-in-error-paths
+++ a/mm/vmalloc.c
@@ -586,13 +586,13 @@ static int vmap_small_pages_range_noflus
 			mask |= PGTBL_PGD_MODIFIED;
 		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
 		if (err)
-			return err;
+			break;
 	} while (pgd++, addr = next, addr != end);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
-	return 0;
+	return err;
 }
 
 /*
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

