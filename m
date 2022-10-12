Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C04C4167E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 02:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJLCGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 22:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJLCGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 22:06:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C955A50F2
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 19:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BB8761351
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 02:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8431C433D6;
        Wed, 12 Oct 2022 02:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665540369;
        bh=Xez8xp5d7hgPU2WcPf+KpTTY7x/XR2WEiFFg4xveKPM=;
        h=Date:To:From:Subject:From;
        b=HBGA0WIE40EZWZQdF3c6lmOoV+DyfEPqSUO1JuavqoeXm03ImmNLAky7WtLU3DP3B
         QL/mCkU7LHgISeDuuxIYoy0rwhtszffBoAhRvg4EZSp0sM+YObWsWK2w+5CZUzxPq9
         Vssi4ebUVlqlSxyv0Pbfg7Zx3VJmV/+0599twl/0=
Date:   Tue, 11 Oct 2022 19:06:08 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, glider@google.com, andreyknvl@google.com,
        jpoimboe@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-disable-stackleak-plugin-in-report-code.patch removed from -mm tree
Message-Id: <20221012020608.E8431C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: disable stackleak plugin in report code
has been removed from the -mm tree.  Its filename was
     kasan-disable-stackleak-plugin-in-report-code.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


