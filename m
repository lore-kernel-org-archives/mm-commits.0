Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058A9C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B688264E90
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhBXTJH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235950AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7A6664F11;
        Wed, 24 Feb 2021 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193307;
        bh=hDMe23ut0e5xCxYRp/hBHzM6u713X/cTXHNaHDSkdBM=;
        h=Date:From:To:Subject:From;
        b=EGXhr7iUtWYQ45Iqe4cbDVQ0uLmYLtBu4yqzg7ytptD0ck5NTG35DeqlbkkuJwhNv
         plX55WqTIgW5TBe0W87W65cYNYApx8/SytfzwOg8bDVRKR+deWJu6295ktPMB4ToUV
         O5uv5cNAlADsG2FPJydzrWAevREhEGvJuLFezilo=
Date:   Wed, 24 Feb 2021 11:01:46 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  [folded-merged]
 kasan-add-match-all-tag-tests-fix-fix.patch removed from -mm tree
Message-ID: <20210224190146.zjgRfzPik%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-add-match-all-tag-tests-fix-fix
has been removed from the -mm tree.  Its filename was
     kasan-add-match-all-tag-tests-fix-fix.patch

This patch was dropped because it was folded into kasan-add-match-all-tag-tests.patch

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

kasan-add-match-all-tag-tests.patch
mm.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

