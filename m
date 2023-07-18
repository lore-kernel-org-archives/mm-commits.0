Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6698FC00528
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 17:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjGRRV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjGRRVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 13:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F470CC
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 10:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D54761523
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 17:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F238DC433C7;
        Tue, 18 Jul 2023 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689700876;
        bh=YmX/s7HOvfkxJ4gylJ665G9+dsyly8k4zbXUHcpj05U=;
        h=Date:To:From:Subject:From;
        b=aH2byxhx/YQ7dNTb0LDInE7zUzWhaYewUmA5TAbThe9Jtgx12WYfPHs7qjHLIzuzT
         qQbNWVk0YPN3qflJfnt/vLZe8byBJVrW1H0jpwA/fUnu9hymY4/5bzx49o5l3dsoUP
         a1ONEAc6IUiTruPobFF+JYF1v3hESbbHzIMGTYyw=
Date:   Tue, 18 Jul 2023 10:21:15 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        muchun.song@linux.dev, glider@google.com, elver@google.com,
        dvyukov@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch added to mm-unstable branch
Message-Id: <20230718172115.F238DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kfence-allocate-kfence_metadata-at-runtime-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch

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
Subject: mm-kfence-allocate-kfence_metadata-at-runtime-fix
Date: Tue Jul 18 10:20:11 AM PDT 2023

restore newline, per Marco

Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c~mm-kfence-allocate-kfence_metadata-at-runtime-fix
+++ a/mm/kfence/core.c
@@ -912,6 +912,7 @@ static int kfence_init_late(void)
 
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
+
 	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
 				   NULL);
 	if (!pages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

