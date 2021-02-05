Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D63FC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D6EF64FBB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 21:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhBEVM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhBEVMz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 16:12:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E020264FBB;
        Fri,  5 Feb 2021 21:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612559535;
        bh=FT+u1eV+WZr71RqgiYxyA9bB87uEJL/mjGKG+gzIhOk=;
        h=Date:From:To:Subject:From;
        b=M054H/T2O/FYKDl0TXy+am/kFrOBiBhyQFfImzlco1NoD/iYCIkoiBuVxFAReVL95
         peQbTA9LxHc1FdnjLJkS8ZFNTFAdMXat89xkUM0sz59X3iXbFPMQQYXV1Mg4Dnfihl
         9cZs96kxA31+AIU3sXmsmVfvGsUx4mOeO+9XR/TI=
Date:   Fri, 05 Feb 2021 13:12:14 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com,
        david@redhat.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hu?=
 =?US-ASCII?Q?gepage-support-is-disabled.patch?= added to -mm tree
Message-ID: <20210205211214.9-UBnXHBI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled
has been added to the -mm tree.  Its filename is
     mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled

Differentiate between hardware not supporting hugepages and user disabling
THP via 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'

For the devdax namespace, the kernel handles the above via the
supported_alignment attribute and failing to initialize the namespace if
the namespace align value is not supported on the platform.

For the fsdax namespace, the kernel will continue to initialize the
namespace.  This can result in the kernel creating a huge pte entry even
though the hardware don't support the same.

We do want hugepage support with pmem even if the end-user disabled THP
via sysfs file (/sys/kernel/mm/transparent_hugepage/enabled).  Hence
differentiate between hardware/firmware lacking support vs user-controlled
disable of THP and prevent a huge fault if the hardware lacks hugepage
support.

Link: https://lkml.kernel.org/r/20210205023956.417587-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   15 +++++++++------
 mm/huge_memory.c        |    6 +++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/linux/huge_mm.h~mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled
+++ a/include/linux/huge_mm.h
@@ -78,6 +78,7 @@ static inline vm_fault_t vmf_insert_pfn_
 }
 
 enum transparent_hugepage_flag {
+	TRANSPARENT_HUGEPAGE_NEVER_DAX,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -123,6 +124,13 @@ extern unsigned long transparent_hugepag
  */
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
+
+	/*
+	 * If the hardware/firmware marked hugepage support disabled.
+	 */
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
+		return false;
+
 	if (vma->vm_flags & VM_NOHUGEPAGE)
 		return false;
 
@@ -134,12 +142,7 @@ static inline bool __transparent_hugepag
 
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
-	/*
-	 * For dax vmas, try to always use hugepage mappings. If the kernel does
-	 * not support hugepages, fsdax mappings will fallback to PAGE_SIZE
-	 * mappings, and device-dax namespaces, that try to guarantee a given
-	 * mapping size, will fail to enable
-	 */
+
 	if (vma_is_dax(vma))
 		return true;
 
--- a/mm/huge_memory.c~mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled
+++ a/mm/huge_memory.c
@@ -386,7 +386,11 @@ static int __init hugepage_init(void)
 	struct kobject *hugepage_kobj;
 
 	if (!has_transparent_hugepage()) {
-		transparent_hugepage_flags = 0;
+		/*
+		 * Hardware doesn't support hugepages, hence disable
+		 * DAX PMD support.
+		 */
+		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_NEVER_DAX;
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-pmem-avoid-inserting-hugepage-pte-entry-with-fsdax-if-hugepage-support-is-disabled.patch

