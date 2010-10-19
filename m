From: akpm@linux-foundation.org
Subject: + mm-add-vzalloc-and-vzalloc_node-helpers.patch added to -mm tree
Date: Tue, 19 Oct 2010 15:25:08 -0700
Message-ID: <201010192225.o9JMP8AF004814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab0JSWZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 18:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, cl@linux-foundation.org, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     mm: add vzalloc() and vzalloc_node() helpers
has been added to the -mm tree.  Its filename is
     mm-add-vzalloc-and-vzalloc_node-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add vzalloc() and vzalloc_node() helpers
From: Dave Young <hidave.darkstar@gmail.com>

Add vzalloc() and vzalloc_node() to encapsulate the
vmalloc-then-memset-zero operation.

Use __GFP_ZERO to zero fill the allocated memory.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +
 mm/nommu.c              |   49 +++++++++++++++++++++++++++++++++++++-
 mm/vmalloc.c            |   46 ++++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 3 deletions(-)

diff -puN include/linux/vmalloc.h~mm-add-vzalloc-and-vzalloc_node-helpers include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-add-vzalloc-and-vzalloc_node-helpers
+++ a/include/linux/vmalloc.h
@@ -53,8 +53,10 @@ static inline void vmalloc_init(void)
 #endif
 
 extern void *vmalloc(unsigned long size);
+extern void *vzalloc(unsigned long size);
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
+extern void *vzalloc_node(unsigned long size, int node);
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
diff -puN mm/nommu.c~mm-add-vzalloc-and-vzalloc_node-helpers mm/nommu.c
--- a/mm/nommu.c~mm-add-vzalloc-and-vzalloc_node-helpers
+++ a/mm/nommu.c
@@ -293,11 +293,58 @@ void *vmalloc(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc);
 
+/*
+ *	vzalloc - allocate virtually continguos memory with zero fill
+ *
+ *	@size:		allocation size
+ *
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into continguos kernel virtual space.
+ *	The memory allocated is set to zero.
+ *
+ *	For tight control over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vzalloc(unsigned long size)
+{
+	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			PAGE_KERNEL);
+}
+EXPORT_SYMBOL(vzalloc);
+
+/**
+ * vmalloc_node - allocate memory on a specific node
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc() instead.
+ */
 void *vmalloc_node(unsigned long size, int node)
 {
 	return vmalloc(size);
 }
-EXPORT_SYMBOL(vmalloc_node);
+
+/**
+ * vzalloc_node - allocate memory on a specific node with zero fill
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ * The memory allocated is set to zero.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc() instead.
+ */
+void *vzalloc_node(unsigned long size, int node)
+{
+	return vzalloc(size);
+}
+EXPORT_SYMBOL(vzalloc_node);
 
 #ifndef PAGE_KERNEL_EXEC
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
diff -puN mm/vmalloc.c~mm-add-vzalloc-and-vzalloc_node-helpers mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vzalloc-and-vzalloc_node-helpers
+++ a/mm/vmalloc.c
@@ -1653,6 +1653,13 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+static inline void *__vmalloc_node_flags(unsigned long size,
+					int node, gfp_t flags)
+{
+	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
+					node, __builtin_return_address(0));
+}
+
 /**
  *	vmalloc  -  allocate virtually contiguous memory
  *	@size:		allocation size
@@ -1664,12 +1671,28 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
-					-1, __builtin_return_address(0));
+	return __vmalloc_node_flags(size, -1, GFP_KERNEL | __GFP_HIGHMEM);
 }
 EXPORT_SYMBOL(vmalloc);
 
 /**
+ *	vzalloc - allocate virtually contiguous memory with zero fill
+ *	@size:	allocation size
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into contiguous kernel virtual space.
+ *	The memory allocated is set to zero.
+ *
+ *	For tight control over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vzalloc(unsigned long size)
+{
+	return __vmalloc_node_flags(size, -1,
+				GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vzalloc);
+
+/**
  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
  * @size: allocation size
  *
@@ -1710,6 +1733,25 @@ void *vmalloc_node(unsigned long size, i
 }
 EXPORT_SYMBOL(vmalloc_node);
 
+/**
+ * vzalloc_node - allocate memory on a specific node with zero fill
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ * The memory allocated is set to zero.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc_node() instead.
+ */
+void *vzalloc_node(unsigned long size, int node)
+{
+	return __vmalloc_node_flags(size, node,
+			 GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vzalloc_node);
+
 #ifndef PAGE_KERNEL_EXEC
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
mm-add-vzalloc-and-vzalloc_node-helpers.patch

