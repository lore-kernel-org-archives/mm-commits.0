Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605F72036FE;
	Fri,  1 Aug 2025 21:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754082695; cv=none; b=Neh4UJ5D3FeCU/42H0PpxzhJRllVGLja7bAVgi19josKsXu6wu5FToV87gwJisRWfpMxK+C8u6fSNC+QgqY7JnErbNzJs3NHO4UHK6J5xEa5ljqAXv2N+lQRyK1oxFxWXXz4UrEbSnh2yL3qbD8gv2ZBUhgF4UsNBDnkY8bkxvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754082695; c=relaxed/simple;
	bh=3yxcwkca5yKSX/TeLduikPqF5CqYYiXa99FX6vfUtSg=;
	h=Date:To:From:Subject:Message-Id; b=OHenDu6HeTmYOZuazFkLXP6dg7FNkE6iVN1uI6nO+ZjnKZuHyevHvtgW4Q9Og/7w9NhwLFPucNtAMPwzH3v9REYq0rEZH557WDn5TEYogwvsNDG9XuJC4y5Hfiw32ty7+B63xQaRL1PFtallcYCiUqRwlc8fBSlyfSbiFvU+k5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLoBCnHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLoBCnHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A4AC4CEE7;
	Fri,  1 Aug 2025 21:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754082694;
	bh=3yxcwkca5yKSX/TeLduikPqF5CqYYiXa99FX6vfUtSg=;
	h=Date:To:From:Subject:From;
	b=uLoBCnHMQS4Cyts92bSw5IiUcxWWd85Gk9p/S/Wa4J+NYDDJzjb4EZNpLTE+xViFl
	 t2JgRzEYiuFjeJI4UzjMNNaXfMAQr92ysv2KH0a+XWzh4DGM23YkTjBQA2DmJrBH7C
	 YawcsFGgi1RAsXiGdVLUQeksz+iK8kjFc6450xsE=
Date: Fri, 01 Aug 2025 14:11:34 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,david@redhat.com,aarcange@redhat.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801211134.D9A4AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch

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

mm-userfaultfd-fix-kmap_local-lifo-ordering-for-config_highpte.patch

