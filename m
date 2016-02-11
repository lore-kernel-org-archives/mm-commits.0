From: akpm@linux-foundation.org
Subject: + mm-fix-pfn_t-vs-highmem.patch added to -mm tree
Date: Thu, 11 Feb 2016 12:17:12 -0800
Message-ID: <56bcec48.WcNrQ6U8i4u5Oj0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcBKURN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Feb 2016 15:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, runaway@candw.ms, smf.linux@ntlworld.com, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     mm-fix-pfn_t-vs-highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-pfn_t-vs-highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-pfn_t-vs-highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix pfn_t vs highmem

The pfn_t type uses an unsigned long to store a pfn + flags value.  On a
64-bit platform the upper 12 bits of an unsigned long are never used for
storing the value of a pfn.  However, this is not true on highmem
platforms, all 32-bits of a pfn value are used to address a 44-bit
physical address space.  A pfn_t needs to store a 64-bit value.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=112211
Fixes: 01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Stuart Foster <smf.linux@ntlworld.com>
Reported-by: Julian Margetson <runaway@candw.ms>
Tested-by: Julian Margetson <runaway@candw.ms>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pfn.h   |    2 +-
 include/linux/pfn_t.h |   17 ++++++++---------
 kernel/memremap.c     |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/pfn.h~mm-fix-pfn_t-vs-highmem include/linux/pfn.h
--- a/include/linux/pfn.h~mm-fix-pfn_t-vs-highmem
+++ a/include/linux/pfn.h
@@ -10,7 +10,7 @@
  * backing is indicated by flags in the high bits of the value.
  */
 typedef struct {
-	unsigned long val;
+	u64 val;
 } pfn_t;
 #endif
 
diff -puN include/linux/pfn_t.h~mm-fix-pfn_t-vs-highmem include/linux/pfn_t.h
--- a/include/linux/pfn_t.h~mm-fix-pfn_t-vs-highmem
+++ a/include/linux/pfn_t.h
@@ -9,14 +9,13 @@
  * PFN_DEV - pfn is not covered by system memmap by default
  * PFN_MAP - pfn has a dynamic page mapping established by a device driver
  */
-#define PFN_FLAGS_MASK (((unsigned long) ~PAGE_MASK) \
-		<< (BITS_PER_LONG - PAGE_SHIFT))
-#define PFN_SG_CHAIN (1UL << (BITS_PER_LONG - 1))
-#define PFN_SG_LAST (1UL << (BITS_PER_LONG - 2))
-#define PFN_DEV (1UL << (BITS_PER_LONG - 3))
-#define PFN_MAP (1UL << (BITS_PER_LONG - 4))
+#define PFN_FLAGS_MASK (((u64) ~PAGE_MASK) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
+#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
+#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
+#define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
+#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
 
-static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, unsigned long flags)
+static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
 	pfn_t pfn_t = { .val = pfn | (flags & PFN_FLAGS_MASK), };
 
@@ -29,7 +28,7 @@ static inline pfn_t pfn_to_pfn_t(unsigne
 	return __pfn_to_pfn_t(pfn, 0);
 }
 
-extern pfn_t phys_to_pfn_t(phys_addr_t addr, unsigned long flags);
+extern pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags);
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
@@ -87,7 +86,7 @@ static inline pmd_t pfn_t_pmd(pfn_t pfn,
 #ifdef __HAVE_ARCH_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
-	const unsigned long flags = PFN_DEV|PFN_MAP;
+	const u64 flags = PFN_DEV|PFN_MAP;
 
 	return (pfn.val & flags) == flags;
 }
diff -puN kernel/memremap.c~mm-fix-pfn_t-vs-highmem kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-pfn_t-vs-highmem
+++ a/kernel/memremap.c
@@ -150,7 +150,7 @@ void devm_memunmap(struct device *dev, v
 }
 EXPORT_SYMBOL(devm_memunmap);
 
-pfn_t phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
+pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
 {
 	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-pfn_t-vs-highmem.patch
mm-config_nr_zones_extended.patch

