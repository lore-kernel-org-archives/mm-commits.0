Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58010C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 23:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EAB6187E
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 23:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEKXlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 19:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKXlC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 19:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F8A161433;
        Tue, 11 May 2021 23:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620776395;
        bh=SWoLDUcCyjL2k88fvMVB38y9x3q8jrzxAeI5+IL5aWY=;
        h=Date:From:To:Subject:From;
        b=jUttNTc5JmRqVqv0me+wroe60jvLEKK5VjyMj8HK6wqMYVORW62HXwECcR01uFEzg
         nHC5tMmlxzS4KmOiSHjWgfmZIXnBJ54vhRSRIxgbc2XMNnTHhpZlCBqhTUV0zS1mZ0
         Y0o8yI5IJ+gHDC1O1go9z1Lky6LFJJLdi8VEYFrg=
Date:   Tue, 11 May 2021 16:39:54 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, mark.rutland@arm.com,
        maz@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        will@kernel.org
Subject:  +
 include-linux-mmzoneh-add-documentation-for-pfn_valid.patch added to -mm
 tree
Message-ID: <20210511233954.psGLkNp75%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: add documentation for pfn_valid()
has been added to the -mm tree.  Its filename is
     include-linux-mmzoneh-add-documentation-for-pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mmzoneh-add-documentation-for-pfn_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: include/linux/mmzone.h: add documentation for pfn_valid()

Patch series "arm64: drop pfn_valid_within() and simplify pfn_valid()", v4.

These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
pfn_valid_within() to 1.  

The idea is to mark NOMAP pages as reserved in the memory map and restore
the intended semantics of pfn_valid() to designate availability of struct
page for a pfn.

With this the core mm will be able to cope with the fact that it cannot
use NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER
blocks will be treated correctly even without the need for
pfn_valid_within.


This patch (of 4):

Add comment describing the semantics of pfn_valid() that clarifies that
pfn_valid() only checks for availability of a memory map entry (i.e. 
struct page) for a PFN rather than availability of usable memory backing
that PFN.

The most "generic" version of pfn_valid() used by the configurations with
SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
suitable place for documentation about semantics of pfn_valid().

Link: https://lkml.kernel.org/r/20210511100550.28178-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210511100550.28178-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/mmzone.h~include-linux-mmzoneh-add-documentation-for-pfn_valid
+++ a/include/linux/mmzone.h
@@ -1416,6 +1416,17 @@ static inline int pfn_section_valid(stru
 #endif
 
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
+/**
+ * pfn_valid - check if there is a valid memory map entry for a PFN
+ * @pfn: the page frame number to check
+ *
+ * Check if there is a valid memory map entry aka struct page for the @pfn.
+ * Note, that availability of the memory map entry does not imply that
+ * there is actual usable memory at that @pfn. The struct page may
+ * represent a hole or an unusable page frame.
+ *
+ * Return: 1 for PFNs that have memory map entries and 0 otherwise
+ */
 static inline int pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

