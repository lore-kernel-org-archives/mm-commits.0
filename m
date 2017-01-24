From: akpm@linux-foundation.org
Subject: [patch 24/26] mm: do not export ioremap_page_range symbol for
 external module
Date: Tue, 24 Jan 2017 15:18:52 -0800
Message-ID: <5887e0dc.kfNlyAQUyClQ4plV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdAXXSx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, jhubbard@nvidia.com, mhocko@suse.com

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
Acked-by: Michal Hocko <mhocko@suse.com>
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
