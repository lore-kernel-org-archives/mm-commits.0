Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0846DC001DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 19:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjGZTQ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 15:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjGZTQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 15:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A381FF0
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 12:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45CFF61CAB
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 19:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B91DC433CB;
        Wed, 26 Jul 2023 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690398983;
        bh=7QE0zP1Q8l9CXI1gkIplzeQpxqy2WymmpI9xy0E8TnY=;
        h=Date:To:From:Subject:From;
        b=e2ilTThMiqHvID6zEOOV7Df+qYNOZoXJAMlIiFcN9VLQya3/iiwDb0Rn98SFS7m66
         vf3e3qB1Oy+su/kvdoWtiCV3hk9O07FnsT1Sxzx6UAQ2sD3xH6IZJZw1KCQnYsiULq
         q53WbuOOMSkIGca25J4TqhDzkHQTzZsdG05DnqbM=
Date:   Wed, 26 Jul 2023 12:16:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        liubo254@huawei.com, hughd@google.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230726191623.9B91DC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
Date: Wed Jul 26 12:14:31 PM PDT 2023

tweak comment and code layout

Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -587,10 +587,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
-		/* FOLL_DUMP will return -EFAULT on huge zero page
-		 * FOLL_FORCE follow a PROT_NONE mapped page
+		/*
+		 * FOLL_DUMP: return -EFAULT on huge zero page
+		 * FOLL_FORCE: follow a PROT_NONE mapped page
 		 */
-		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP | FOLL_FORCE);
+		page = follow_trans_huge_pmd(vma, addr, pmd,
+					     FOLL_DUMP | FOLL_FORCE);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

smaps-fix-the-abnormal-memory-statistics-obtained-through-proc-pid-smaps-fix.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

