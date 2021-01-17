Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C7FC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42220222B3
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbhAQVe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729350AbhAQVey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:34:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B668224B1;
        Sun, 17 Jan 2021 21:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919253;
        bh=B2o54580ShmMulXQTuGgfZC/c5OrsagUg2sgagHSnF0=;
        h=Date:From:To:Subject:From;
        b=rXyu4Bgg0+Ez94YUIS2at3qCsyYeaAu1we5Y7cS/W/zWJWt9erIINE//l0Hni161d
         sJwC8zUGkb0do8Ot8EHWIuPxhRCtuiEBBV0fPFNJOcIy2O9TsNvUATwbOZizUpYuZA
         GyD4zyEwX/Ueajic/wXJXWprGpl/8hsfYZCx3rMo=
Date:   Sun, 17 Jan 2021 13:34:12 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        f.fainelli@gmail.com, mm-commits@vger.kernel.org
Subject:  + initramfs-panic-with-memory-information-fix.patch added
 to -mm tree
Message-ID: <20210117213412.ajXkvoKyV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs-panic-with-memory-information-fix
has been added to the -mm tree.  Its filename is
     initramfs-panic-with-memory-information-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-panic-with-memory-information-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-panic-with-memory-information-fix.patch

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
Subject: initramfs-panic-with-memory-information-fix

replace macro with C function

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barret Rhoden <brho@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/init/initramfs.c~initramfs-panic-with-memory-information-fix
+++ a/init/initramfs.c
@@ -46,9 +46,14 @@ static void __init error(char *x)
 		message = x;
 }
 
-#define panic_show_mem(...) {	\
-	show_mem(0, NULL);	\
-	panic(__VA_ARGS__);	\
+static void panic_show_mem(const char *fmt, ...)
+{
+	va_list args;
+
+	show_mem(0, NULL);
+	va_start(args, fmt);
+	panic(fmt, args);
+	va_end(args);
 }
 
 /* link hash */
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

