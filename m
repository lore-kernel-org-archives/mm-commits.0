From: akpm@linux-foundation.org
Subject: + arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch added
 to -mm tree
Date: Tue, 25 Jun 2013 12:46:29 -0700
Message-ID: <51c9f395.70pEo/nHC/2EfO64%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3FYTqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:46:29 -0700


The patch titled
     Subject: arch: c6x: mm: include "asm/uaccess.h" to pass compiling
has been added to the -mm tree.  Its filename is
     arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch: c6x: mm: include "asm/uaccess.h" to pass compiling

Need include "asm/uaccess.h" to pass compiling.

The related error (with allmodconfig):
  arch/c6x/mm/init.c: In function ‘paging_init’:
  arch/c6x/mm/init.c:46:2: error: implicit declaration of function ‘set_fs’ [-Werror=implicit-function-declaration]
  arch/c6x/mm/init.c:46:9: error: ‘KERNEL_DS’ undeclared (first use in this function)
  arch/c6x/mm/init.c:46:9: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/c6x/mm/init.c~arch-c6x-mm-include-asm-uaccessh-to-pass-compiling arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~arch-c6x-mm-include-asm-uaccessh-to-pass-compiling
+++ a/arch/c6x/mm/init.c
@@ -18,6 +18,7 @@
 #include <linux/initrd.h>
 
 #include <asm/sections.h>
+#include <asm/uaccess.h>
 
 /*
  * ZERO_PAGE is a special page that is used for zero-initialized
_

Patches currently in -mm which might be from gang.chen@asianux.com are

arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch
arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

