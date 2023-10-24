Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96D6C25B6E
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 15:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjJXPTQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjJXPSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 11:18:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C3F1FE4
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 08:17:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D50C433C8;
        Tue, 24 Oct 2023 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698160639;
        bh=xoRd3oZyXi9Oe4fjLrRE2mD3Did4LBtNyzZY1c9Ad1Q=;
        h=Date:To:From:Subject:From;
        b=rWHmC4JeOqUeTcb9vdOkQAOx3KINp2d7KQmLKMv+SeP3oGsqU0xpiWkvGflAZXqbZ
         Xse3uhVbHHkyFyphJumoEEJ19+ixe53++v/2X7aVZxdHl1MRCP8KGNY8ThojrOW6y7
         Rv+WYRyDvD0DypW+UXDCqzi4Z9l5wyWMtGtjoPjk=
Date:   Tue, 24 Oct 2023 08:17:17 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch added to mm-unstable branch
Message-Id: <20231024151719.45D50C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: migration attempt to match interleave nodes: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy: migration attempt to match interleave nodes: fix
Date: Mon, 23 Oct 2023 23:50:42 -0700 (PDT)

mm-unstable commit edd33b8807a1 ("mempolicy: migration attempt to match
interleave nodes") added a second vma_iter search to do_mbind(), to
determine the interleave index to be used in the MPOL_INTERLEAVE case.

But sadly it added it just after the mmap_write_unlock(), leaving this new
VMA search unprotected: and so syzbot reports suspicious RCU usage from
lib/maple_tree.c:856.

This could be fixed with an rcu_read_lock/unlock() pair (per Liam); but
since we have been relying on the mmap_lock up to this point, it's
slightly better to extend it over the new search too, for a well-defined
result consistent with the policy this mbind() is establishing (rather
than whatever might follow once the mmap_lock is dropped).

Link: https://lkml.kernel.org/r/3311d544-fb05-a7f1-1b74-16aa0f6cd4fe@google.com
Fixes: edd33b8807a1 ("mempolicy: migration attempt to match interleave nodes")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: syzbot+79fcba037b6df73756d3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/000000000000c05f1b0608657fde@google.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mempolicy-migration-attempt-to-match-interleave-nodes-fix
+++ a/mm/mempolicy.c
@@ -1293,8 +1293,6 @@ static long do_mbind(unsigned long start
 		}
 	}
 
-	mmap_write_unlock(mm);
-
 	if (!err && !list_empty(&pagelist)) {
 		/* Convert MPOL_DEFAULT's NULL to task or default policy */
 		if (!new) {
@@ -1336,7 +1334,11 @@ static long do_mbind(unsigned long start
 				mmpol.ilx -= page->index >> order;
 			}
 		}
+	}
 
+	mmap_write_unlock(mm);
+
+	if (!err && !list_empty(&pagelist)) {
 		nr_failed |= migrate_pages(&pagelist,
 				alloc_migration_target_by_mpol, NULL,
 				(unsigned long)&mmpol, MIGRATE_SYNC,
_

Patches currently in -mm which might be from hughd@google.com are

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch
mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch
ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch
mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

