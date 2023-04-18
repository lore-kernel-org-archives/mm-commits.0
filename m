Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB879C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjDRXfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2DE7D9A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E12B62ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6447BC433EF;
        Tue, 18 Apr 2023 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860865;
        bh=fq8PK0KzELWjEaz8t+1RqpY5Wvt9xWy0TRkdFO9EPgk=;
        h=Date:To:From:Subject:From;
        b=DT70iNyRQPOzStOQlirFL1NxE+7e8KkHVy8OaudCjhkZ+RQJXVT8cRjuleshw1xb6
         6sfSWCUCVIWINNuJbOO6EEX8lSHo0rBQak3djyhaJbB8ZYZuKbhB8+9kaZYO1yBTIC
         ngV0hPZPRp0HOvaMRbWo9LgT0QSq5js0jIPLw84E=
Date:   Tue, 18 Apr 2023 16:34:24 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        peterx@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch removed from -mm tree
Message-Id: <20230418233425.6447BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: don't consider uffd-wp bit of writable migration entries
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: don't consider uffd-wp bit of writable migration entries
Date: Wed, 5 Apr 2023 18:02:36 +0200

If we end up with a writable migration entry that has the uffd-wp bit set,
we already messed up: the source PTE/PMD was writable, which means we
could have modified the page without notifying uffd first.  Setting the
uffd-wp bit always implies converting migration entries to !writable
migration entries.

Commit 8f34f1eac382 ("mm/userfaultfd: fix uffd-wp special cases for
fork()") documents that "3.  Forget to carry over uffd-wp bit for a write
migration huge pmd entry", but it doesn't really say why that should be
relevant.

So let's remove that code to avoid hiding an eventual underlying issue (in
the future, we might want to warn when creating writable migration entries
that have the uffd-wp bit set -- or even better when turning a PTE
writable that still has the uffd-wp bit set).

This now matches the handling for hugetlb migration entries in
hugetlb_change_protection().

In copy_huge_pmd()/copy_nonpresent_pte()/copy_hugetlb_page_range(), we
still transfer the uffd-bit also for writable migration entries, but
simply because we have unified handling for "writable" and
"readable-exclusive" migration entries, and we care about transferring the
uffd-wp bit for the latter.

Link: https://lkml.kernel.org/r/20230405160236.587705-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 --
 mm/mprotect.c    |    2 --
 2 files changed, 4 deletions(-)

--- a/mm/huge_memory.c~mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries
+++ a/mm/huge_memory.c
@@ -1845,8 +1845,6 @@ int change_huge_pmd(struct mmu_gather *t
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
-			if (pmd_swp_uffd_wp(*pmd))
-				newpmd = pmd_swp_mkuffd_wp(newpmd);
 		} else {
 			newpmd = *pmd;
 		}
--- a/mm/mprotect.c~mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries
+++ a/mm/mprotect.c
@@ -223,8 +223,6 @@ static long change_pte_range(struct mmu_
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
-				if (pte_swp_uffd_wp(oldpte))
-					newpte = pte_swp_mkuffd_wp(newpte);
 			} else if (is_writable_device_private_entry(entry)) {
 				/*
 				 * We do not preserve soft-dirtiness. See
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch
mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch

