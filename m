Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B106FC433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F3B230FC
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbhAGAfI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAGAfH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:35:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0A5230F9;
        Thu,  7 Jan 2021 00:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609979667;
        bh=PfdKj6jXN1cg5kSkLww4InMet6O4TvNsIuESzQ8dX6E=;
        h=Date:From:To:Subject:From;
        b=0pBNjw3REF5mKqqrICXcSOHWmw8s9+JozaBG8GLNnIHAI/5MfiZ/FC4hwkubyazHk
         UjcwCyegD0Cf62o/hdz/LG3ornl28+LMM+k/UyXO+OabZlGYiX5a/k3gzfbKa30gJZ
         z/7EH7QUvQX4lf4cKnjJYdbmnQ4zMmHB575RysEM=
Date:   Wed, 06 Jan 2021 16:34:26 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, elver@google.com,
        georgepope@android.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
 removed from -mm tree
Message-ID: <20210107003426.Bqzd_O7Lf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
has been removed from the -mm tree.  Its filename was
     ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch

This patch was dropped because it was folded into ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix

fix comment typo, per Nathan

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: George Popescu <georgepope@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
+++ a/lib/Kconfig.ubsan
@@ -122,7 +122,7 @@ config UBSAN_SIGNED_OVERFLOW
 
 config UBSAN_UNSIGNED_OVERFLOW
 	bool "Perform checking for unsigned arithmetic overflow"
-	# clang hugely expands stack usage with -fsanitize=object-size
+	# clang hugely expands stack usage with -fsanitize=unsigned-integer-overflow
 	depends on !CC_IS_CLANG
 	depends on $(cc-option,-fsanitize=unsigned-integer-overflow)
 	help
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

