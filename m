Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3105BC4742C
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A3D207BB
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 23:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5bgUL2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbgKJX3a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 18:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgKJX33 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 18:29:29 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017DC20781;
        Tue, 10 Nov 2020 23:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050968;
        bh=/jy+YiQdqhFcJDBieZhGSWHkwZYcgEs4ptf9cU76V6I=;
        h=Date:From:To:Subject:From;
        b=Q5bgUL2iLSe56p0pBaYcN9B/75XtcyrxoPn0xsSXzMem2kaDQEiOC5AhJbTvyjZnm
         LRGvec9fSD9/1nWWmOoAsFOkhaqGCFPe8AlqmQUpvmhNCKY+Lewk0eyEEodcIHHQmT
         62ErZH6/RbBY07j8Gyfl2tCdNzFfoinU+aSW6TZg=
Date:   Tue, 10 Nov 2020 15:29:27 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-mm-check-kasan_enabled-in-annotations-fix.patch
 added to -mm tree
Message-ID: <20201110232927.c9K4dtWFW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-mm-check-kasan_enabled-in-annotations-fix
has been added to the -mm tree.  Its filename is
     kasan-mm-check-kasan_enabled-in-annotations-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-check-kasan_enabled-in-annotations-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-check-kasan_enabled-in-annotations-fix.patch

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
Subject: kasan-mm-check-kasan_enabled-in-annotations-fix

build fix: add kasan_enabled() return type

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

 include/linux/kasan.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-check-kasan_enabled-in-annotations-fix
+++ a/include/linux/kasan.h
@@ -82,12 +82,12 @@ struct kasan_cache {
 
 #ifdef CONFIG_KASAN_HW_TAGS
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
-static inline kasan_enabled(void)
+static inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
 #else
-static inline kasan_enabled(void)
+static inline bool kasan_enabled(void)
 {
 	return true;
 }
@@ -236,7 +236,7 @@ void kasan_restore_multi_shot(bool enabl
 
 #else /* CONFIG_KASAN */
 
-static inline kasan_enabled(void)
+static inline bool kasan_enabled(void)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

