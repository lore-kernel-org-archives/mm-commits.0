From: akpm@linux-foundation.org
Subject: + nommu-provide-is_vmalloc_addr-stub.patch added to -mm tree
Date: Wed, 12 Mar 2008 00:59:42 -0700
Message-ID: <200803120759.m2C7xg6T017004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbYCLIAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 04:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, clameter@sgi.com, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     nommu: provide is_vmalloc_addr() stub
has been added to the -mm tree.  Its filename is
     nommu-provide-is_vmalloc_addr-stub.patch

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
Subject: nommu: provide is_vmalloc_addr() stub
From: Paul Mundt <lethal@linux-sh.org>

Introduced in commit-id 9e2779fa281cfda13ac060753d674bbcaa23367e and ifdef'ed
out for nommu in 8ca3ed87db062201e1fa15b64a9214e193fc3a8a, both approaches end
up breaking the nommu build in different ways.  An impressive feat for a
2-liner.

Current is_vmalloc_addr() users fall in to two camps:

	- Determining whether to use vfree()/kfree()
	- Whether to do vmlist traversal (only /proc/kcore).

Since we don't support /proc/kcore on nommu, that leaves the vfree()/kfree()
determination use cases.  nommu vfree() happens to be a wrapper to kfree()
anyways, so is_vmalloc_addr() can always return 0 and end up with the right
behaviour.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~nommu-provide-is_vmalloc_addr-stub include/linux/mm.h
--- a/include/linux/mm.h~nommu-provide-is_vmalloc_addr-stub
+++ a/include/linux/mm.h
@@ -235,15 +235,22 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
-#ifdef CONFIG_MMU
-/* Determine if an address is within the vmalloc range */
+/*
+ * Determine if an address is within the vmalloc range
+ *
+ * On nommu, vmalloc/vfree wrap through kmalloc/kfree directly, so there
+ * is no special casing required.
+ */
 static inline int is_vmalloc_addr(const void *x)
 {
+#ifdef CONFIG_MMU
 	unsigned long addr = (unsigned long)x;
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
-}
+#else
+	return 0;
 #endif
+}
 
 static inline struct page *compound_head(struct page *page)
 {
_

Patches currently in -mm which might be from lethal@linux-sh.org are

nommu-provide-is_vmalloc_addr-stub.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-sh.patch
smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch

