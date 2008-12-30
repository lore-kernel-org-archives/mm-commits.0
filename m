From: akpm@linux-foundation.org
Subject: + kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:23:01 -0800
Message-ID: <200812300023.mBU0N1AI005949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373AbYL3AXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com


The patch titled
     kmemleak: add kmemleak_alloc callback from alloc_large_system_hash
has been added to the -mm tree.  Its filename is
     kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch

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
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

