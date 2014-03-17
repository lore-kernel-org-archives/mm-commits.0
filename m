From: akpm@linux-foundation.org
Subject: [failures]
 mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges.patch
 removed from -mm tree
Date: Mon, 17 Mar 2014 16:02:25 -0700
Message-ID: <53277f01.Yxz48gxYuJ6uABKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaCQXCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Mar 2014 19:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dietmar.hahn@ts.fujitsu.com, david.vrabel@citrix.com

Subject: [failures] mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges.patch removed from -mm tree
To: david.vrabel@citrix.com,dietmar.hahn@ts.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 17 Mar 2014 16:02:24 -0700


The patch titled
     Subject: mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: David Vrabel <david.vrabel@citrix.com>
Subject: mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges

If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
sufficiently long that it triggers soft lockup warnings.

Add a cond_resched() into vunmap_pmd_range() so the calling task may be
resheduled after unmapping each PMD entry.  This is how zap_pmd_range()
fixes the same problem for userspace mappings.

All callers may sleep except for the APEI GHES driver (apei/ghes.c) which
calls unmap_kernel_range_no_flush() from NMI and IRQ contexts.  This
driver only unmaps a single pages so don't call cond_resched() if the
unmap doesn't cross a PMD boundary.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmalloc.c~mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges
+++ a/mm/vmalloc.c
@@ -77,6 +77,8 @@ static void vunmap_pmd_range(pud_t *pud,
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
+		if (next != end)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
_

Patches currently in -mm which might be from david.vrabel@citrix.com are

linux-next.patch

