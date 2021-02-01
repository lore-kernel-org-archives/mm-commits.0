Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44910C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BC964ECB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBAXuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhBAXuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C49A64ED2;
        Mon,  1 Feb 2021 23:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223370;
        bh=nW9C34fdz8V0Wg0ENDaGsBollJl5A4WGoPrspu59sMM=;
        h=Date:From:To:Subject:From;
        b=x/nQk5AwlmCpMxVOMjLaFBJ9oJ/7QgwjiJdVd17W6Bx50+q7z/tRkdCAgWf0HStPb
         FBcascmCjX8QE6iQ6IUAt0cQINysbzWR3R0wI1C4u7BZiPPnSjADfZANsZRgPKkI9l
         KXWysy4KSOi51j4mUKwkNURTLdennMuz6HEeC+WE=
Date:   Mon, 01 Feb 2021 15:49:29 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, mark.rutland@arm.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, richard.weiyang@linux.alibaba.com,
        teawaterz@linux.alibaba.com, will@kernel.org
Subject:  + arm64-mm-define-arch_get_mappable_range.patch added to
 -mm tree
Message-ID: <20210201234929.FHPeYkjF6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: define arch_get_mappable_range()
has been added to the -mm tree.  Its filename is
     arm64-mm-define-arch_get_mappable_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-define-arch_get_mappable_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-define-arch_get_mappable_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: define arch_get_mappable_range()

This overrides arch_get_mappable_range() on arm64 platform which will be
used with recently added generic framework.  It drops
inside_linear_region() and subsequent check in arch_add_memory() which are
no longer required.  It also adds a VM_BUG_ON() check that would ensure
that mhp_range_allowed() has already been called.

Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-define-arch_get_mappable_range
+++ a/arch/arm64/mm/mmu.c
@@ -1442,16 +1442,19 @@ static void __remove_pgd_mapping(pgd_t *
 	free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
 }
 
-static bool inside_linear_region(u64 start, u64 size)
+struct range arch_get_mappable_range(void)
 {
+	struct range mhp_range;
+
 	/*
 	 * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
 	 * accommodating both its ends but excluding PAGE_END. Max physical
 	 * range which can be mapped inside this linear mapping range, must
 	 * also be derived from its end points.
 	 */
-	return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
-	       (start + size - 1) <= __pa(PAGE_END - 1);
+	mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
+	mhp_range.end =  __pa(PAGE_END - 1);
+	return mhp_range;
 }
 
 int arch_add_memory(int nid, u64 start, u64 size,
@@ -1459,11 +1462,7 @@ int arch_add_memory(int nid, u64 start,
 {
 	int ret, flags = 0;
 
-	if (!inside_linear_region(start, size)) {
-		pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
-		return -EINVAL;
-	}
-
+	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 	if (rodata_full || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect.patch
mm-debug_vm_pgtable-basic-iterate-over-entire-protection_map.patch
mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
arm64-mm-define-arch_get_mappable_range.patch
s390-mm-define-arch_get_mappable_range.patch

