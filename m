From: akpm@linux-foundation.org
Subject: + hotplug-memory-adding-non-section-aligned-memory-is-bad.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:33:37 -0700
Message-ID: <200803312133.m2VLXbV4027077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615AbYCaVee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, clameter@sgi.com, dave@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, y-goto@jp.fujitsu.com


The patch titled
     Subject: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory is bad
has been added to the -mm tree.  Its filename is
     hotplug-memory-adding-non-section-aligned-memory-is-bad.patch

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
Subject: Subject: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory is bad
From: Jeremy Fitzhardinge <jeremy@goop.org>

Adding non-section-aligned memory will cause bad results, because page
structures are only built on section-aligned boundaries.  Also, memory
whose size isn't a multiple of the section size is silently ignored.

This patch adds a couple of WARN_ONs to help confused programmers work
out what's going wrong when they hotplug memory without being aware of
these constraints.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/memory_hotplug.c    |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN include/linux/mmzone.h~hotplug-memory-adding-non-section-aligned-memory-is-bad include/linux/mmzone.h
--- a/include/linux/mmzone.h~hotplug-memory-adding-non-section-aligned-memory-is-bad
+++ a/include/linux/mmzone.h
@@ -829,6 +829,9 @@ static inline unsigned long early_pfn_to
 #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
+#define SECTION_SIZE		(1UL << SECTION_SIZE_BITS)
+#define SECTION_SIZE_MASK	(SECTION_SIZE - 1)
+
 #define SECTION_BLOCKFLAGS_BITS \
 	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
 
diff -puN mm/memory_hotplug.c~hotplug-memory-adding-non-section-aligned-memory-is-bad mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~hotplug-memory-adding-non-section-aligned-memory-is-bad
+++ a/mm/memory_hotplug.c
@@ -301,6 +301,11 @@ int add_memory_resource(int nid, struct 
 	u64 start = res->start;
 	u64 size = res->end - res->start + 1;
 
+	/* Adding non-section-aligned memory will give unexpected
+	   and unintuitive results. */
+	WARN_ON((start & SECTION_SIZE_MASK) != 0);
+	WARN_ON((size & SECTION_SIZE_MASK) != 0);
+
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		if (!pgdat)
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
git-x86.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
hotplug-memory-add-add_memory_resource.patch
hotplug-memory-adding-non-section-aligned-memory-is-bad.patch
sparsemem-reduce-i386-pae-section-size.patch
paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch
xen-make-blkif_getgeo-static.patch

