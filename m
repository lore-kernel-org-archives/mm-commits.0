From: akpm@linux-foundation.org
Subject: +
 dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch added
 to -mm tree
Date: Thu, 25 Jan 2018 14:38:54 -0800
Message-ID: <5a6a5c7e.kbzTQNvf+zuHJNm9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751204AbeAYWiz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jan 2018 17:38:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jschoenh@amazon.de, akpm@linux-foundation.org, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dax.c: release PMD lock even when there is no PMD support in DAX
has been added to the -mm tree.  Its filename is
     dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dax-release-pmd-lock-even-when-there-is-no-pmd-support-in-dax.patch

