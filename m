From: akpm@linux-foundation.org
Subject: [merged] mmkexec-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:16 -0700
Message-ID: <20130430184616.7BA9F5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60183 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3D3SqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:17 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so84835vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, ebiederm@xmission.com, jiang.liu@huawei.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,kexec: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mmkexec-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm,kexec: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/kexec.c~mmkexec-use-common-help-functions-to-free-reserved-pages kernel/kexec.c
--- a/kernel/kexec.c~mmkexec-use-common-help-functions-to-free-reserved-pages
+++ a/kernel/kexec.c
@@ -1118,12 +1118,8 @@ void __weak crash_free_reserved_phys_ran
 {
 	unsigned long addr;
 
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
-		free_page((unsigned long)__va(addr));
-		totalram_pages++;
-	}
+	for (addr = begin; addr < end; addr += PAGE_SIZE)
+		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
 }
 
 int crash_shrink_memory(unsigned long new_size)
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

