From: akpm@linux-foundation.org
Subject: + tools-vm-page-typesc-support-swap-entry.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:26:31 -0800
Message-ID: <56b3de27.O78d57RyCCm8SllQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbcBDX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:26:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, koct9i@gmail.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: support swap entry
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-support-swap-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-typesc-support-swap-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-typesc-support-swap-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: tools/vm/page-types.c: support swap entry

/proc/pid/pagemap (pte_to_pagemap_entry() internally) already reports
about swap entry, so let's make the in-kernel utility aware of it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-support-swap-entry tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-support-swap-entry
+++ a/tools/vm/page-types.c
@@ -61,6 +61,8 @@
 #define PM_PFRAME_BITS		55
 #define PM_PFRAME_MASK		((1LL << PM_PFRAME_BITS) - 1)
 #define PM_PFRAME(x)		((x) & PM_PFRAME_MASK)
+#define MAX_SWAPFILES_SHIFT	5
+#define PM_SWAP_OFFSET(x)	(((x) & PM_PFRAME_MASK) >> MAX_SWAPFILES_SHIFT)
 #define PM_SOFT_DIRTY		(1ULL << 55)
 #define PM_MMAP_EXCLUSIVE	(1ULL << 56)
 #define PM_FILE			(1ULL << 61)
@@ -92,7 +94,8 @@
 #define KPF_SLOB_FREE		49
 #define KPF_SLUB_FROZEN		50
 #define KPF_SLUB_DEBUG		51
-#define KPF_FILE		62
+#define KPF_FILE		61
+#define KPF_SWAP		62
 #define KPF_MMAP_EXCLUSIVE	63
 
 #define KPF_ALL_BITS		((uint64_t)~0ULL)
@@ -146,6 +149,7 @@ static const char * const page_flag_name
 	[KPF_SLUB_DEBUG]	= "E:slub_debug",
 
 	[KPF_FILE]		= "F:file",
+	[KPF_SWAP]		= "w:swap",
 	[KPF_MMAP_EXCLUSIVE]	= "1:mmap_exclusive",
 };
 
@@ -297,6 +301,10 @@ static unsigned long pagemap_pfn(uint64_
 	return pfn;
 }
 
+static unsigned long pagemap_swap_offset(uint64_t val)
+{
+	return val & PM_SWAP ? PM_SWAP_OFFSET(val) : 0;
+}
 
 /*
  * page flag names
@@ -452,6 +460,8 @@ static uint64_t expand_overloaded_flags(
 		flags |= BIT(SOFTDIRTY);
 	if (pme & PM_FILE)
 		flags |= BIT(FILE);
+	if (pme & PM_SWAP)
+		flags |= BIT(SWAP);
 	if (pme & PM_MMAP_EXCLUSIVE)
 		flags |= BIT(MMAP_EXCLUSIVE);
 
@@ -613,6 +623,22 @@ static void walk_pfn(unsigned long voffs
 	}
 }
 
+static void walk_swap(unsigned long voffset, uint64_t pme)
+{
+	uint64_t flags = kpageflags_flags(0, pme);
+
+	if (!bit_mask_ok(flags))
+		return;
+
+	if (opt_list == 1)
+		show_page_range(voffset, pagemap_swap_offset(pme), 1, flags);
+	else if (opt_list == 2)
+		show_page(voffset, pagemap_swap_offset(pme), flags);
+
+	nr_pages[hash_slot(flags)]++;
+	total_pages++;
+}
+
 #define PAGEMAP_BATCH	(64 << 10)
 static void walk_vma(unsigned long index, unsigned long count)
 {
@@ -632,6 +658,8 @@ static void walk_vma(unsigned long index
 			pfn = pagemap_pfn(buf[i]);
 			if (pfn)
 				walk_pfn(index + i, pfn, 1, buf[i]);
+			if (buf[i] & PM_SWAP)
+				walk_swap(index + i, buf[i]);
 		}
 
 		index += pages;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch
mm-madvise-update-comment-on-sys_madvise.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
tools-vm-page-typesc-support-swap-entry.patch

