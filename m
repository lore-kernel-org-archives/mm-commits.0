Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0BBC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9750461421
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 21:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhEMVz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 17:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233574AbhEMVz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 17:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C65761260;
        Thu, 13 May 2021 21:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620942888;
        bh=3fToGPKXJ4412qCki1d95kAqZ+nf7KUws0cnDzoz+as=;
        h=Date:From:To:Subject:From;
        b=ZZWczfe/8VY0Y6g5BLAARG4yyRnFn1LxLRmZm6Kgj76PzNNluBIKZvcm2DTonOm27
         RPHA0FkWXTZrveD8ABVikkWaJV8AChzPmqCQHA0l9Hz2Hcq+78MfER+B+q+WrLEsWH
         gy1nOsAPS3vTf3lj2zKU0PZfPWCKwPkXXwwoqY6k=
Date:   Thu, 13 May 2021 14:54:47 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com, jejb@linux.ibm.com,
        kirill@shutemov.name, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  [to-be-updated] mmap-make-mlock_future_check-global.patch
 removed from -mm tree
Message-ID: <20210513215447.hmf-5h6jc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: make mlock_future_check() global
has been removed from the -mm tree.  Its filename was
     mmap-make-mlock_future_check-global.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mmap: make mlock_future_check() global

Patch series "mm: introduce memfd_secret system call to create "secret" memory areas", v18.

This is an implementation of "secret" mappings backed by a file
descriptor.

The file descriptor backing secret memory mappings is created using a
dedicated memfd_secret system call The desired protection mode for the
memory is configured using flags parameter of the system call.  The mmap()
of the file descriptor created with memfd_secret() will create a "secret"
memory mapping.  The pages in that mapping will be marked as not present
in the direct map and will be present only in the page table of the owning
mm.

Although normally Linux userspace mappings are protected from other users,
such secret mappings are useful for environments where a hostile tenant is
trying to trick the kernel into giving them access to other tenants
mappings.

Additionally, in the future the secret mappings may be used as a mean to
protect guest memory in a virtual machine host.

For demonstration of secret memory usage we've created a userspace library

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/secret-memory-preloader.git

that does two things: the first is act as a preloader for openssl to
redirect all the OPENSSL_malloc calls to secret memory meaning any secret
keys get automatically protected this way and the other thing it does is
expose the API to the user who needs it.  We anticipate that a lot of the
use cases would be like the openssl one: many toolkits that deal with
secret keys already have special handling for the memory to try to give
them greater protection, so this would simply be pluggable into the
toolkits without any need for user application modification.

Hiding secret memory mappings behind an anonymous file allows usage of the
page cache for tracking pages allocated for the "secret" mappings as well
as using address_space_operations for e.g.  page migration callbacks.

The anonymous file may be also used implicitly, like hugetlb files, to
implement mmap(MAP_SECRET) and use the secret memory areas with "native"
mm ABIs in the future.

Removing of the pages from the direct map may cause its fragmentation on
architectures that use large pages to map the physical memory which
affects the system performance.  However, the original Kconfig text for
CONFIG_DIRECT_GBPAGES said that gigabyte pages in the direct map "...  can
improve the kernel's performance a tiny bit ..." (commit 00d1c5e05736
("x86: add gbpages switches")) and the recent report [1] showed that "... 
although 1G mappings are a good default choice, there is no compelling
evidence that it must be the only choice".  Hence, it is sufficient to
have secretmem disabled by default with the ability of a system
administrator to enable it at boot time.

In addition, there is also a long term goal to improve management of the
direct map.

[1] https://lore.kernel.org/linux-mm/213b4567-46ce-f116-9cdf-bbd0c884eb3c@linux.intel.com/


This patch (of 8):

It will be used by the upcoming secret memory implementation.

Link: https://lkml.kernel.org/r/20210303162209.8609-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210303162209.8609-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/mmap.c     |    5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mmap-make-mlock_future_check-global
+++ a/mm/internal.h
@@ -356,6 +356,9 @@ static inline void munlock_vma_pages_all
 extern void mlock_vma_page(struct page *page);
 extern unsigned int munlock_vma_page(struct page *page);
 
+extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
+			      unsigned long len);
+
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
  * we want to unconditionally remove a page from the pagecache -- e.g.,
--- a/mm/mmap.c~mmap-make-mlock_future_check-global
+++ a/mm/mmap.c
@@ -1352,9 +1352,8 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
-static inline int mlock_future_check(struct mm_struct *mm,
-				     unsigned long flags,
-				     unsigned long len)
+int mlock_future_check(struct mm_struct *mm, unsigned long flags,
+		       unsigned long len)
 {
 	unsigned long locked, lock_limit;
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch

