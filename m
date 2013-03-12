From: akpm@linux-foundation.org
Subject: + arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:21:45 -0700
Message-ID: <20130312202145.836D631C280@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41573 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab3CLUVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:21:47 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so31071qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:21:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com, hpa@zytor.com, jiang.liu@huawei.com, mingo@elte.hu, qiuxishi@huawei.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com


The patch titled
     Subject: arch/x86/mm/init_64.c: fix build warning when CONFIG_MEMORY_HOTREMOVE=n
has been added to the -mm tree.  Its filename is
     arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove_memory-fix-end_pfn-setting.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch

