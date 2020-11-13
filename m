Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52CFC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 02:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF7420B80
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 02:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9j2L/X2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgKMC5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 21:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMC5h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 21:57:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C927920A8B;
        Fri, 13 Nov 2020 02:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605236256;
        bh=ouIC4kVC0kon0+/jQePoElttMqRWefLUOoI/7/jRgfQ=;
        h=Date:From:To:Subject:From;
        b=C9j2L/X27lQbXkHTUodDJCaqo076DxAGFkSZex9+HLIW/y1+bt4v+k/KnoiqFiEuT
         8LzdYsN8LpMAD6X7Zf95Ey8kkl/jwkMM53OoBweb5A3h7cYRKNIbUmKy3UoDSrYQdD
         9mrKzihq18zQqayVnyyFtWf4+oN+opiRhq3zuUjM=
Date:   Thu, 12 Nov 2020 18:57:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  +
 set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch added
 to -mm tree
Message-ID: <20201113025736.M7M99HOiA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix
has been added to the -mm tree.  Its filename is
     set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/snapshot.c~set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix
+++ a/kernel/power/snapshot.c
@@ -99,7 +99,7 @@ static inline void hibernate_unmap_page(
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page);
+		int ret = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kasan-mm-rename-kasan_poison_kfree-temp-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
secretmem-add-memcg-accounting-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

