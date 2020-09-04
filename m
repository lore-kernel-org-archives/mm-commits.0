Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCC2C54EFC
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA5D206D4
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243029;
	bh=TTHCFw3ZCl6kXI4ZO1xxj08dpK+jvAVPAIDatV1QjvE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=h/hlHx/QsWkMy95akK5QCDOd/ekCDBaLgABcPMDkUy+hIhR3KfK2CsvDLHEBh+BvN
	 oa6nVult6J9hFtmQ4y0UQvY+tSjCyQia8l3rsGgtE1JbB8iKIfj8UklOPtNPzcrFru
	 j0GpI7F0eoQnnAHIWx134ni3RedyHxd7o/Y9+HpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgIDSK3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgIDSK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:10:28 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACDE21707;
        Fri,  4 Sep 2020 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599240636;
        bh=TTHCFw3ZCl6kXI4ZO1xxj08dpK+jvAVPAIDatV1QjvE=;
        h=Date:From:To:Subject:From;
        b=wSQZ/nu2sP8LRVCtCNx90dCoQhJO8ipJn9H3mKeUL33c4ZA45atkvrKfSu1RCn4uC
         M5fU61Br2sCFtJCLweVT0sTiBsIHITrJkYq1YUPjj62mEg1WM2N4jlEBx0VAk1ovyf
         a0NwN9dYTsBg64ML/AUgi9X7uewSMXDyelMxj7Ag=
Date:   Fri, 04 Sep 2020 10:30:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com, osalvador@suse.de,
        naoya.horiguchi@nec.com, mhocko@kernel.org,
        akpm@linux-foundation.org
Subject:  + mmhwpoison-drop-unneeded-pcplist-draining-fix.patch added
 to -mm tree
Message-ID: <20200904173032.DLnxD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-drop-unneeded-pcplist-draining-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-drop-unneeded-pcplist-draining-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-drop-unneeded-pcplist-draining-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-drop-unneeded-pcplist-draining-fix

remove unused local `zone', reflow block comment

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining-fix
+++ a/mm/madvise.c
@@ -869,7 +869,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct zone *zone;
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -901,9 +900,10 @@ static int madvise_inject_error(int beha
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
 			/*
-			 * Drop the page reference taken by get_user_pages_fast(). In
-			 * the absence of MF_COUNT_INCREASED the memory_failure()
-			 * routine is responsible for pinning the page to prevent it
+			 * Drop the page reference taken by
+			 * get_user_pages_fast().  In the absence of
+			 * MF_COUNT_INCREASED the memory_failure() routine is
+			 * responsible for pinning the page to prevent it
 			 * from being released back to the page allocator.
 			 */
 			put_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

