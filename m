Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC44CC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A554764ECB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBAXuY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhBAXuO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:50:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F33C64ECB;
        Mon,  1 Feb 2021 23:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223373;
        bh=9zhYBlRhKs7uNWychS9XJEvL0Er7qmGJx7YW23nh8kU=;
        h=Date:From:To:Subject:From;
        b=HYQgUFJNcm9VIQI8liqq3E/006Ich9OqaWBrg/hVkcr9EuZZLopDUS/qNHIH6nN2l
         nXwr3uEi34cLDn00pttFSuzmK7vDUUw3Uj5wUW8aeivejGN3fKThJ7al4xexgKDOXF
         8NzvMOXhVdyuFNRfy9CFD5RwwCJyDmjz6ThdDyLc=
Date:   Mon, 01 Feb 2021 15:49:32 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, mark.rutland@arm.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, richard.weiyang@linux.alibaba.com,
        teawaterz@linux.alibaba.com, will@kernel.org
Subject:  + s390-mm-define-arch_get_mappable_range.patch added to
 -mm tree
Message-ID: <20210201234932.yGIEdbStU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: define arch_get_mappable_range()
has been added to the -mm tree.  Its filename is
     s390-mm-define-arch_get_mappable_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/s390-mm-define-arch_get_mappable_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/s390-mm-define-arch_get_mappable_range.patch

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
Subject: s390/mm: define arch_get_mappable_range()

This overrides arch_get_mappabble_range() on s390 platform which will be
used with recently added generic framework.  It modifies the existing
range check in vmem_add_mapping() using arch_get_mappable_range().  It
also adds a VM_BUG_ON() check that would ensure that mhp_range_allowed()
has already been called on the hotplug path.

Link: https://lkml.kernel.org/r/1612149902-7867-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |    1 +
 arch/s390/mm/vmem.c |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/s390/mm/init.c~s390-mm-define-arch_get_mappable_range
+++ a/arch/s390/mm/init.c
@@ -297,6 +297,7 @@ int arch_add_memory(int nid, u64 start,
 	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot))
 		return -EINVAL;
 
+	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
--- a/arch/s390/mm/vmem.c~s390-mm-define-arch_get_mappable_range
+++ a/arch/s390/mm/vmem.c
@@ -4,6 +4,7 @@
  *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
  */
 
+#include <linux/memory_hotplug.h>
 #include <linux/memblock.h>
 #include <linux/pfn.h>
 #include <linux/mm.h>
@@ -532,11 +533,22 @@ void vmem_remove_mapping(unsigned long s
 	mutex_unlock(&vmem_mutex);
 }
 
+struct range arch_get_mappable_range(void)
+{
+	struct range mhp_range;
+
+	mhp_range.start = 0;
+	mhp_range.end =  VMEM_MAX_PHYS - 1;
+	return mhp_range;
+}
+
 int vmem_add_mapping(unsigned long start, unsigned long size)
 {
+	struct range range = arch_get_mappable_range();
 	int ret;
 
-	if (start + size > VMEM_MAX_PHYS ||
+	if (start < range.start ||
+	    start + size > range.end + 1 ||
 	    start + size < start)
 		return -ERANGE;
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-basic-add-validation-for-dirtiness-after-write-protect.patch
mm-debug_vm_pgtable-basic-iterate-over-entire-protection_map.patch
mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
arm64-mm-define-arch_get_mappable_range.patch
s390-mm-define-arch_get_mappable_range.patch

