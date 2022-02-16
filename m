Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F306BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 20:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiBPUgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:36:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiBPUgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 15:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91492558F
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 12:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EB2F61A1B
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 20:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C57C340E8;
        Wed, 16 Feb 2022 20:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645043788;
        bh=DCASBnqh2JNDlaN+zYztyO6o+viYKAvwDe8UxBGousY=;
        h=Date:To:From:Subject:From;
        b=utFkdYY+3T692I2WtZZPGxbqsZljfvWMqOVxwMf1oQyV8ZwnR8v7YeAavQQbxd/fA
         ut87RfyVEcOU2UK1RB86K6WitkH2MTY6qDvndfRmHVBSIEIFQc484pZSH45GGWBxGH
         Cp50iYHSD6+8R6xjLANXRI4kydBMYJzpuRGSNZn4=
Date:   Wed, 16 Feb 2022 12:36:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.anjum@collabora.com, jpoimboe@redhat.com,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + usercopy-check-valid-lifetime-via-stack-depth.patch added to -mm tree
Message-Id: <20220216203628.B1C57C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: usercopy: check valid lifetime via stack depth
has been added to the -mm tree.  Its filename is
     usercopy-check-valid-lifetime-via-stack-depth.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/usercopy-check-valid-lifetime-via-stack-depth.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/usercopy-check-valid-lifetime-via-stack-depth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: usercopy: check valid lifetime via stack depth

Under CONFIG_HARDENED_USERCOPY=y, when exact stack frame boundary checking
is not available (i.e.  everything except x86 with FRAME_POINTER), check a
stack object as being at least "current depth valid", in the sense that
any object within the stack region but not between start-of-stack and
current_stack_pointer should be considered unavailable (i.e.  its lifetime
is from a call no longer present on the stack).

Additionally report usercopy bounds checking failures with an offset from
current_stack_pointer, which may assist with diagnosing failures.

The LKDTM USERCOPY_STACK_FRAME_TO and USERCOPY_STACK_FRAME_FROM tests
(once slightly adjusted in a separate patch) will pass again with this
fixed.

Link: https://lkml.kernel.org/r/20220216201449.2087956-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/usercopy.c~usercopy-check-valid-lifetime-via-stack-depth
+++ a/mm/usercopy.c
@@ -29,13 +29,20 @@
  * Returns:
  *	NOT_STACK: not at all on the stack
  *	GOOD_FRAME: fully within a valid stack frame
- *	GOOD_STACK: fully on the stack (when can't do frame-checking)
+ *	GOOD_STACK: within the current stack (when can't frame-check exactly)
  *	BAD_STACK: error condition (invalid stack position or bad stack frame)
  */
 static noinline int check_stack_object(const void *obj, unsigned long len)
 {
 	const void * const stack = task_stack_page(current);
 	const void * const stackend = stack + THREAD_SIZE;
+#ifndef CONFIG_STACK_GROWSUP
+	const void * const high = stackend;
+	const void * const low = (void *)current_stack_pointer;
+#else
+	const void * const high = (void *)current_stack_pointer;
+	const void * const low = stack;
+#endif
 	int ret;
 
 	/* Object is not on the stack at all. */
@@ -55,6 +62,12 @@ static noinline int check_stack_object(c
 	if (ret)
 		return ret;
 
+	/*
+	 * Reject: object not within current stack depth.
+	 */
+	if (obj < low || high < obj + len)
+		return BAD_STACK;
+
 	return GOOD_STACK;
 }
 
@@ -269,7 +282,13 @@ void __check_object_size(const void *ptr
 		 */
 		return;
 	default:
-		usercopy_abort("process stack", NULL, to_user, 0, n);
+		usercopy_abort("process stack", NULL, to_user,
+#ifndef CONFIG_STACK_GROWSUP
+				(void *)current_stack_pointer - ptr,
+#else
+				ptr - (void *)current_stack_pointer,
+#endif
+				n);
 	}
 
 	/* Check for bad heap object. */
_

Patches currently in -mm which might be from keescook@chromium.org are

usercopy-check-valid-lifetime-via-stack-depth.patch
kconfigdebug-make-debug_info-selectable-from-a-choice.patch
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
exec-force-single-empty-string-when-argv-is-empty.patch
exec-force-single-empty-string-when-argv-is-empty-fix.patch
selftests-exec-test-for-empty-string-on-null-argv.patch
selftests-kselftest-framework-provide-finished-helper.patch

