From: akpm@osdl.org
Subject: + linux-preempth-needs-linux-thread_infoh.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:17:16 -0800
Message-ID: <200612270917.kBR9HGpE006612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbWL0JRZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:17:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au


The patch titled
     linux/preempt.h needs linux/thread_info.h
has been added to the -mm tree.  Its filename is
     linux-preempth-needs-linux-thread_infoh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: linux/preempt.h needs linux/thread_info.h
From: Horms <horms@verge.net.au>

It seems that linux/preempt.h needs to include linux/thread_info.h in order
to access current_thread_info(), which is used in preempt_count().

I guess that all callers of preempt_count() must include both
linux/thread_info.h and linux/preempt.h directly or indirectly, as this
does not cause a compile error.  I noticed the problem while working on an
unrelated issue in xen-land.

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/preempt.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/preempt.h~linux-preempth-needs-linux-thread_infoh include/linux/preempt.h
--- a/include/linux/preempt.h~linux-preempth-needs-linux-thread_infoh
+++ a/include/linux/preempt.h
@@ -8,6 +8,7 @@
 
 #include <linux/thread_info.h>
 #include <linux/linkage.h>
+#include <linux/thread_info.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
_

Patches currently in -mm which might be from horms@verge.net.au are

linux-preempth-needs-linux-thread_infoh.patch

