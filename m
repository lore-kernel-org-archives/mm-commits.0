Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005F9C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B693923332
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAGADm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbhAGADm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:03:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD9D23118;
        Thu,  7 Jan 2021 00:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609977781;
        bh=Fxj6H5+buiP6L0MXAS7vYM7kNHP97cCRsCdXVnV6Hb0=;
        h=Date:From:To:Subject:From;
        b=TBeD9RI8sNY/0Thg8h4ZDPnGK1hfFCLKV5Krm9/vrYBwOS1Yx+IdPzemspg9QYGO1
         sbSBQ77ZFfy3+HytXBlFX2AaBVMMixID5boIpJpYp/HFeo9lBH3144AZpUsCyR3Jbz
         uHWK8AKQ0IVEe12OmSmScttP5fvNi2mXRHn8rLCU=
Date:   Wed, 06 Jan 2021 16:02:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        lkp@intel.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch added to -mm
 tree
Message-ID: <20210107000259.RhsTzfxwh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix
has been added to the -mm tree.  Its filename is
     kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch

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
Subject: kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix

fix kasan_check_byte() return

Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/kasan.h~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix
+++ a/include/linux/kasan.h
@@ -311,7 +311,10 @@ static inline void *kasan_krealloc(const
 	return (void *)object;
 }
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
-static inline bool kasan_check_byte(const void *address, unsigned long ip) {}
+static inline bool kasan_check_byte(const void *address, unsigned long ip)
+{
+	return true;
+}
 
 #endif /* CONFIG_KASAN */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
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

