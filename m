From: akpm@linux-foundation.org
Subject: [merged] arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:22:52 -0700
Message-ID: <51db118c./cHl+m0eBHRbzwTW%akpm__13675.9541965604$1373311382$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch removed from -mm tree
To: gang.chen@asianux.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:22:52 -0700


The patch titled
     Subject: arch: c6x: mm: include "asm/uaccess.h" to pass compiling
has been removed from the -mm tree.  Its filename was
     arch-c6x-mm-include-asm-uaccessh-to-pass-compiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: arch: c6x: mm: include "asm/uaccess.h" to pass compiling

Need include "asm/uaccess.h" to pass compiling.

The related error (with allmodconfig):
  arch/c6x/mm/init.c: In function `paging_init':
  arch/c6x/mm/init.c:46:2: error: implicit declaration of function `set_fs' [-Werror=implicit-function-declaration]
  arch/c6x/mm/init.c:46:9: error: `KERNEL_DS' undeclared (first use in this function)
  arch/c6x/mm/init.c:46:9: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: <stable@vger.kernel.org>	[3.10.x]
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

origin.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch

