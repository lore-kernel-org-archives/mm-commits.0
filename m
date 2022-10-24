Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEDDFA373D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiJYAFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiJYAFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFA663C0
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73073615D9
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC014C433D6;
        Mon, 24 Oct 2022 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650125;
        bh=rPCNKo0zxaFIx1suInvA+vIhQyYo0IGCI/a/GAnDdkY=;
        h=Date:To:From:Subject:From;
        b=FBmnrUCMhEGGOoDGDCc9gv/IuD4JixklElsgyCBqfIOxq4OTPzNUk0bAg/zISRceT
         tmQpZ+h1gE3wsEuG9M81rKpVAedNsXLDWnKfr/rwYwlNFV4aFrEw2czdCqXw/4GbHI
         v0gZmFIt4wJL6GdgXdLej0DkZaODBifJojbclRPM=
Date:   Mon, 24 Oct 2022 15:22:05 -0700
To:     mm-commits@vger.kernel.org, youling257@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024222205.CC014C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: asm: make sure __put_user_size() evaluates pointer once
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: x86: asm: make sure __put_user_size() evaluates pointer once
Date: Mon, 24 Oct 2022 23:21:43 +0200

User access macros must ensure their arguments are evaluated only once if
they are used more than once in the macro body.  Adding
instrument_put_user() to __put_user_size() resulted in double evaluation
of the `ptr` argument, which led to correctness issues when performing
e.g.  unsafe_put_user(..., p++, ...).

To fix those issues, evaluate the `ptr` argument of __put_user_size() at
the beginning of the macro.

Link: https://lkml.kernel.org/r/20221024212144.2852069-4-glider@google.com
Fixes: 888f84a6da4d ("x86: asm: instrument usercopy in get_user() and put_user()")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: youling257 <youling257@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/uaccess.h~x86-asm-make-sure-__put_user_size-evaluates-pointer-once
+++ a/arch/x86/include/asm/uaccess.h
@@ -254,24 +254,25 @@ extern void __put_user_nocheck_8(void);
 #define __put_user_size(x, ptr, size, label)				\
 do {									\
 	__typeof__(*(ptr)) __x = (x); /* eval x once */			\
-	__chk_user_ptr(ptr);						\
+	__typeof__(ptr) __ptr = (ptr); /* eval ptr once */		\
+	__chk_user_ptr(__ptr);						\
 	switch (size) {							\
 	case 1:								\
-		__put_user_goto(__x, ptr, "b", "iq", label);		\
+		__put_user_goto(__x, __ptr, "b", "iq", label);		\
 		break;							\
 	case 2:								\
-		__put_user_goto(__x, ptr, "w", "ir", label);		\
+		__put_user_goto(__x, __ptr, "w", "ir", label);		\
 		break;							\
 	case 4:								\
-		__put_user_goto(__x, ptr, "l", "ir", label);		\
+		__put_user_goto(__x, __ptr, "l", "ir", label);		\
 		break;							\
 	case 8:								\
-		__put_user_goto_u64(__x, ptr, label);			\
+		__put_user_goto_u64(__x, __ptr, label);			\
 		break;							\
 	default:							\
 		__put_user_bad();					\
 	}								\
-	instrument_put_user(__x, ptr, size);				\
+	instrument_put_user(__x, __ptr, size);				\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-export-kmsan_copy_page_meta.patch
x86-purgatory-disable-kmsan-instrumentation.patch
kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch
x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch
x86-fortify-kmsan-fix-kmsan-fortify-builds.patch

