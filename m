Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1128C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9710864F30
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhB0Caa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhB0CaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADFCE64F2A;
        Sat, 27 Feb 2021 02:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392983;
        bh=ll/z3pringYPM5DdBVBQuJmmcji7flyS7IFSSVQ5oxM=;
        h=Date:From:To:Subject:From;
        b=KUH70BjAXyQwDHXXOl6Asqzhi0/mMVmD1KtNWusdsXgjUYHJZv9qO0nGBxraDjkoz
         YYbmOe8ibbmFFrOvV31Eh9uzJ/3ozG/O0GpCRkQZwspWog7KVHC1crIOKoKE2wXxXF
         m+erQFy+793TWGC12FeYB17J8zKfl3hLJ7fN/dFo=
Date:   Fri, 26 Feb 2021 18:29:42 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, mark.rutland@arm.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, richard.weiyang@linux.alibaba.com,
        teawaterz@linux.alibaba.com, will@kernel.org
Subject:  [merged] s390-mm-define-arch_get_mappable_range.patch
 removed from -mm tree
Message-ID: <20210227022942.9uDdQI6UY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: define arch_get_mappable_range()
has been removed from the -mm tree.  Its filename was
     s390-mm-define-arch_get_mappable_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


