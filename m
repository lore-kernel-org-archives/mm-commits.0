From: akpm@linux-foundation.org
Subject: [merged] arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:31 -0700
Message-ID: <20130422200631.C9EE831C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52532 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3DVUGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:33 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so733265vcb.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, gregkh@linuxfoundation.org, hpa@zytor.com, jiang.liu@huawei.com, mingo@elte.hu, qiuxishi@huawei.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, wangsl-fnst@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/init_64.c: fix build warning when CONFIG_MEMORY_HOTREMOVE=n
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: arch/x86/mm/init_64.c: fix build warning when CONFIG_MEMORY_HOTREMOVE=n

There is a warning while building kernel with
CONFIG_MEMORY_HOTPLUG=y && CONFIG_MEMORY_HOTREMOVE=n:
arch/x86/mm/init_64.c:1024: warning:kernel_physical_mapping_remove defined but not used

So move kernel_physical_mapping_remove() into "#ifdef
CONFIG_MEMORY_HOTREMOVE" block

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Liujiang <jiang.liu@huawei.com>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n
+++ a/arch/x86/mm/init_64.c
@@ -1019,6 +1019,7 @@ void __ref vmemmap_free(struct page *mem
 	remove_pagetable(start, end, false);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1028,7 +1029,6 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true);
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 int __ref arch_remove_memory(u64 start, u64 size)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
_

Patches currently in -mm which might be from wujianguo@huawei.com are

linux-next.patch
mm-migrate-fix-comment-typo-syncronous-synchronous.patch

