Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68833C64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 21:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjB0VoH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 16:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0VoG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 16:44:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD46E1BEA
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 13:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB28B80D9A
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 21:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C356C433EF;
        Mon, 27 Feb 2023 21:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677534243;
        bh=2Oyz55UiJ8nBfLmssVbhXolDOq/JrosJrbxvV54QZr0=;
        h=Date:To:From:Subject:From;
        b=hdSawq2S+dTa8Fr0j05IqlXSBWq42tPvOfMLDqYTF2Mbgtae2sqgOEWZ7InYNlujn
         GL7B02XeTwbm7mx2Ln1DblXusG5fRVHBdkaTLK8Cc7NfUxNE/kUTT1nJae2XZen9h7
         JPoIus3+kY5UUkocLuanPMkOp05pBFV+gSTHwqgw=
Date:   Mon, 27 Feb 2023 13:44:02 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch added to mm-unstable branch
Message-Id: <20230227214403.3C356C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: use atomic_try_cmpxchg in set_tlb_ubc_flush_pending
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch

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

mm-rmap-use-atomic_try_cmpxchg-in-set_tlb_ubc_flush_pending.patch
nfs-remove-empty-if-statement-from-nfs3_prepare_get_acl.patch

