Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E1AEB64DC
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 15:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbjGNP5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbjGNP5e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 11:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D609835A0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 08:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF3261D5A
        for <mm-commits@vger.kernel.org>; Fri, 14 Jul 2023 15:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B898EC433C7;
        Fri, 14 Jul 2023 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689350249;
        bh=7iHMyzsc+JPnY9xcNjuguzXKOaRMTuQoWUheZ5Ym+vc=;
        h=Date:To:From:Subject:From;
        b=S2aNjEXsgYouZx3N6ipVzrcdyTn7WMyxnxkih9+fUTB4hMrNcL8VrVrnSKFccp7JN
         YDGrw2myFX42mUGNyN9GlvfwI/uixqRTkfK/dMUNhRxOuU8GN2raDR2D87N97AmN6Y
         gQF4ZKpPJ+8XWFju9vcHMNa7dQ1QB115eqFKNHWQ=
Date:   Fri, 14 Jul 2023 08:57:29 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, cem@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-prepare-shmem-quota-infrastructure-fix.patch added to mm-unstable branch
Message-Id: <20230714155729.B898EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-prepare-shmem-quota-infrastructure-fix
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-prepare-shmem-quota-infrastructure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-prepare-shmem-quota-infrastructure-fix.patch

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
Subject: shmem-prepare-shmem-quota-infrastructure-fix
Date: Fri Jul 14 08:54:52 AM PDT 2023

make shmem_mark_dquot_dirty and shmem_dquot_write_info static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307141341.R961dyMt-lkp@intel.com/
Cc: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem_quota.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem_quota.c~shmem-prepare-shmem-quota-infrastructure-fix
+++ a/mm/shmem_quota.c
@@ -283,12 +283,12 @@ out_dqlock:
 	return 0;
 }
 
-int shmem_mark_dquot_dirty(struct dquot *dquot)
+static int shmem_mark_dquot_dirty(struct dquot *dquot)
 {
 	return 0;
 }
 
-int shmem_dquot_write_info(struct super_block *sb, int type)
+static int shmem_dquot_write_info(struct super_block *sb, int type)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
shmem-prepare-shmem-quota-infrastructure-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

