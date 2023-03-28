Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D54EC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjC1XVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjC1XVZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3EA2D43
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE668619E9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD0AC4339B;
        Tue, 28 Mar 2023 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045677;
        bh=ZPB4zXkTgqskMYvj8gWbNG2NxaDkrdTmm+RqbPFt8ic=;
        h=Date:To:From:Subject:From;
        b=PqWt5Y4KmoGpxoe7KiIQ1ww7LNB4CDlcADLxfzYqBLui0c4C685ponrqovDLInObD
         6Mlutv+ZDf1+tMnkOq+B9RuF/Bf1OUt3/3o4ZEgo2fhvdORghLD34HQ7gXOrQbk0Mj
         rgP1dDuFLtC11kfJ17BpIf8Br/DJgqo3lHTmizo0=
Date:   Tue, 28 Mar 2023 16:21:16 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch removed from -mm tree
Message-Id: <20230328232117.1CD0AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: use atomic_try_cmpxchg in set_tlb_ubc_flush_pending
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/rmap: use atomic_try_cmpxchg in set_tlb_ubc_flush_pending
Date: Mon, 27 Feb 2023 22:42:28 +0100

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in set_tlb_ubc_flush_pending.  86 CMPXCHG instruction returns success in
ZF flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails.

No functional change intended.

Link: https://lkml.kernel.org/r/20230227214228.3533299-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending
+++ a/mm/rmap.c
@@ -644,7 +644,7 @@ void try_to_unmap_flush_dirty(void)
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
-	int batch, nbatch;
+	int batch;
 
 	arch_tlbbatch_add_mm(&tlb_ubc->arch, mm);
 	tlb_ubc->flush_required = true;
@@ -662,11 +662,8 @@ retry:
 		 * overflow.  Reset `pending' and `flushed' to be 1 and 0 if
 		 * `pending' becomes large.
 		 */
-		nbatch = atomic_cmpxchg(&mm->tlb_flush_batched, batch, 1);
-		if (nbatch != batch) {
-			batch = nbatch;
+		if (!atomic_try_cmpxchg(&mm->tlb_flush_batched, &batch, 1))
 			goto retry;
-		}
 	} else {
 		atomic_inc(&mm->tlb_flush_batched);
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are

nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

