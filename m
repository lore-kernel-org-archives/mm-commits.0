Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC5BC001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjHDSFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjHDSFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A962B46A8
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47631620B2
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989FDC433C8;
        Fri,  4 Aug 2023 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172309;
        bh=BRNhJPyQfsndXg6+zJ1XLiJnJBCXsm0qM7z5ExRLgBE=;
        h=Date:To:From:Subject:From;
        b=UFdJLf0q4nMraAQWIkw4FP4EZ1jO45vNGUwTPzQz6FauEDiER9NN2ZSzg38zlwEuZ
         LAGzy00dsr2cKMtcY9sYnDalHKDxSgGRt2PCZ8dny3EoL4FsOu/V70EgHLlqq/Mp4y
         nF3LP6VpEy3P9LXljz8I1ttdnxudBSHAeAy7PIbE=
Date:   Fri, 04 Aug 2023 11:05:08 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, ppbuk5246@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch removed from -mm tree
Message-Id: <20230804180509.989FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix
has been removed from the -mm tree.  Its filename was
     mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch

This patch was dropped because it was folded into mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch

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
mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch

