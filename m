Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA18525D8E6;
	Wed, 26 Feb 2025 22:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608893; cv=none; b=sQFEEUDp4P2pGVY7nqo3pQSjZU8fG5QEqGVhCwT8hffKzZ0uhVcPAnjtPAiosJG6lnWeQdmL6kygZvQqq1iqxzLwS8ppnrM8yu4YuB1/b7OOPaztPDAA1798JUOsWug8f9WlS5oVmlGpkltvVQX8KQtTu4absgHdh02RfHrdMsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608893; c=relaxed/simple;
	bh=BMeDzl1zxvxT6RodstGj8AYYyAqmq+zj0xWxdFig3kE=;
	h=Date:To:From:Subject:Message-Id; b=Ztkt0QGI9TRiCsj2AHmQREb6SoqRZal4BgT0KO9VVtKoMrdSAH0vNyAh5WN3NXJ72H9lk6O7EJgB66vALB1g7xVJvI7R2TBxCwBzMbSkUdSYWi7uV1tMEhdrhqn7lzGN+PXZW1IfOInu/TKooSAVJcTy1hsGzznuhhFnB4O9fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rPKJSJNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rPKJSJNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBD2C4CED6;
	Wed, 26 Feb 2025 22:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608893;
	bh=BMeDzl1zxvxT6RodstGj8AYYyAqmq+zj0xWxdFig3kE=;
	h=Date:To:From:Subject:From;
	b=rPKJSJNpcVJT+64akyKhnX6Azk6oDvRRLyLI8BfRuJxMznwzANgdxLUWIC4LWwekG
	 EPv9WO9awftOY2g//Wz/sfUZaPH95Pwk2wteDq73DYk+vEWruOZt2LmdCitgU11Ndq
	 Tndc2cee/2uMwv4Aon67Cnc9dDSkvqcg0NzITYG4=
Date: Wed, 26 Feb 2025 14:28:12 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,hch@infradead.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226222813.1EBD2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't skip arch_sync_kernel_mappings() in error paths
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch

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

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch

