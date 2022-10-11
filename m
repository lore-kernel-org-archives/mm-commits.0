Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EF2C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 21:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJKVLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 17:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJKVLq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 17:11:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11F694134
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 14:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E5FCB80EBA
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 21:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35004C433C1;
        Tue, 11 Oct 2022 21:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665522703;
        bh=E92beqt2aT7RU512thSFAx4PEOzggMelo+IVniH9DnQ=;
        h=Date:To:From:Subject:From;
        b=1Nd7Cn/GNkEdDRjEqMVAFK3ey4wD3hJrMYKz+hwSp+YvtiA2TiUhmySAjxwWEozOD
         l11yu+BGSq8p4i4uC3RpV3M+vtve1yAuQu+si2S75pz1QwUSwJp6izdY5ZZd4FdBT4
         vWjVbrju0tcS/PgZ9otRW6irLOQZ3Xb5rNf3wxgM=
Date:   Tue, 11 Oct 2022 14:11:42 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, glider@google.com, andreyknvl@google.com,
        jpoimboe@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-disable-stackleak-plugin-in-report-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20221011211143.35004C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: disable stackleak plugin in report code
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-disable-stackleak-plugin-in-report-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-disable-stackleak-plugin-in-report-code.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: kasan: disable stackleak plugin in report code
Date: Tue, 11 Oct 2022 12:05:48 -0700

kasan_report() has a uaccess critical section which can't have any
instrumentation calls in the middle.  Disable the stackleak plugin for the
report code.

Fixes the following warning:

  vmlinux.o: warning: objtool: kasan_report+0x12: call to stackleak_track_stack() with UACCESS enabled

Link: https://lkml.kernel.org/r/20221011190548.blixlqj6dripitaf@treble
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/Makefile~kasan-disable-stackleak-plugin-in-report-code
+++ a/mm/kasan/Makefile
@@ -27,7 +27,7 @@ CFLAGS_common.o := $(CC_FLAGS_KASAN_RUNT
 CFLAGS_generic.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_init.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_quarantine.o := $(CC_FLAGS_KASAN_RUNTIME)
-CFLAGS_report.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_report.o := $(CC_FLAGS_KASAN_RUNTIME) $(DISABLE_STACKLEAK_PLUGIN)
 CFLAGS_report_generic.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_report_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_report_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
_

Patches currently in -mm which might be from jpoimboe@kernel.org are

kasan-disable-stackleak-plugin-in-report-code.patch

