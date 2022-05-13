Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FB5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 21:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbiEMVSu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 17:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384650AbiEMVSp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 17:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569A553A50
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 14:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3919B831E3
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 21:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAE8C34100;
        Fri, 13 May 2022 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652476720;
        bh=TBk7yHRVMkKGnvw5Z/9kwRRSEEKVhVXqbTqBN1/FIx4=;
        h=Date:To:From:Subject:From;
        b=Q7vgJvqYPiUJWW34+xa/yYIwIfKyhbkyrEA411ExOCcbiH4v0U733FGpnCZD4Ajb6
         PteqOlgbV3rDtiqURA36nfxtIB0MMexujI8n7FuPeByGyF8gxLV427vWFxmyg8ir4s
         JYS6QD1NCZNbUXWG5+ca5vClEHJjEZCrMzHrkpOw=
Date:   Fri, 13 May 2022 14:18:39 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        luomeng12@huawei.com, hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch added to mm-unstable branch
Message-Id: <20220513211840.7CAE8C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch

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
Subject: tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
Date: Fri May 13 02:17:20 PM PDT 2022

Cc: Luo Meng <luomeng12@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix
+++ a/mm/shmem.c
@@ -3477,7 +3477,7 @@ static int shmem_reconfigure(struct fs_c
 	raw_spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if (ctx->blocks > S64_MAX) {
-		err = "The number of blocks too large";
+		err = "Number of blocks too large";
 		goto out;
 	}
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

