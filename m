From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch removed from
 -mm tree
Date: Wed, 10 Dec 2014 15:17:37 -0800
Message-ID: <5488d491.PI+lXFtRAPvlht4A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaLJXRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2
has been removed from the -mm tree.  Its filename was
     mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch

This patch was dropped because it was folded into mm-fix-huge-zero-page-accounting-in-smaps-report.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2

fs/proc/task_mmu.c:474 smaps_account() warn: should 'size << 12' be a 64 bit type?

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2
+++ a/fs/proc/task_mmu.c
@@ -465,17 +465,16 @@ static void smaps_account(struct mem_siz
 			mss->shared_dirty += size;
 		else
 			mss->shared_clean += size;
-		mss->pss += (size << PSS_SHIFT) / mapcount;
+		mss->pss += ((u64)size << PSS_SHIFT) / mapcount;
 	} else {
 		if (dirty || PageDirty(page))
 			mss->private_dirty += size;
 		else
 			mss->private_clean += size;
-		mss->pss += (size << PSS_SHIFT);
+		mss->pss += (u64)size << PSS_SHIFT;
 	}
 }
 
