Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA30C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355152AbiDZUyx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355149AbiDZUyw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E07F48888
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C188661569
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A38C385A0;
        Tue, 26 Apr 2022 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651006302;
        bh=mEeVn8f+AqTBvJazSxfnkjjbXYrzAAgBTS63cOhVf8Y=;
        h=Date:To:From:Subject:From;
        b=mw7ykJX9DYeUNY+SkDL9557rkxjERgnaV4/7bkZhCLEwGrM6GZPp4LkISdc7oP7kt
         EuJ6hOfZr0qngGK7BSPh/J2/ZpjySbDEOq/kKtm64RtR2i9c1NxaHVsIMmEZkmcqkW
         BhT6aMOHMfhIDYBHFaAPLeUbhGiWX6BpMk/5tIa8=
Date:   Tue, 26 Apr 2022 13:51:41 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, luto@kernel.org,
        keescook@chromium.org, catalin.marinas@arm.com,
        alex.popov@linux.com, mark.rutland@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-entry-use-stackleak_erase_on_task_stack.patch added to -mm tree
Message-Id: <20220426205142.13A38C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: entry: use stackleak_erase_on_task_stack()
has been added to the -mm tree.  Its filename is
     arm64-entry-use-stackleak_erase_on_task_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-entry-use-stackleak_erase_on_task_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-entry-use-stackleak_erase_on_task_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: arm64: entry: use stackleak_erase_on_task_stack()

On arm64 we always call stackleak_erase() on a task stack, and never call
it on another stack.  We can avoid some redundant work by using
stackleak_erase_on_task_stack(), telling the stackleak code that it's
being called on a task stack.

Link: https://lkml.kernel.org/r/20220425115603.781311-9-mark.rutland@arm.com
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/entry.S~arm64-entry-use-stackleak_erase_on_task_stack
+++ a/arch/arm64/kernel/entry.S
@@ -596,7 +596,7 @@ SYM_CODE_START_LOCAL(ret_to_user)
 	ldr	x19, [tsk, #TSK_TI_FLAGS]	// re-check for single-step
 	enable_step_tsk x19, x2
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
-	bl	stackleak_erase
+	bl	stackleak_erase_on_task_stack
 #endif
 	kernel_exit 0
 SYM_CODE_END(ret_to_user)
_

Patches currently in -mm which might be from mark.rutland@arm.com are

arm64-stackleak-fix-current_top_of_stack.patch
stackleak-move-skip_erasing-check-earlier.patch
stackleak-rework-stack-low-bound-handling.patch
stackleak-clarify-variable-names.patch
stackleak-rework-stack-high-bound-handling.patch
stackleak-remove-redundant-check.patch
stackleak-add-on-off-stack-variants.patch
arm64-entry-use-stackleak_erase_on_task_stack.patch

