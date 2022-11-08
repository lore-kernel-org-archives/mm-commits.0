Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB47C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiKHX6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKHX6V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4621860E8C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1284B81CCA
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F3EC433D6;
        Tue,  8 Nov 2022 23:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951897;
        bh=JzMeJxdj54xUzGD0Nxswc+uCzmzWc77RbqKSQQQRayk=;
        h=Date:To:From:Subject:From;
        b=LQ3jEI2gPFAm8GmSrDZXgp4CCl/womkZ4+vvUZDvhOOVWN6d5gto6bmFhdrs5RS+d
         mNpEa2GbGR5Q5e1ZUOulxr+7Cvge3NP1IQh2TsseyfUoddfBKHvllNIPzlPgLv+KDE
         EKvfxkwn1BYBGgZC2s27XhcnFp/9wnS9EEbEZvFM=
Date:   Tue, 08 Nov 2022 15:58:17 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch removed from -mm tree
Message-Id: <20221108235817.95F3EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: core: kmsan_in_runtime() should return true in NMI context
has been removed from the -mm tree.  Its filename was
     kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: core: kmsan_in_runtime() should return true in NMI context
Date: Wed, 2 Nov 2022 12:06:07 +0100

Without that, every call to __msan_poison_alloca() in NMI may end up
allocating memory, which is NMI-unsafe.

Link: https://lkml.kernel.org/r/20221102110611.1085175-1-glider@google.com
Link: https://lore.kernel.org/lkml/20221025221755.3810809-1-glider@google.com/
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmsan/kmsan.h~kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context
+++ a/mm/kmsan/kmsan.h
@@ -124,6 +124,8 @@ static __always_inline bool kmsan_in_run
 {
 	if ((hardirq_count() >> HARDIRQ_SHIFT) > 1)
 		return true;
+	if (in_nmi())
+		return true;
 	return kmsan_get_context()->kmsan_in_runtime;
 }
 
_

Patches currently in -mm which might be from glider@google.com are


