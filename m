From: akpm@linux-foundation.org
Subject: + mm-arch-use-numa_no_node.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:41:35 -0700
Message-ID: <5242232f.yQ8pRJ0DRUHgXVXD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3IXXlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, wujianguo@huawei.com

Subject: + mm-arch-use-numa_no_node.patch added to -mm tree
To: wujianguo@huawei.com,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:41:35 -0700


The patch titled
     Subject: mm/arch: use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     mm-arch-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-arch-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-arch-use-numa_no_node.patch

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
Subject: mm/arch: use NUMA_NO_NODE

Use more appropriate NUMA_NO_NODE instead of -1 in all archs' module_alloc()

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/module.c    |    2 +-
 arch/arm64/kernel/module.c  |    2 +-
 arch/mips/kernel/module.c   |    2 +-
 arch/parisc/kernel/module.c |    2 +-
 arch/s390/kernel/module.c   |    2 +-
 arch/sparc/kernel/module.c  |    2 +-
 arch/x86/kernel/module.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/arm/kernel/module.c~mm-arch-use-numa_no_node arch/arm/kernel/module.c
--- a/arch/arm/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/arm/kernel/module.c
@@ -40,7 +40,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
+				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff -puN arch/arm64/kernel/module.c~mm-arch-use-numa_no_node arch/arm64/kernel/module.c
--- a/arch/arm64/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/arm64/kernel/module.c
@@ -29,7 +29,7 @@
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff -puN arch/mips/kernel/module.c~mm-arch-use-numa_no_node arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/mips/kernel/module.c
@@ -46,7 +46,7 @@ static DEFINE_SPINLOCK(dbe_lock);
 void *module_alloc(unsigned long size)
 {
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, -1,
+				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #endif
diff -puN arch/parisc/kernel/module.c~mm-arch-use-numa_no_node arch/parisc/kernel/module.c
--- a/arch/parisc/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/parisc/kernel/module.c
@@ -219,7 +219,7 @@ void *module_alloc(unsigned long size)
 	 * init_data correctly */
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
 				    GFP_KERNEL | __GFP_HIGHMEM,
-				    PAGE_KERNEL_RWX, -1,
+				    PAGE_KERNEL_RWX, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 
diff -puN arch/s390/kernel/module.c~mm-arch-use-numa_no_node arch/s390/kernel/module.c
--- a/arch/s390/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/s390/kernel/module.c
@@ -50,7 +50,7 @@ void *module_alloc(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL, -1,
+				    GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
 #endif
diff -puN arch/sparc/kernel/module.c~mm-arch-use-numa_no_node arch/sparc/kernel/module.c
--- a/arch/sparc/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/sparc/kernel/module.c
@@ -29,7 +29,7 @@ static void *module_map(unsigned long si
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL, -1,
+				GFP_KERNEL, PAGE_KERNEL, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 #else
diff -puN arch/x86/kernel/module.c~mm-arch-use-numa_no_node arch/x86/kernel/module.c
--- a/arch/x86/kernel/module.c~mm-arch-use-numa_no_node
+++ a/arch/x86/kernel/module.c
@@ -49,7 +49,7 @@ void *module_alloc(unsigned long size)
 		return NULL;
 	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
-				-1, __builtin_return_address(0));
+				NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 #ifdef CONFIG_X86_32
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-acpi-use-numa_no_node.patch
x86-srat-use-numa_no_node.patch
mm-vmalloc-use-numa_no_node.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-arch-use-numa_no_node.patch
linux-next.patch

