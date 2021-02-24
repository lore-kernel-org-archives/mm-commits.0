Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AFBC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555EB64F27
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhBXUId (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhBXUH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1DA64F2A;
        Wed, 24 Feb 2021 20:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197254;
        bh=NpB9lmmRQyZZ/AG1rGQlsl6vLwQN94NP96W1Shi5m34=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=plaHmhh/zYKMaQLEIje9AAVGxXxB96eIPA9AC0KwwuItJhTU0wsAc6S2nVsUiIs6t
         Fgo6j8SSkEnsz2a+kvdKrTXinhitk+UFymbgcQ/Ik310HNhGiKeVHnqY4t3iJ3y9Lm
         Y5OAXwQDnGNS8eDcBSxbH9JYaLqNiSCVRtqge9Cs=
Date:   Wed, 24 Feb 2021 12:07:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        dan.j.williams@intel.com, david@redhat.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 125/173] mm/pmem: avoid inserting hugepage PTE
 entry with fsdax if hugepage support is disabled
Message-ID: <20210224200732.t575kkZPb%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
