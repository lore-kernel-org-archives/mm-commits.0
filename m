Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55494C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1721023428
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgLPRJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgLPRJz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:55 -0500
Date:   Wed, 16 Dec 2020 09:09:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138573;
        bh=XBkkl0elD3Tp5MqtJBzhJWt+N0Ke2GheinoP/BlRNXs=;
        h=From:To:Subject:From;
        b=fNK9LOgPvVatExhQoGPdfFUUbXoL4BYlZDauJLawTg4JwFXawAi5tHOciXzCcltCS
         QF4wmEQxB7+EQrbYR0iDdlOrF9KRXv7a6MywUVf77q8sijvcku9PLHqwvIPCMeGN7B
         /2F6U9NJPvcmC/g16kcZcfrWRkcRxMo9vsihJ12k=
From:   akpm@linux-foundation.org
To:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        laniel_francis@privacyrequired.com, mm-commits@vger.kernel.org
Subject:  [merged] correct-wrong-filenames-in-comment.patch removed
 from -mm tree
Message-ID: <20201216170933._vCXifEq8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lkdtm/lkdtm.h: correct wrong filenames in comment
has been removed from the -mm tree.  Its filename was
     correct-wrong-filenames-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Francis Laniel <laniel_francis@privacyrequired.com>
Subject: drivers/misc/lkdtm/lkdtm.h: correct wrong filenames in comment

In lkdtm.h, files targeted in comments are named "lkdtm_file.c" while
there are named "file.c" in directory.

Link: https://lkml.kernel.org/r/20201122162451.27551-6-laniel_francis@privacyrequired.com
Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm/lkdtm.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/misc/lkdtm/lkdtm.h~correct-wrong-filenames-in-comment
+++ a/drivers/misc/lkdtm/lkdtm.h
@@ -6,7 +6,7 @@
 
 #include <linux/kernel.h>
 
-/* lkdtm_bugs.c */
+/* bugs.c */
 void __init lkdtm_bugs_init(int *recur_param);
 void lkdtm_PANIC(void);
 void lkdtm_BUG(void);
@@ -35,7 +35,7 @@ void lkdtm_CORRUPT_PAC(void);
 void lkdtm_FORTIFY_OBJECT(void);
 void lkdtm_FORTIFY_SUBOBJECT(void);
 
-/* lkdtm_heap.c */
+/* heap.c */
 void __init lkdtm_heap_init(void);
 void __exit lkdtm_heap_exit(void);
 void lkdtm_OVERWRITE_ALLOCATION(void);
@@ -47,7 +47,7 @@ void lkdtm_SLAB_FREE_DOUBLE(void);
 void lkdtm_SLAB_FREE_CROSS(void);
 void lkdtm_SLAB_FREE_PAGE(void);
 
-/* lkdtm_perms.c */
+/* perms.c */
 void __init lkdtm_perms_init(void);
 void lkdtm_WRITE_RO(void);
 void lkdtm_WRITE_RO_AFTER_INIT(void);
@@ -62,7 +62,7 @@ void lkdtm_EXEC_NULL(void);
 void lkdtm_ACCESS_USERSPACE(void);
 void lkdtm_ACCESS_NULL(void);
 
-/* lkdtm_refcount.c */
+/* refcount.c */
 void lkdtm_REFCOUNT_INC_OVERFLOW(void);
 void lkdtm_REFCOUNT_ADD_OVERFLOW(void);
 void lkdtm_REFCOUNT_INC_NOT_ZERO_OVERFLOW(void);
@@ -83,10 +83,10 @@ void lkdtm_REFCOUNT_SUB_AND_TEST_SATURAT
 void lkdtm_REFCOUNT_TIMING(void);
 void lkdtm_ATOMIC_TIMING(void);
 
-/* lkdtm_rodata.c */
+/* rodata.c */
 void lkdtm_rodata_do_nothing(void);
 
-/* lkdtm_usercopy.c */
+/* usercopy.c */
 void __init lkdtm_usercopy_init(void);
 void __exit lkdtm_usercopy_exit(void);
 void lkdtm_USERCOPY_HEAP_SIZE_TO(void);
@@ -98,7 +98,7 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(voi
 void lkdtm_USERCOPY_STACK_BEYOND(void);
 void lkdtm_USERCOPY_KERNEL(void);
 
-/* lkdtm_stackleak.c */
+/* stackleak.c */
 void lkdtm_STACKLEAK_ERASING(void);
 
 /* cfi.c */
_

Patches currently in -mm which might be from laniel_francis@privacyrequired.com are


