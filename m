Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3894C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8490D6135D
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352659AbhERV5Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 17:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233561AbhERV5Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 17:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94BDA61261;
        Tue, 18 May 2021 21:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621374966;
        bh=ztrGQdjvaK8ZjhVujLy4VXTJwFQrIK0RTUp4m3m3gbc=;
        h=Date:From:To:Subject:From;
        b=gX/008rm2iFqGgtkxHE08Jxx9tQlhbsfwayrsnJ9DaOKhtBbJfVlsjx6gmFZ+uGnA
         sNG8YI4IJJsgfqkWuwn3lJbTUw8TJp5mLpgXQf11GHgZ3IG5bp2lBAcJos3zfQgBqn
         X5pyU/Pw0sGo9cgZ+UwJuOMAvZbkyFYRgVsWSVlU=
Date:   Tue, 18 May 2021 14:56:05 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, jejb@linux.ibm.com,
        kirill@shutemov.name, lkp@intel.com, luto@kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  + mmap-make-mlock_future_check-global.patch added to -mm
 tree
Message-ID: <20210518215605.kXb0qLTWF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: make mlock_future_check() global
has been added to the -mm tree.  Its filename is
     mmap-make-mlock_future_check-global.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmap-make-mlock_future_check-global.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmap-make-mlock_future_check-global.patch

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
Subject: mmap: make mlock_future_check() global

Patch series "mm: introduce memfd_secret system call to create "secret" memory areas", v20.

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

It's designed to provide the following protections:

* Enhanced protection (in conjunction with all the other in-kernel
  attack prevention systems) against ROP attacks.  Seceretmem makes
  "simple" ROP insufficient to perform exfiltration, which increases the
  required complexity of the attack.  Along with other protections like
  the kernel stack size limit and address space layout randomization which
  make finding gadgets is really hard, absence of any in-kernel primitive
  for accessing secret memory means the one gadget ROP attack can't work. 
  Since the only way to access secret memory is to reconstruct the missing
  mapping entry, the attacker has to recover the physical page and insert
  a PTE pointing to it in the kernel and then retrieve the contents.  That
  takes at least three gadgets which is a level of difficulty beyond most
  standard attacks.

* Prevent cross-process secret userspace memory exposures.  Once the
  secret memory is allocated, the user can't accidentally pass it into the
  kernel to be transmitted somewhere.  The secreremem pages cannot be
  accessed via the direct map and they are disallowed in GUP.

* Harden against exploited kernel flaws.  In order to access secretmem,
  a kernel-side attack would need to either walk the page tables and
  create new ones, or spawn a new privileged uiserspace process to perform
  secrets exfiltration using ptrace.

In the future the secret mappings may be used as a mean to protect guest
memory in a virtual machine host.

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


This patch (of 7):

It will be used by the upcoming secret memory implementation.

Link: https://lkml.kernel.org/r/20210518072034.31572-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210518072034.31572-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
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
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/mmap.c     |    5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mmap-make-mlock_future_check-global
+++ a/mm/internal.h
@@ -361,6 +361,9 @@ static inline void munlock_vma_pages_all
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
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

