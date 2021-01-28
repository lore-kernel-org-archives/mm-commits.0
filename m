Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62904C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 01:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4645264DDA
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 01:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhA1BCQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 20:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhA1A6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:58:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B40964DD0;
        Thu, 28 Jan 2021 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611795473;
        bh=p5BfKirv1cfkSPN7dG3e1Ug6MO2mT4CjYeXSchtXicU=;
        h=Date:From:To:Subject:From;
        b=Cci4D3IMmV8aRMG3BL468dxEl4k+zByP8gna7oNT8If3ks8TEU0C411joYR5Th9W4
         D3mtQHqWboQfh8uSTzZnw+2JIymz4xpDn9yPFltdrxyLiuWloDj9P5FrUu6utvQgS4
         J/H/h/wtLsyJ9ltjUVTVONJnpQ3+IFj1RJW+UPg8=
Date:   Wed, 27 Jan 2021 16:57:52 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, glider@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vinmenon@codeaurora.org,
        vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  +
 lib-stackdepot-add-support-to-disable-stack-depot-fix.patch added to -mm
 tree
Message-ID: <20210128005752.PW80Sl_Bb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-support-to-disable-stack-depot-fix
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-disable-stack-depot-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-disable-stack-depot-fix.patch

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
Subject: lib-stackdepot-add-support-to-disable-stack-depot-fix

fix CONFIG_STACKDEPOT=n build

main.c:(.init.text+0x4c1): undefined reference to `stack_depot_init'

Cc: Alexander Potapenko <glider@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/stackdepot.h~lib-stackdepot-add-support-to-disable-stack-depot-fix
+++ a/include/linux/stackdepot.h
@@ -21,5 +21,13 @@ unsigned int stack_depot_fetch(depot_sta
 
 unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
 
+#ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
+#else
+static inline int stack_depot_init(void)
+{
+	return 0;
+}
+#endif	/* CONFIG_STACKDEPOT */
+
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

