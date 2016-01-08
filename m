From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-printk-introduce-new-format-string-for-flags-fix.patch removed from -mm
 tree
Date: Thu, 07 Jan 2016 16:27:15 -0800
Message-ID: <568f0263.7X1Q4dFzv4vadokI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcAHA1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 19:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix generated/bounds.h
has been removed from the -mm tree.  Its filename was
     mm-printk-introduce-new-format-string-for-flags-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: fix generated/bounds.h

The inclusion of linux/tracepoint.h is causing build errors for me in ARM
randconfig:

In file included from /git/arm-soc/include/linux/ktime.h:25:0,
                 from /git/arm-soc/include/linux/rcupdate.h:47,
                 from /git/arm-soc/include/linux/tracepoint.h:19,
                 from /git/arm-soc/include/linux/mmdebug.h:6,
                 from /git/arm-soc/include/linux/page-flags.h:10,
                 from /git/arm-soc/kernel/bounds.c:9:
/git/arm-soc/include/linux/jiffies.h:10:33: fatal error: generated/timeconst.h: No such file or directory
compilation terminated.

To work around this, we can stop including linux/mmdebug.h from linux/page_flags.h
while generating bounds.h, as we do for mm_types.h already.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-printk-introduce-new-format-string-for-flags-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-printk-introduce-new-format-string-for-flags-fix
+++ a/include/linux/page-flags.h
@@ -7,8 +7,8 @@
 
 #include <linux/types.h>
 #include <linux/bug.h>
-#include <linux/mmdebug.h>
 #ifndef __GENERATING_BOUNDS_H
+#include <linux/mmdebug.h>
 #include <linux/mm_types.h>
 #include <generated/bounds.h>
 #endif /* !__GENERATING_BOUNDS_H */
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

