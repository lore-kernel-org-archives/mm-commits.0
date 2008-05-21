From: akpm@linux-foundation.org
Subject: - make-list_poison-less-deadly-v2.patch removed from -mm tree
Date: Wed, 21 May 2008 14:22:05 -0700
Message-ID: <200805212122.m4LLM5bp001437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYEUVW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Make LIST_POISON less deadly
has been removed from the -mm tree.  Its filename was
     make-list_poison-less-deadly-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make LIST_POISON less deadly
From: Avi Kivity <avi@qumranet.com>

The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
pointers in order to trap erronous use of freed list_heads.  Unfortunately
userspace can arrange for those pointers to actually be dereferencable,
potentially turning an oops to an expolit.

To avoid this allow architectures (currently x86_64 only) to override the
default values for these pointers with truly-undereferncable values.  This
is easy on x86_64 as the virtual address space is smaller than the range
spanned by pointer values.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~make-list_poison-less-deadly-v2 arch/x86/Kconfig
--- a/arch/x86/Kconfig~make-list_poison-less-deadly-v2
+++ a/arch/x86/Kconfig
@@ -1025,6 +1025,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0x8888888800000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff -puN include/linux/poison.h~make-list_poison-less-deadly-v2 include/linux/poison.h
--- a/include/linux/poison.h~make-list_poison-less-deadly-v2
+++ a/include/linux/poison.h
@@ -1,14 +1,20 @@
 #ifndef _LINUX_POISON_H
 #define _LINUX_POISON_H
 
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+#define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+#else
+#define POISON_POINTER_DELTA 0L
+#endif
+
 /********** include/linux/list.h **********/
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
linux-next.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch

