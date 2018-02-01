From: akpm@linux-foundation.org
Subject: [patch 041/119] mm/filemap.c: remove include of hardirq.h
Date: Wed, 31 Jan 2018 16:16:34 -0800
Message-ID: <20180201001634.8LbeSBWyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34334 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbeBAAQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yang.s@alibaba-inc.com

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
