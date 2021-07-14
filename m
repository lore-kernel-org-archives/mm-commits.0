Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF34EC12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D89613D0
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhGNXOG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXOG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 19:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF66613CA;
        Wed, 14 Jul 2021 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626304273;
        bh=ArPfCT/GEKj+IGLPj9RzvBZMjW43w6M7RXcDIOrBaS4=;
        h=Date:From:To:Subject:From;
        b=xzBqD96KtwF6XNoprxQd3W+eyPpzr3dwsvDDhL1lGKkBHtIWO/enyc85jHJPEF8YA
         vTEyfgWX6qSeKJLAAzssYePKfQlw0/5BQiTCyJBNYfV8pU1KMuAMoidJgeMFjuFOcy
         nUxHNkoJC2B9FPwfsuGveDazWCrUCUZs9xAlu7L0=
Date:   Wed, 14 Jul 2021 16:11:12 -0700
From:   akpm@linux-foundation.org
To:     bowsingbetee@pm.me, glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, mmorfikov@gmail.com, slyfox@gentoo.org,
        stable@vger.kernelo.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch
 added to -mm tree
Message-ID: <20210714231112.yFqBWw-BO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-page_poison%3D1-init_on_alloc_default_on-interaction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-page_poison%3D1-init_on_alloc_default_on-interaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction

To reproduce the failure we need the following system:
  - kernel command: page_poison=1 init_on_free=0 init_on_alloc=0
  - kernel config:
    * CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
    * CONFIG_INIT_ON_FREE_DEFAULT_ON=y
    * CONFIG_PAGE_POISONING=y

    0000000085629bdd: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    0000000022861832: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00000000c597f5b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    CPU: 11 PID: 15195 Comm: bash Kdump: loaded Tainted: G     U     O      5.13.1-gentoo-x86_64 #1
    Hardware name: System manufacturer System Product Name/PRIME Z370-A, BIOS 2801 01/13/2021
    Call Trace:
     dump_stack+0x64/0x7c
     __kernel_unpoison_pages.cold+0x48/0x84
     post_alloc_hook+0x60/0xa0
     get_page_from_freelist+0xdb8/0x1000
     __alloc_pages+0x163/0x2b0
     __get_free_pages+0xc/0x30
     pgd_alloc+0x2e/0x1a0
     ? dup_mm+0x37/0x4f0
     mm_init+0x185/0x270
     dup_mm+0x6b/0x4f0
     ? __lock_task_sighand+0x35/0x70
     copy_process+0x190d/0x1b10
     kernel_clone+0xba/0x3b0
     __do_sys_clone+0x8f/0xb0
     do_syscall_64+0x68/0x80
     ? do_syscall_64+0x11/0x80
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Before the 51cba1eb ("init_on_alloc: Optimize static branches")
init_on_alloc never enabled static branch by default.  It could only be
enabed explicitly by init_mem_debugging_and_hardening().

But after the 51cba1eb static branch could already be enabled by default. 
There was no code to ever disable it.  That caused page_poison=1 /
init_on_free=1 conflict.

This change extends init_mem_debugging_and_hardening() to also disable
static branch disabling.

Link: https://lkml.kernel.org/r/20210714031935.4094114-1-keescook@chromium.org
Link: https://lore.kernel.org/r/20210712215816.1512739-1-slyfox@gentoo.org
Fixes: 51cba1ebc60d ("init_on_alloc: Optimize static branches")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Kees Cook <keescook@chromium.org>
Reported-by: Mikhail Morfikov <mmorfikov@gmail.com>
Reported-by: <bowsingbetee@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernelo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction
+++ a/mm/page_alloc.c
@@ -840,21 +840,24 @@ void init_mem_debugging_and_hardening(vo
 	}
 #endif
 
-	if (_init_on_alloc_enabled_early) {
-		if (page_poisoning_requested)
-			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-				"will take precedence over init_on_alloc\n");
-		else
-			static_branch_enable(&init_on_alloc);
-	}
-	if (_init_on_free_enabled_early) {
-		if (page_poisoning_requested)
-			pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
-				"will take precedence over init_on_free\n");
-		else
-			static_branch_enable(&init_on_free);
+	if ((_init_on_alloc_enabled_early || _init_on_free_enabled_early) &&
+	    page_poisoning_requested) {
+		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, "
+			"will take precedence over init_on_alloc and init_on_free\n");
+		_init_on_alloc_enabled_early = false;
+		_init_on_free_enabled_early = false;
 	}
 
+	if (_init_on_alloc_enabled_early)
+		static_branch_enable(&init_on_alloc);
+	else
+		static_branch_disable(&init_on_alloc);
+
+	if (_init_on_free_enabled_early)
+		static_branch_enable(&init_on_free);
+	else
+		static_branch_disable(&init_on_free);
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	if (!debug_pagealloc_enabled())
 		return;
_

Patches currently in -mm which might be from slyfox@gentoo.org are

mm-page_alloc-fix-page_poison=1-init_on_alloc_default_on-interaction.patch

