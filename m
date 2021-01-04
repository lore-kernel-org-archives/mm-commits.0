Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9470FC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 23:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A6BC2253D
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 23:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhADXee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbhADXee (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 18:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3BFD22482;
        Mon,  4 Jan 2021 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609803233;
        bh=6XhkNRWlBSvIBzH1MsbqQx7gdhZtrTbQuvB0yuUPVCA=;
        h=Date:From:To:Subject:From;
        b=m7UebrjPZ4PLt0XoERXG095OTpoiJ5OcetckZ1DSDegx7+90z02ucVX53z5tjlNEp
         KXZLcILnLWsEQSFR4FfZNux5E38W/+xp9tA+KKOh08nydL24vZdz/+syn3ivfDTrO8
         IXo+9vURJxLpVQ79dBF4wuQ0kOksE7lOfteIxIeY=
Date:   Mon, 04 Jan 2021 15:33:52 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, elver@google.com,
        georgepope@android.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject:  +
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
 added to -mm tree
Message-ID: <20210104233352.5Jrs2Qnnt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix
has been added to the -mm tree.  Its filename is
     ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch

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
ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

