From: akpm@linux-foundation.org
Subject: [merged] mm-arch-use-numa_no_node.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:13 -0800
Message-ID: <5283e335.+wflh+DnbsV1xeU1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, wujianguo@huawei.com

Subject: [merged] mm-arch-use-numa_no_node.patch removed from -mm tree
To: wujianguo@huawei.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:13 -0800


The patch titled
     Subject: mm/arch: use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     mm-arch-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/arch: use NUMA_NO_NODE

Use more appropriate NUMA_NO_NODE instead of -1 in all archs' module_alloc()

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/module.c    |    2 +-
 arch/arm64/kernel/module.c  |    2 +-
 arch/parisc/kernel/module.c |    2 +-
 arch/s390/kernel/module.c   |    2 +-
 arch/sparc/kernel/module.c  |    2 +-
 arch/x86/kernel/module.c    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

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

origin.patch
x86-srat-use-numa_no_node.patch
linux-next.patch

