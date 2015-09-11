From: akpm@linux-foundation.org
Subject: + mm-kasan-module_vaddr-is-not-available-on-all-archs.patch added to -mm tree
Date: Fri, 11 Sep 2015 14:27:09 -0700
Message-ID: <55f3472d.V0WlaVIj6RWDpLON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIKV1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: MODULE_VADDR is not available on all archs
has been added to the -mm tree.  Its filename is
     mm-kasan-module_vaddr-is-not-available-on-all-archs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-module_vaddr-is-not-available-on-all-archs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-module_vaddr-is-not-available-on-all-archs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/kasan: MODULE_VADDR is not available on all archs

Use is_module_address instead

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/kasan/report.c~mm-kasan-module_vaddr-is-not-available-on-all-archs mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-module_vaddr-is-not-available-on-all-archs
+++ a/mm/kasan/report.c
@@ -22,6 +22,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/kasan.h>
+#include <linux/module.h>
 
 #include <asm/sections.h>
 
@@ -85,9 +86,11 @@ static void print_error_description(stru
 
 static inline bool kernel_or_module_addr(const void *addr)
 {
-	return (addr >= (void *)_stext && addr < (void *)_end)
-		|| (addr >= (void *)MODULES_VADDR
-			&& addr < (void *)MODULES_END);
+	if (addr >= (void *)_stext && addr < (void *)_end)
+		return true;
+	if (is_module_address((unsigned long)addr))
+		return true;
+	return false;
 }
 
 static inline bool init_task_stack_addr(const void *addr)
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch
mm-kasan-module_vaddr-is-not-available-on-all-archs.patch
mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch
mm-kasan-prevent-deadlock-in-kasan-reporting.patch

