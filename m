From: akpm@linux-foundation.org
Subject: +
 mm-do-not-export-ioremap_page_range-symbol-for-external-module.patch added
 to -mm tree
Date: Mon, 23 Jan 2017 16:14:38 -0800
Message-ID: <58869c6e.12j4MAOg0oVKY8S3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49030 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdAXAPN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 19:15:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not export ioremap_page_range symbol for external module
has been added to the -mm tree.  Its filename is
     mm-do-not-export-ioremap_page_range-symbol-for-external-module.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-export-ioremap_page_range-symbol-for-external-module.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-export-ioremap_page_range-symbol-for-external-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: do not export ioremap_page_range symbol for external module

Recently, I've found cases in which ioremap_page_range was used
incorrectly, in external modules, leading to crashes.  This can be partly
attributed to the fact that ioremap_page_range is lower-level, with fewer
protections, as compared to the other functions that an external module
would typically call.  Those include:

     ioremap_cache
     ioremap_nocache
     ioremap_prot
     ioremap_uc
     ioremap_wc
     ioremap_wt

...each of which wraps __ioremap_caller, which in turn provides a safer
way to achieve the mapping.

Therefore, stop EXPORT-ing ioremap_page_range.

Link: http://lkml.kernel.org/r/1485173220-29010-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/ioremap.c~mm-do-not-export-ioremap_page_range-symbol-for-external-module lib/ioremap.c
--- a/lib/ioremap.c~mm-do-not-export-ioremap_page_range-symbol-for-external-module
+++ a/lib/ioremap.c
@@ -144,4 +144,3 @@ int ioremap_page_range(unsigned long add
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(ioremap_page_range);
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-do-not-export-ioremap_page_range-symbol-for-external-module.patch
z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

