From: akpm@linux-foundation.org
Subject: [patch 119/119] mm: remove PG_highmem description
Date: Wed, 31 Jan 2018 16:21:27 -0800
Message-ID: <20180201002127.Lpp5U3QyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAV2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: mm: remove PG_highmem description

cbe37d093707 ("[PATCH] mm: remove PG_highmem") removed PG_highmem to save
a page flag.  So the description of PG_highmem is no longer needed.

Link: http://lkml.kernel.org/r/1517391212-2950-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/page-flags.h~mm-remove-pg_highmem-description include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-remove-pg_highmem-description
+++ a/include/linux/page-flags.h
@@ -46,11 +46,6 @@
  * guarantees that this bit is cleared for a page when it first is entered into
  * the page cache.
  *
- * PG_highmem pages are not permanently mapped into the kernel virtual address
- * space, they need to be kmapped separately for doing IO on the pages.  The
- * struct page (these bits with information) are always mapped into kernel
- * address space...
- *
  * PG_hwpoison indicates that a page got corrupted in hardware and contains
  * data with incorrect ECC bits that triggered a machine check. Accessing is
  * not safe since it may cause another machine check. Don't touch!
_
