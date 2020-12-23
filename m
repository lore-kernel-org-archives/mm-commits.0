Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4A3C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F937223E4
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgLWS2a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgLWS23 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:28:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0584E22286;
        Wed, 23 Dec 2020 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748069;
        bh=e9jj0jfTnU3EmKFP65JF+RY8LAFIUa664K0EczxdqTE=;
        h=Date:From:To:Subject:From;
        b=WLigiOOU2WCCIlO9eLfMWinhryySTO4rKz8k1q18QqAL1fL8nNHtToyqXwod4FmPd
         sLHEXACaRCQd1gL8wsH/dPIA8NrZI/hkphAgYVJvcm/vbwc/9VTJgG9Bx85D42nbcH
         WWSSzQQ4eBuDPLdp04QnBU89NAGTALoJ5vpjS4Aw=
Date:   Wed, 23 Dec 2020 10:27:48 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201223182748.7ooumzT5d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 ----
 kernel/dma/map_benchmark.c        |    3 ---
 2 files changed, 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~linux-next-git-rejects
+++ a/Documentation/dev-tools/kasan.rst
@@ -22,11 +22,7 @@ out-of-bounds accesses for global variab
 Tag-based KASAN is only supported in Clang.
 
 Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
-<<<<<<< HEAD
 and riscv architectures, and tag-based KASAN modes are supported only for arm64.
-=======
-and riscv architectures, and tag-based KASAN is supported only for arm64.
->>>>>>> linux-next/akpm-base
 
 Usage
 -----
--- a/kernel/dma/map_benchmark.c~linux-next-git-rejects
+++ a/kernel/dma/map_benchmark.c
@@ -214,15 +214,12 @@ static long map_benchmark_ioctl(struct f
 			return -EINVAL;
 		}
 
-<<<<<<< HEAD
-=======
 		if (map->bparam.dma_bits < 20 ||
 		    map->bparam.dma_bits > 64) {
 			pr_err("invalid dma_bits\n");
 			return -EINVAL;
 		}
 
->>>>>>> linux-next/akpm-base
 		if (map->bparam.node != NUMA_NO_NODE &&
 		    !node_possible(map->bparam.node)) {
 			pr_err("invalid numa node\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

