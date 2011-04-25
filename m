From: akpm@linux-foundation.org
Subject: + memblock-add-error-return-when-config_have_memblock-is-not-set.patch added to -mm tree
Date: Mon, 25 Apr 2011 15:48:56 -0700
Message-ID: <201104252248.p3PMmuVC015845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756806Ab1DYWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 18:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hpa@zytor.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com, yhlu.kernel@gmail.com


The patch titled
     memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
has been added to the -mm tree.  Its filename is
     memblock-add-error-return-when-config_have_memblock-is-not-set.patch

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
Subject: memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
From: Yinghai Lu <yinghai@kernel.org>

On larger systems, information in the kernel log is lost because there is
so much early text printed, that it overflows the static log buffer before
the log_buf_len kernel parameter can be processed, and a bigger log buffer
allocated.

Distros are relunctant to increase memory usage by increasing the size of
the static log buffer, so minimize the problem by allocating the new log
buffer as early as possible.


This patch:

Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead of having
to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of code calling that
function.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/memblock.h~memblock-add-error-return-when-config_have_memblock-is-not-set include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-add-error-return-when-config_have_memblock-is-not-set
+++ a/include/linux/memblock.h
@@ -2,6 +2,8 @@
 #define _LINUX_MEMBLOCK_H
 #ifdef __KERNEL__
 
+#define MEMBLOCK_ERROR	0
+
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Logical memory blocks.
@@ -20,7 +22,6 @@
 #include <asm/memblock.h>
 
 #define INIT_MEMBLOCK_REGIONS	128
-#define MEMBLOCK_ERROR		0
 
 struct memblock_region {
 	phys_addr_t base;
@@ -160,6 +161,12 @@ static inline unsigned long memblock_reg
 #define __initdata_memblock
 #endif
 
+#else
+static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
+{
+	return MEMBLOCK_ERROR;
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK */
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
memblock-add-error-return-when-config_have_memblock-is-not-set.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

