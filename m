Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396BFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbiDAA05 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbiDAA0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:26:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355924CED9
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40B8CB822B3
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE939C340F0;
        Fri,  1 Apr 2022 00:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772700;
        bh=acq3UYZvB+nL4B8NDWmqtwF50iaTwgfYwaGKco2eaDs=;
        h=Date:To:From:Subject:From;
        b=S0O0cmOOKePesvX8SYvKSinJOKZrpUbZE0GuHl89TQU14+5Ny9o9dBKTWSV/AtCzb
         C58FfJXXv7GXORha5+aoEp0l2AhdpIgc0IDed41XL6H1Ob8y/9uzPJF3Jh3DnEQ0jP
         9S4fX84rC3u5sF4ypUbsOjNWWI27g8MrxDDQYxoY=
Date:   Thu, 31 Mar 2022 17:24:59 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, sfr@canb.auug.org.au,
        samitolvanen@google.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, fmayer@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kasan-use-stack_trace_save_shadow.patch removed from -mm tree
Message-Id: <20220401002459.EE939C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use stack_trace_save_shadow
has been removed from the -mm tree.  Its filename was
     kasan-use-stack_trace_save_shadow.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use stack_trace_save_shadow

Now that stack_trace_save_shadow() is implemented by arm64, use it
whenever CONFIG_HAVE_SHADOW_STACKTRACE is enabled.  This improves the boot
time of a defconfig build by ~30% for all KASAN modes.

Link: https://lkml.kernel.org/r/7027b9b6b0cae2921ff65739582ae499bf61470c.1648049113.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Florian Mayer <fmayer@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-use-stack_trace_save_shadow
+++ a/mm/kasan/common.c
@@ -33,10 +33,13 @@
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
-	unsigned int nr_entries;
+	unsigned int size;
 
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
+	if (IS_ENABLED(CONFIG_HAVE_SHADOW_STACKTRACE))
+		size = stack_trace_save_shadow(entries, ARRAY_SIZE(entries), 0);
+	else
+		size = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	return __stack_depot_save(entries, size, flags, can_alloc);
 }
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
_

Patches currently in -mm which might be from andreyknvl@google.com are

mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch

