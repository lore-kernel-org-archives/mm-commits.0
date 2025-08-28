Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204813DDAA;
	Thu, 28 Aug 2025 05:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359974; cv=none; b=pt9JovCHDbtPcCKhkyM6xGrIBEzswWhbHLw+oHYYteEyMCg6t1AkVfN7w/1gSnwxaFFJQY8WPL9b71SqQJNQgr1W8ycEtyfG2KUfsbCjLASd76ZAEu3KDa/jauIok7+ekEZ/dBeNdihR/3WMFh+VPhDo0iGHz4oB8G99G/ohXaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359974; c=relaxed/simple;
	bh=H+fO6OHkKX0KKwcJfJnIJBoP9qyNE+QYIBDq422I9dQ=;
	h=Date:To:From:Subject:Message-Id; b=a/TdSwz6kK+qVnRpF+qVmDw3lmXPWL9NMBujlR1fOyfLVlMbCTVhPrTmmcQvJN1A7Qfd9MnJ7Jv4ijtDR1m90RjC5O4zi0qdwOuGywkfqBgV8RLqfaSdVNUXtIZMrDxQ+P+CJH6VckLyOQtXzcEx8tJh7XK2bYq1jd+PpOB+KiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AA74JasI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AA74JasI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B586C4CEEB;
	Thu, 28 Aug 2025 05:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359974;
	bh=H+fO6OHkKX0KKwcJfJnIJBoP9qyNE+QYIBDq422I9dQ=;
	h=Date:To:From:Subject:From;
	b=AA74JasIerAbllGWuzrU894KQwrIbEnraKXgk3K4xb9NbPzkmrLwLJLsX4BnvdumK
	 oUppJg1v60C+ZftFe/sIDNCRSRQjUFnke4UDABk56vvFUfycBDzfMuntgsMucZyNda
	 AAcifLVhn/D+BbAyNYbmYhcLruZbDPeSSRvzaVGY=
Date: Wed, 27 Aug 2025 22:46:13 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,david@redhat.com,aarcange@redhat.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch removed from -mm tree
Message-Id: <20250828054614.0B586C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE
Date: Thu, 31 Jul 2025 10:44:31 -0400

With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
kmap_local_page(), which requires unmapping in Last-In-First-Out order.

The current code maps dst_pte first, then src_pte, but unmaps them in the
same order (dst_pte, src_pte), violating the LIFO requirement.  This
causes the warning in kunmap_local_indexed():

  WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
  addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)

Fix this by reversing the unmap order to respect LIFO ordering.

This issue follows the same pattern as similar fixes:
- commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
- commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")

Both of which addressed the same fundamental requirement that kmap_local
operations must follow LIFO ordering.

Link: https://lkml.kernel.org/r/20250731144431.773923-1-sashal@kernel.org
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte
+++ a/mm/userfaultfd.c
@@ -1453,10 +1453,15 @@ out:
 		folio_unlock(src_folio);
 		folio_put(src_folio);
 	}
-	if (dst_pte)
-		pte_unmap(dst_pte);
+	/*
+	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
+	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
+	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
+	 */
 	if (src_pte)
 		pte_unmap(src_pte);
+	if (dst_pte)
+		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
 	if (si)
 		put_swap_device(si);
_

Patches currently in -mm which might be from sashal@kernel.org are


