From: akpm@linux-foundation.org
Subject: [merged] mm-filemap-remove-include-of-hardirqh.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:31:00 -0800
Message-ID: <20180201193100.JkdZC_MUW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753055AbeBATbB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, mm-commits@vger.kernel.org, yang.s@alibaba-inc.com


The patch titled
     Subject: mm/filemap.c: remove include of hardirq.h
has been removed from the -mm tree.  Its filename was
     mm-filemap-remove-include-of-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm/filemap.c: remove include of hardirq.h

in_atomic() has been moved to include/linux/preempt.h, and the filemap.c
doesn't use in_atomic() directly at all, so it sounds unnecessary to
include hardirq.h.

Link: http://lkml.kernel.org/r/1509985319-38633-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/filemap.c~mm-filemap-remove-include-of-hardirqh mm/filemap.c
--- a/mm/filemap.c~mm-filemap-remove-include-of-hardirqh
+++ a/mm/filemap.c
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
-#include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are


