Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8430FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5572764DD1
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 23:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhA0XZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhA0W4Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 17:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BF264DA1;
        Wed, 27 Jan 2021 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611787543;
        bh=zdHFaF48/1G5G3egfuhj1YrK5YcPQg55oPZ5ol4Qrmw=;
        h=Date:From:To:Subject:From;
        b=hNDvXskPLlpANvAe7tOzI1ROfOTNThTliqa4N2EQvCsnQ7/Phe7ydTdyzqaC19nEn
         v8VVDFEr/cOdJ6Q3xFM6DtpUZgzVBPq3oeGyse0iC4b88sUlQhTnZALXek/sKfREHW
         RH5En17SauD9ZSf+i9s4NnOEk4u0CQor7xhRt8yU=
Date:   Wed, 27 Jan 2021 14:45:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  + kasan-add-match-all-tag-tests-fix-fix.patch added to
 -mm tree
Message-ID: <20210127224542.XT7geWS05%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-add-match-all-tag-tests-fix-fix
has been added to the -mm tree.  Its filename is
     kasan-add-match-all-tag-tests-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-match-all-tag-tests-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-match-all-tag-tests-fix-fix.patch

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
Subject: kasan-add-match-all-tag-tests-fix-fix

s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/, per Andrey

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/shadow.c~kasan-add-match-all-tag-tests-fix-fix
+++ a/mm/kasan/shadow.c
@@ -89,7 +89,7 @@ void kasan_poison(const void *address, s
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
-EXPORT_SYMBOL_GPL(kasan_poison);
+EXPORT_SYMBOL(kasan_poison);
 
 void kasan_unpoison(const void *address, size_t size)
 {
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
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

