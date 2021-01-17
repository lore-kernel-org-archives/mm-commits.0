Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7A0C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1879B207AE
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbhAQVvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbhAQVvq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:51:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209CC207AE;
        Sun, 17 Jan 2021 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610920265;
        bh=a2eCWG9VX2rcRjav4/DddozREKbQyGBXTz17FvU/LHg=;
        h=Date:From:To:Subject:From;
        b=Tt7YpWVwHgQXsCYkphGduznmoWDBslK/MYUtHlZIESQbdRZprUGTex2q2Wfwuh+sQ
         1Oq+KOvuckHRlrf0cYJ3FCHG8KJJxArbTeLaqUGtQCziRZ+mJYVDtNRMG7rKHs6h02
         xas5R3o86qNZb5xIdGakQ8eEMrtxcdxJkCUzm74c=
Date:   Sun, 17 Jan 2021 13:51:04 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, lkp@intel.com, mm-commits@vger.kernel.org
Subject:  + bdi-use-might_alloc-fix.patch added to -mm tree
Message-ID: <20210117215104.4AmJm_BCs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bdi-use-might_alloc-fix
has been added to the -mm tree.  Its filename is
     bdi-use-might_alloc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bdi-use-might_alloc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bdi-use-might_alloc-fix.patch

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
Subject: bdi-use-might_alloc-fix

include linux/sched/mm.h

Reported-by: kernel test robot <lkp@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/backing-dev.c~bdi-use-might_alloc-fix
+++ a/mm/backing-dev.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/mm.h>
+#include <linux/sched/mm.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
bdi-use-might_alloc-fix.patch

