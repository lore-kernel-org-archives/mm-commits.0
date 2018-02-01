From: akpm@linux-foundation.org
Subject: [merged]
 dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:28:49 -0800
Message-ID: <20180201192849.sqizNUorK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbeBAT2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:28:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jschoenh@amazon.de, mawilcox@microsoft.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com


The patch titled
     Subject: fs/dax.c: release PMD lock even when there is no PMD support in DAX
has been removed from the -mm tree.  Its filename was
     dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan H. Schönherr <jschoenh@amazon.de>
Subject: fs/dax.c: release PMD lock even when there is no PMD support in DAX

follow_pte_pmd() can theoretically return after having acquired a PMD
lock, even when DAX was not compiled with CONFIG_FS_DAX_PMD.

Release the PMD lock unconditionally.

Link: http://lkml.kernel.org/r/20180118133839.20587-1-jschoenh@amazon.de
Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax fs/dax.c
--- a/fs/dax.c~dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax
+++ a/fs/dax.c
@@ -636,8 +636,8 @@ static void dax_mapping_entry_mkclean(st
 			pmd = pmd_mkclean(pmd);
 			set_pmd_at(vma->vm_mm, address, pmdp, pmd);
 unlock_pmd:
-			spin_unlock(ptl);
 #endif
+			spin_unlock(ptl);
 		} else {
 			if (pfn != pte_pfn(*ptep))
 				goto unlock_pte;
_

Patches currently in -mm which might be from jschoenh@amazon.de are


