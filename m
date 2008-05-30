From: akpm@linux-foundation.org
Subject: - frv-specify-the-minimum-slab-kmalloc-alignment.patch removed from -mm tree
Date: Fri, 30 May 2008 15:38:27 -0700
Message-ID: <200805302238.m4UMcR19014826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYE3Wjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mpm@selenic.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     frv: Specify the minimum slab/kmalloc alignment
has been removed from the -mm tree.  Its filename was
     frv-specify-the-minimum-slab-kmalloc-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: Specify the minimum slab/kmalloc alignment
From: David Howells <dhowells@redhat.com>

Specify the minimum slab/kmalloc alignment to be 8 bytes.  This fixes a
crash when SLOB is selected as the memory allocator.  The FRV arch needs
this so that it can use the load- and store-double instructions without
faulting.  By default SLOB sets the minimum to be 4 bytes.

We need to use literal constants here as slab evaluates these within cpp.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/mem-layout.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-frv/mem-layout.h~frv-specify-the-minimum-slab-kmalloc-alignment include/asm-frv/mem-layout.h
--- a/include/asm-frv/mem-layout.h~frv-specify-the-minimum-slab-kmalloc-alignment
+++ a/include/asm-frv/mem-layout.h
@@ -38,6 +38,13 @@
 #define	ARCH_KMALLOC_MINALIGN		8
 #define	ARCH_SLAB_MINALIGN		8
 
+/*
+ * the slab must be aligned such that load- and store-double instructions don't
+ * fault if used
+ */
+#define	ARCH_KMALLOC_MINALIGN		8 /* (sizeof(long) * 2) */
+#define	ARCH_SLAB_MINALIGN		8 /* (sizeof(long) * 2) */
+
 /*****************************************************************************/
 /*
  * virtual memory layout from kernel's point of view
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-dont-offer-binfmt_flat.patch
linux-next.patch
git-unionfs.patch
security-keys-remove-unused-key_alloc_sem.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

