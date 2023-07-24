Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FB1C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjGXQnp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjGXQnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECE9E4F
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 230DB61278
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759F1C433C7;
        Mon, 24 Jul 2023 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690217021;
        bh=ieIUfI0XtcSzVc46za4F63wYlyYUciOsHM+99zfAyG0=;
        h=Date:To:From:Subject:From;
        b=oJXGaHSyqxh53ZsAkF0d5mHnS1dlAMQrQS19/YKXGgQG34S6xJZaGkfm+UPU4mSIc
         Fj/XwtEJRtRKXVjjBz87qPdqe/RPKrKfB5+mz+iUVe6uVUbKLmyUhT3prmNNIzzMEt
         X++qOItXpFGrf4aKhzhmMKbA4xbvj1qzZdNhfQPs=
Date:   Mon, 24 Jul 2023 09:43:40 -0700
To:     mm-commits@vger.kernel.org, mikhail.v.gavrilov@gmail.com,
        labbott@fedoraproject.org, bagasdotme@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch added to mm-hotfixes-unstable branch
Message-Id: <20230724164341.759F1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalk: fix EFI_PGT_DUMP of espfix area
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch
shmem-minor-fixes-to-splice-read-implementation.patch
mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock-fix.patch

