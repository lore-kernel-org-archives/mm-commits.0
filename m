From: akpm@linux-foundation.org
Subject: - kmemleak-remove-some-of-the-kmemleak-false-positives.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:14 -0800
Message-ID: <200901082246.n08MkE7j025741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbZAHWvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemleak: remove some of the kmemleak false positives
has been removed from the -mm tree.  Its filename was
     kmemleak-remove-some-of-the-kmemleak-false-positives.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: remove some of the kmemleak false positives
From: Catalin Marinas <catalin.marinas@arm.com>

There are allocations for which the main pointer cannot be found but they
are not memory leaks.  This patch fixes some of them.  For more
information on false positives, see Documentation/kmemleak.txt.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c      |    7 +++++++
 include/linux/percpu.h |    5 +++++
 2 files changed, 12 insertions(+)

diff -puN drivers/char/vt.c~kmemleak-remove-some-of-the-kmemleak-false-positives drivers/char/vt.c
--- a/drivers/char/vt.c~kmemleak-remove-some-of-the-kmemleak-false-positives
+++ a/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/kmemleak.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -2879,6 +2880,12 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		/*
+		 * Kmemleak does not track the memory allocated via
+		 * alloc_bootmem() but this block contains pointers to
+		 * other blocks allocated via kmalloc.
+		 */
+		kmemleak_alloc(vc, sizeof(struct vc_data), 1, GFP_ATOMIC);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
diff -puN include/linux/percpu.h~kmemleak-remove-some-of-the-kmemleak-false-positives include/linux/percpu.h
--- a/include/linux/percpu.h~kmemleak-remove-some-of-the-kmemleak-false-positives
+++ a/include/linux/percpu.h
@@ -84,7 +84,12 @@ struct percpu_data {
 	void *ptrs[1];
 };
 
+/* pointer disguising messes up the kmemleak objects tracking */
+#ifndef CONFIG_DEBUG_KMEMLEAK
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
+#else
+#define __percpu_disguise(pdata) (struct percpu_data *)(pdata)
+#endif
 /* 
  * Use this to get to a cpu's version of the per-cpu object dynamically
  * allocated. Non-atomic access to the current CPU's version should
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

