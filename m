Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC35C77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 21:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDKVDn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 17:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDKVDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 17:03:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89B230C4
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 14:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 546E26238C
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 21:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C31C433EF;
        Tue, 11 Apr 2023 21:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681247019;
        bh=jMaa+jPdsiT3fE9pQ61JzEyFWh0fwlLbSWtLFGilt4U=;
        h=Date:To:From:Subject:From;
        b=zqSoZ2kp5mr9YN9hNfuJnwTqpuYAQV7DtdRz9g/J6VOoX+IzOum/vfdtjwMEna8w0
         o6hJWMs0BkMV7i/Yrv3gDNF7P1rHYxhS4FjWrMbDWbSqSQVLJpdbyi4Aq4lhEd1yy8
         j0cmTDbNhaj4v0sEzok2jxErmUWr/uLULbs6W8Nc=
Date:   Tue, 11 Apr 2023 14:03:39 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shuah@kernel.org,
        sam@ravnborg.org, peterx@redhat.com, hughd@google.com,
        davem@davemloft.net, anshuman.khandual@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch added to mm-unstable branch
Message-Id: <20230411210339.A3C31C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: revert "mm/migrate: fix wrongly apply write bit after mkdirty on sparc64"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: revert "mm/migrate: fix wrongly apply write bit after mkdirty on sparc64"
Date: Tue, 11 Apr 2023 16:25:10 +0200

This reverts commit 96a9c287e25d ("mm/migrate: fix wrongly apply write bit
after mkdirty on sparc64").

Now that sparc64 mkdirty handling is fixed and no longer sets a PTE/PMD
writable that shouldn't be writable, let's revert the temporary fix.

The mkdirty mm selftest still passes with this change on sparc64.

Note that loongarch handling was fixed in commit bf2f34a506e6 ("LoongArch:
Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()").

Link: https://lkml.kernel.org/r/20230411142512.438404-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 mm/migrate.c     |    2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64
+++ a/mm/huge_memory.c
@@ -3335,6 +3335,8 @@ void remove_migration_pmd(struct page_vm
 	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
+	if (is_writable_migration_entry(entry))
+		pmde = maybe_pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
 	if (!is_migration_entry_young(entry))
@@ -3342,10 +3344,6 @@ void remove_migration_pmd(struct page_vm
 	/* NOTE: this may contain setting soft-dirty on some archs */
 	if (PageDirty(new) && is_migration_entry_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = maybe_pmd_mkwrite(pmde, vma);
-	else
-		pmde = pmd_wrprotect(pmde);
 
 	if (PageAnon(new)) {
 		rmap_t rmap_flags = RMAP_COMPOUND;
--- a/mm/migrate.c~mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64
+++ a/mm/migrate.c
@@ -225,8 +225,6 @@ static bool remove_migration_pte(struct
 			pte = maybe_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
-		else
-			pte = pte_wrprotect(pte);
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch
m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch
mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch
selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch

