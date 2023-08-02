Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D4DC001DF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 19:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbjHBTQv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjHBTQr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 15:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B7EE7D
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 12:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED4861AB8
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 19:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9004EC433C8;
        Wed,  2 Aug 2023 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691003802;
        bh=HTz0iZyb/wIn21wjC8+f3/X7VWOZzLaw4vNaOzqAajw=;
        h=Date:To:From:Subject:From;
        b=pmvQV3ubm5vNIa0TX5tWXkbrIueR30lkCKGWywQFxfaSHWtdpyzTyzm76kiIk7Y4b
         bkK9D4S5LIt4UMGq+OlNeRodu7trqxkjxYpuawWIaD3vusvmg8Rd1g1h2EHFBJbnV2
         VJcGXJzjJd7l1R7dhsJRYChzT9TYKZWcLocqaKMg=
Date:   Wed, 02 Aug 2023 12:16:42 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch added to mm-unstable branch
Message-Id: <20230802191642.9004EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch

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
Subject: mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix
Date: Wed Aug  2 12:15:54 PM PDT 2023

fix printk grammar

Cc: Levi Yun <ppbuk5246@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix
+++ a/mm/mm_init.c
@@ -402,7 +402,7 @@ static void __init find_zone_movable_pfn
 			pr_warn("This configuration results in unmirrored kernel memory.\n");
 
 		if (no_mirror_mem) {
-			pr_warn("There is no mirrored memory. Ignore kernelcore=mirror.\n");
+			pr_warn("There is no mirrored memory. Ignoring kernelcore=mirror.\n");
 			mirrored_kernelcore = false;
 			memset(zone_movable_pfn, 0x00, sizeof(zone_movable_pfn));
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

