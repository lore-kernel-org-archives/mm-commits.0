From: akpm@linux-foundation.org
Subject: + mm-introduce-kernelcore=mirror-option-fix-2.patch added to -mm
 tree
Date: Mon, 04 Jan 2016 14:55:07 -0800
Message-ID: <568af84b.MmaLLQzJIQPkvUws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbcADWzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 17:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, izumi.taku@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid unused variables in memmap_init_zone
has been added to the -mm tree.  Its filename is
     mm-introduce-kernelcore=mirror-option-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-kernelcore%3Dmirror-option-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-kernelcore%3Dmirror-option-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: avoid unused variables in memmap_init_zone

A quick fix on mm/page_alloc.c introduced a harmless warning:

mm/page_alloc.c: In function 'memmap_init_zone':
mm/page_alloc.c:4617:44: warning: unused variable 'tmp' [-Wunused-variable]
mm/page_alloc.c:4617:26: warning: unused variable 'r' [-Wunused-variable]

This uses another #ifdef to avoid declaring the two variables when the
code is not built.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-introduce-kernelcore=mirror-option-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-kernelcore=mirror-option-fix-2
+++ a/mm/page_alloc.c
@@ -4465,7 +4465,9 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long pfn;
 	struct zone *z;
 	unsigned long nr_initialised = 0;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	struct memblock_region *r = NULL, *tmp;
+#endif
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
mm-introduce-kernelcore=mirror-option-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

