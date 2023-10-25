Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE65CC0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJYXk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJYXk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:40:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0545013A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:40:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD52C433C8;
        Wed, 25 Oct 2023 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277226;
        bh=1Fu9+wCnGdSqfV8/TGjNO268mr/LpgDNvoaca5FJI4U=;
        h=Date:To:From:Subject:From;
        b=PMhHppHgdE1LCFU67kTmZxU4NZ0GxdELGsiN/91K3dDFhw8aovRyuWbtSYpieg3Mi
         E4lIdhkovTHNYHJ7EsGsi5GgANBR/29IXwd7zjmVZw+XwSQESqKu1zaj0mK9CPCCo5
         bQkFNqGHsRaAU8skhXCSCIgjVglXrJT2FzaKURnM=
Date:   Wed, 25 Oct 2023 16:40:25 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch removed from -mm tree
Message-Id: <20231025234026.8DD52C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempolicy: migration attempt to match interleave nodes: fix
has been removed from the -mm tree.  Its filename was
     mempolicy-migration-attempt-to-match-interleave-nodes-fix.patch

This patch was dropped because it was folded into mempolicy-migration-attempt-to-match-interleave-nodes.patch

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
@@ -1291,8 +1291,6 @@ static long do_mbind(unsigned long start
 		}
 	}
 
-	mmap_write_unlock(mm);
-
 	if (!err && !list_empty(&pagelist)) {
 		/* Convert MPOL_DEFAULT's NULL to task or default policy */
 		if (!new) {
@@ -1334,7 +1332,11 @@ static long do_mbind(unsigned long start
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

ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch
mm-mlock-avoid-folio_within_range-on-ksm-pages.patch
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

