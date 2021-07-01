Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29017C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0975F6146B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbhGAAzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAAzX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:55:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689DE61424;
        Thu,  1 Jul 2021 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100774;
        bh=cwpHR2U3rgsQ1D0tBB/adt0ndL1h6FhVYdmnIbVUkEs=;
        h=Date:From:To:Subject:From;
        b=c2EiMFw9hKtB8b3H08PnZhxwSiVrrjrwDBM/dfjBoqRBurl6yXQ8fPHO9XjMLAr5Y
         VpJ5xZmF6Y3jP/QYtntOAyyM6ecffrML/cfD/LiznToFLUql71+v74Dn7vv/8S4+A9
         KAYegY9vr6rDZ5SmYwN7T+kdsMFDXxPidS35vkBs=
Date:   Wed, 30 Jun 2021 17:52:52 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  [folded-merged]
 mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch removed from -mm
 tree
Message-ID: <20210701005252.2covXYEIf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: fix a few thp pmd missing uffd-wp bit
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch

This patch was dropped because it was folded into mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: fix a few thp pmd missing uffd-wp bit

These include:

1. When remove migration pmd entry, should keep the uffd-wp bit from
   swap pte.  Note that we need to do this after setting write bit just in
   case we need to remove it.

2. When change huge pmd and convert write -> read migration entry,
   persist the same uffd-wp bit.

3. When convert pmd to swap entry, should drop the uffd-wp bit always.

Link: https://lkml.kernel.org/r/20210428225030.9708-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 ++
 mm/huge_memory.c        |    4 ++++
 2 files changed, 6 insertions(+)

--- a/include/linux/swapops.h~mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit
+++ a/include/linux/swapops.h
@@ -265,6 +265,8 @@ static inline swp_entry_t pmd_to_swp_ent
 
 	if (pmd_swp_soft_dirty(pmd))
 		pmd = pmd_swp_clear_soft_dirty(pmd);
+	if (pmd_swp_uffd_wp(pmd))
+		pmd = pmd_swp_clear_uffd_wp(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/huge_memory.c~mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit
+++ a/mm/huge_memory.c
@@ -1832,6 +1832,8 @@ int change_huge_pmd(struct vm_area_struc
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+			if (pmd_swp_uffd_wp(*pmd))
+				newpmd = pmd_swp_mkuffd_wp(newpmd);
 			set_pmd_at(mm, addr, pmd, newpmd);
 		}
 		goto unlock;
@@ -3242,6 +3244,8 @@ void remove_migration_pmd(struct page_vm
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_write_migration_entry(entry))
 		pmde = maybe_pmd_mkwrite(pmde, vma);
+	if (pmd_swp_uffd_wp(*pvmw->pmd))
+		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
 	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup_benchmark-support-threading.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch

