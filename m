From: akpm@linux-foundation.org
Subject: [patch 031/119] mm: kmemleak: remove unused hardirq.h
Date: Wed, 31 Jan 2018 16:15:55 -0800
Message-ID: <20180201001555.bYPpEfVWn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAP4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yang.s@alibaba-inc.com

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
