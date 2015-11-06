From: akpm@linux-foundation.org
Subject: [merged]
 mm-kasan-module_vaddr-is-not-available-on-all-archs.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:17:29 -0800
Message-ID: <563d0ad9.O5ddctrTf+CfuMNi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162871AbbKFUR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: MODULE_VADDR is not available on all archs
has been removed from the -mm tree.  Its filename was
     mm-kasan-module_vaddr-is-not-available-on-all-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


