From: akpm@linux-foundation.org
Subject: + mm-kmemleak-remove-unused-hardirqh.patch added to -mm tree
Date: Mon, 20 Nov 2017 15:35:15 -0800
Message-ID: <5a1366b3.6Jpc1VT+H4GQdcHf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdKTXfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 18:35:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: remove unused hardirq.h
has been added to the -mm tree.  Its filename is
     mm-kmemleak-remove-unused-hardirqh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-remove-unused-hardirqh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-remove-unused-hardirqh.patch

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
Subject: mm: kmemleak: remove unused hardirq.h

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by kmemleak at all.

So, remove the unused hardirq.h.

Link: http://lkml.kernel.org/r/1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleak-remove-unused-hardirqh mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-remove-unused-hardirqh
+++ a/mm/kmemleak.c
@@ -91,7 +91,6 @@
 #include <linux/stacktrace.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/mmzone.h>
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-kmemleak-remove-unused-hardirqh.patch

