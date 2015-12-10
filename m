From: akpm@linux-foundation.org
Subject: + mm-printk-introduce-new-format-string-for-flags-fix.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:12:02 -0800
Message-ID: <5668c352.o6QEhlWRCpitpzrZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbbLJAMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:12:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix generated/bounds.h
has been added to the -mm tree.  Its filename is
     mm-printk-introduce-new-format-string-for-flags-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-printk-introduce-new-format-string-for-flags-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-printk-introduce-new-format-string-for-flags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-printk-introduce-new-format-string-for-flags-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch

