From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-track-active-portions-of-a-section-at-boot-fix-fix.patch removed from
 -mm tree
Date: Wed, 15 Feb 2017 13:49:15 -0800
Message-ID: <58a4ccdb.ZIe+SbMBXQYc1xTc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdBOVtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track-active-portions-of-a-section-at-boot-fix fix
has been removed from the -mm tree.  Its filename was
     mm-track-active-portions-of-a-section-at-boot-fix-fix.patch

This patch was dropped because it was folded into mm-track-active-portions-of-a-section-at-boot.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: track-active-portions-of-a-section-at-boot-fix fix

A bugfix introduced a new warning as it marked a function as __init
that is called by both __init and non-__init functions:

WARNING: vmlinux.o(.text.unlikely+0x1b26): Section mismatch in reference from the function section_deactivate() to the function .init.text:section_active_mask()
WARNING: vmlinux.o(.meminit.text+0x1ce0): Section mismatch in reference from the function sparse_add_section() to the function .init.text:section_active_mask()

This removes the annotation again.

Fixes: mmotm ("mm-track-active-portions-of-a-section-at-boot-fix")
Link: http://lkml.kernel.org/r/20170123121509.3143377-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/sparse.c~mm-track-active-portions-of-a-section-at-boot-fix-fix mm/sparse.c
--- a/mm/sparse.c~mm-track-active-portions-of-a-section-at-boot-fix-fix
+++ a/mm/sparse.c
@@ -173,8 +173,8 @@ static int __init section_active_index(p
 	return (phys & ~(PA_SECTION_MASK)) / SECTION_ACTIVE_SIZE;
 }
 
-static unsigned long __init section_active_mask(unsigned long pfn,
-						unsigned long nr_pages)
+static unsigned long section_active_mask(unsigned long pfn,
+					 unsigned long nr_pages)
 {
 	int idx_start, idx_size;
 	phys_addr_t start, size;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-track-active-portions-of-a-section-at-boot.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix.patch

