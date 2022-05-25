Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D354C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 22:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345402AbiEYWUV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 18:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbiEYWUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 18:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534BB36DF
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 15:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00193B81EBA
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 22:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB5EC385B8;
        Wed, 25 May 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653517213;
        bh=lVEW1fkD52EZQ8m4R1CWq9i2iRsIWvdstoQnLX6exTU=;
        h=Date:To:From:Subject:From;
        b=C92x1H2tocAVGyv2V+zkjX1upZhw4g0qJfW/3RKoQDpq9n+CbDlgvn21eC59KvU5G
         +JJCODonjQmMEedpfxfQlNNPEor1ibnmuFh1npwnKcys95wInunfNxTTIlAW4rgkyg
         6t9rbp+Twbqdy3cOU6rWnbcS4DflgTYbzq4O5x4s=
Date:   Wed, 25 May 2022 15:20:13 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, jrtc27@jrtc27.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmemc-suppress-shift-warning.patch added to mm-unstable branch
Message-Id: <20220525222013.8EB5EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: suppress shift warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmemc-suppress-shift-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmemc-suppress-shift-warning.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/shmem.c: suppress shift warning
Date: Wed May 25 03:17:09 PM PDT 2022

mm/shmem.c:1948 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?

On i386, so an unsigned long is 32-bit, but i_blocks is a 64-bit blkcnt_t.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jessica Clarke <jrtc27@jrtc27.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmemc-suppress-shift-warning
+++ a/mm/shmem.c
@@ -1945,7 +1945,7 @@ alloc_nohuge:
 
 	spin_lock_irq(&info->lock);
 	info->alloced += folio_nr_pages(folio);
-	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
+	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-shmemc-suppress-shift-warning.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

