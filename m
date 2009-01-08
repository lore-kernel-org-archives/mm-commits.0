From: akpm@linux-foundation.org
Subject: - kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:06 -0800
Message-ID: <200901082246.n08Mk67k025629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757317AbZAHWuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add kmemleak_alloc callback from alloc_large_system_hash
has been removed from the -mm tree.  Its filename was
     kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add kmemleak_alloc callback from alloc_large_system_hash
From: Catalin Marinas <catalin.marinas@arm.com>

The alloc_large_system_hash function is called from various places in the
kernel and it contains pointers to other allocated structures.  It
therefore needs to be traced by kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/page_alloc.c~kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash mm/page_alloc.c
--- a/mm/page_alloc.c~kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash
+++ a/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/kmemleak.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4584,6 +4585,16 @@ void *__init alloc_large_system_hash(con
 	if (_hash_mask)
 		*_hash_mask = (1 << log2qty) - 1;
 
+	/*
+	 * If hashdist is set, the table allocation is done with __vmalloc()
+	 * which invokes the kmemleak_alloc() callback. This function may also
+	 * be called before the slab and kmemleak are initialised when
+	 * kmemleak simply buffers the request to be executed later
+	 * (GFP_ATOMIC flag ignored in this case).
+	 */
+	if (!hashdist)
+		kmemleak_alloc(table, size, 1, GFP_ATOMIC);
+
 	return table;
 }
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

