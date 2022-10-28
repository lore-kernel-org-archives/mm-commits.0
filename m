Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FE9FA374C
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJ1VHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJ1VHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C196C24A56F
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F7362A57
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2033C433D6;
        Fri, 28 Oct 2022 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991245;
        bh=zJ1cJDWptb8Dwhm8Wc5kHgUITay/9KgVB991rfa9l5M=;
        h=Date:To:From:Subject:From;
        b=sFA42ptGkFrMQsNtub4SQso94XzT8i2aLd8XX/M/iq3JEsENoNuqbEG0FvDiDaXx1
         b+36HbINmBNAfekPxIjRiCD1ZXKcevx9lElUirtPaPEslJT+kaGHkdbTmkDDLOjJNU
         Wk3cXKPuglLgHso0TH8C95oHdHwCmz2pcBCucmcU=
Date:   Fri, 28 Oct 2022 14:07:24 -0700
To:     mm-commits@vger.kernel.org, youling257@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch removed from -mm tree
Message-Id: <20221028210725.A2033C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: asm: make sure __put_user_size() evaluates pointer once
has been removed from the -mm tree.  Its filename was
     x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


