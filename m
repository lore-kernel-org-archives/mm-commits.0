From: akpm@linux-foundation.org
Subject: + frv-specify-the-minimum-slab-kmalloc-alignment.patch added to -mm tree
Date: Wed, 28 May 2008 12:15:40 -0700
Message-ID: <200805281915.m4SJFeWk028268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbYE1TQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 15:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, mpm@selenic.com, penberg@cs.helsinki.fi


The patch titled
     frv: Specify the minimum slab/kmalloc alignment
has been added to the -mm tree.  Its filename is
     frv-specify-the-minimum-slab-kmalloc-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -31,6 +31,13 @@
 
 #define PAGE_MASK			(~(PAGE_SIZE-1))
 
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

mn10300-fix-typo-in-header-guard.patch
frv-dont-offer-binfmt_flat.patch
frv-specify-the-minimum-slab-kmalloc-alignment.patch
linux-next.patch
git-unionfs.patch
security-keys-remove-unused-key_alloc_sem.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

