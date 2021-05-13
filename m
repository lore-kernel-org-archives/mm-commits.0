Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64030C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 416E96143E
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhEMWLg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhEMWLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82691613C9;
        Thu, 13 May 2021 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620943826;
        bh=s1mQT18kQmPW2aBllkLzsep9yUAvWhDjJN/fkGgM6Bo=;
        h=Date:From:To:Subject:From;
        b=rFuWtCdPsSBWAiLqACTAEbksKoRKWFlBlJqYBZRgVF52kBjDfHTCfTOE2DhoIk4UP
         VmmkV79UD7TOv5FqOv2jUhoa0NkK+GPwc45tHZOM6KXq4d0Mf08UOV53923liRzSbK
         oZa92V0S7fjKCy5lGpchTq573oZWahhYW+xA1QdI=
Date:   Thu, 13 May 2021 15:10:25 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, jejb@linux.ibm.com, kirill@shutemov.name,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        oliver.sang@intel.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org, willy@infradead.org
Subject:  [to-be-updated]
 =?US-ASCII?Q?mm-introduce-memfd=5Fsecret-system-call-to-create-secret-?=
 =?US-ASCII?Q?memory-areas-fix-3.patch?= removed from -mm tree
Message-ID: <20210513221025.oqs0fsinG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem: optimize page_is_secretmem()
has been removed from the -mm tree.  Its filename was
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: secretmem: optimize page_is_secretmem()

Kernel test robot reported -4.2% regression of
will-it-scale.per_thread_ops due to commit "mm: introduce memfd_secret
system call to create "secret" memory areas".

The perf profile of the test indicated that the regression is caused by
page_is_secretmem() called from gup_pte_range() (inlined by
gup_pgd_range):

 27.76  +2.5  30.23       perf-profile.children.cycles-pp.gup_pgd_range
  0.00  +3.2   3.19    2%  perf-profile.children.cycles-pp.page_mapping
  0.00  +3.7   3.66    2%  perf-profile.children.cycles-pp.page_is_secretmem

Further analysis showed that the slow down happens because neither
page_is_secretmem() nor page_mapping() are not inline and moreover,
multiple page flags checks in page_mapping() involve calling
compound_head() several times for the same page.

Make page_is_secretmem() inline and replace page_mapping() with page flag
checks that do not imply page-to-head conversion.

Link: https://lkml.kernel.org/r/20210420150049.14031-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
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

 include/linux/secretmem.h |   26 +++++++++++++++++++++++++-
 mm/secretmem.c            |   12 +-----------
 2 files changed, 26 insertions(+), 12 deletions(-)

--- a/include/linux/secretmem.h~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3
+++ a/include/linux/secretmem.h
@@ -4,8 +4,32 @@
 
 #ifdef CONFIG_SECRETMEM
 
+extern const struct address_space_operations secretmem_aops;
+
+static inline bool page_is_secretmem(struct page *page)
+{
+	struct address_space *mapping;
+
+	/*
+	 * Using page_mapping() is quite slow because of the actual call
+	 * instruction and repeated compound_head(page) inside the
+	 * page_mapping() function.
+	 * We know that secretmem pages are not compound and LRU so we can
+	 * save a couple of cycles here.
+	 */
+	if (PageCompound(page) || !PageLRU(page))
+		return false;
+
+	mapping = (struct address_space *)
+		((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+
+	if (mapping != page->mapping)
+		return false;
+
+	return page->mapping->a_ops == &secretmem_aops;
+}
+
 bool vma_is_secretmem(struct vm_area_struct *vma);
-bool page_is_secretmem(struct page *page);
 
 #else
 
--- a/mm/secretmem.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3
+++ a/mm/secretmem.c
@@ -137,22 +137,12 @@ static void secretmem_freepage(struct pa
 	clear_highpage(page);
 }
 
-static const struct address_space_operations secretmem_aops = {
+const struct address_space_operations secretmem_aops = {
 	.freepage	= secretmem_freepage,
 	.migratepage	= secretmem_migratepage,
 	.isolate_page	= secretmem_isolate_page,
 };
 
-bool page_is_secretmem(struct page *page)
-{
-	struct address_space *mapping = page_mapping(page);
-
-	if (!mapping)
-		return false;
-
-	return mapping->a_ops == &secretmem_aops;
-}
-
 static struct vfsmount *secretmem_mnt;
 
 static struct file *secretmem_file_create(unsigned long flags)
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
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch

