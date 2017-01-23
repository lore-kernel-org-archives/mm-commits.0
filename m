From: akpm@linux-foundation.org
Subject: + mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
 added to -mm tree
Date: Mon, 23 Jan 2017 15:57:43 -0800
Message-ID: <58869877.zbpmhvMUTpgQKWaO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdAWX5p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track-active-portions-of-a-section-at-boot-fix fix
has been added to the -mm tree.  Its filename is
     mm-track-active-portions-of-a-section-at-boot-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-active-portions-of-a-section-at-boot-fix-fix.patch

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

memstick-core-avoid-wnonnull-warning.patch
mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

