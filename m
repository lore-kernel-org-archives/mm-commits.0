From: akpm@linux-foundation.org
Subject: + mm-filemap-remove-include-of-hardirqh.patch added to -mm tree
Date: Tue, 21 Nov 2017 15:51:40 -0800
Message-ID: <5a14bc0c.XxpECKVR9lCRkI+7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdKUXvl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:51:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: remove include of hardirq.h
has been added to the -mm tree.  Its filename is
     mm-filemap-remove-include-of-hardirqh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-remove-include-of-hardirqh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-remove-include-of-hardirqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: filemap: remove include of hardirq.h

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

mm-kmemleak-remove-unused-hardirqh.patch
mm-filemap-remove-include-of-hardirqh.patch

