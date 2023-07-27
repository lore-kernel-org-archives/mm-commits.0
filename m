Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8D6C04A94
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjG0UIG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjG0UHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128FF26AB
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 13:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E32461EF0
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 20:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803AC433C7;
        Thu, 27 Jul 2023 20:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488464;
        bh=qs6gQRkmTKepQoegUZ4ZoE+3YbjNsCwfX8F1vcOrQn0=;
        h=Date:To:From:Subject:From;
        b=0/s5lXKsyCXKzhnt8zWpuPRHm6IYJuMUlpuXkEpwpzSr6ygFVffr57e2lZQeQCIRn
         01U5ncwqnC8a/KX6vg+qHWIXoIBuj6cJ+KnB8QNeoyJowOKG+TK4+uFtGW7ePNSVK/
         lKx7ECmPxOyFzzIdZ9FPidGnZraYbWTyteY5+g6c=
Date:   Thu, 27 Jul 2023 13:07:43 -0700
To:     mm-commits@vger.kernel.org, mikhail.v.gavrilov@gmail.com,
        labbott@fedoraproject.org, bagasdotme@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch removed from -mm tree
Message-Id: <20230727200743.E803AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalk: fix EFI_PGT_DUMP of espfix area
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pagewalk: fix EFI_PGT_DUMP of espfix area
Date: Sun, 23 Jul 2023 14:17:55 -0700 (PDT)

Booting x86_64 with CONFIG_EFI_PGT_DUMP=y shows messages of the form
"mm/pgtable-generic.c:53: bad pmd (____ptrval____)(8000000100077061)".

EFI_PGT_DUMP dumps all of efi_mm, including the espfix area, which is set
up with pmd entries which fit the pmd_bad() check: so 0d940a9b270b warns
and clears those entries, which would ruin running Win16 binaries.

The failing pte_offset_map() stopped such a kernel from even booting,
until a few commits later be872f83bf57 changed the pagewalk to tolerate
that: but it needs to be even more careful, to not spoil those entries.

I might have preferred to change init_espfix_ap() not to use "bad" pmd
entries; or to leave them out of the efi_mm dump.  But there is great
value in staying away from there, and a pagewalk check of address against
TASK_SIZE may protect from other such aberrations too.

Link: https://lkml.kernel.org/r/22bca736-4cab-9ee5-6a52-73a3b2bbe865@google.com
Closes: https://lore.kernel.org/linux-mm/CABXGCsN3JqXckWO=V7p=FhPU1tK03RE1w9UE6xL5Y86SMk209w@mail.gmail.com/
Fixes: 0d940a9b270b ("mm/pgtable: allow pte_offset_map[_lock]() to fail")
Fixes: be872f83bf57 ("mm/pagewalk: walk_pte_range() allow for pte_offset_map()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-efi_pgt_dump-of-espfix-area
+++ a/mm/pagewalk.c
@@ -48,8 +48,11 @@ static int walk_pte_range(pmd_t *pmd, un
 	if (walk->no_vma) {
 		/*
 		 * pte_offset_map() might apply user-specific validation.
+		 * Indeed, on x86_64 the pmd entries set up by init_espfix_ap()
+		 * fit its pmd_bad() check (_PAGE_NX set and _PAGE_RW clear),
+		 * and CONFIG_EFI_PGT_DUMP efi_mm goes so far as to walk them.
 		 */
-		if (walk->mm == &init_mm)
+		if (walk->mm == &init_mm || addr >= TASK_SIZE)
 			pte = pte_offset_kernel(pmd, addr);
 		else
 			pte = pte_offset_map(pmd, addr);
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock-fix.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
s390-add-pte_free_defer-for-pgtables-sharing-page-fix.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

