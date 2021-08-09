Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9A7C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CFCE60EDF
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 18:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhHISsv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhHISsv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 14:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC44A60EE7;
        Mon,  9 Aug 2021 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628534910;
        bh=BO4DNoBeObmONGIjRZdPdwijw9SitraPXbZrfhNG/Ac=;
        h=Date:From:To:Subject:From;
        b=1nXbGlIa9zTyGFbxUdznzsYbIO6GKbAHjbAsGcWdZhigynEFgCKTlKsSBcjNc6MQi
         SCfGY8HlE114as/llzLZS/xTRs0hZwXDgguWrk82rv3hrpG8uBu9LU/8NGWsnppEH9
         /fhLbw4/gLtrYDih5M9tQwj2XuTYZr3zi08zUI+Q=
Date:   Mon, 09 Aug 2021 11:48:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        rdunlap@infradead.org
Subject:  + lib-dump_stack-correct-kernel-doc-notation.patch added to
 -mm tree
Message-ID: <20210809184828.ZNzE_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dump_stack: correct kernel-doc notation
has been added to the -mm tree.  Its filename is
     lib-dump_stack-correct-kernel-doc-notation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-dump_stack-correct-kernel-doc-notation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-dump_stack-correct-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/dump_stack: correct kernel-doc notation

Fix kernel-doc warnings in dump_stack.c:

lib/dump_stack.c:97: warning: Function parameter or member 'log_lvl' not described in 'dump_stack_lvl'
lib/dump_stack.c:97: warning: expecting prototype for dump_stack(). Prototype was for dump_stack_lvl() instead

Link: https://lkml.kernel.org/r/20210809051643.17567-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c~lib-dump_stack-correct-kernel-doc-notation
+++ a/lib/dump_stack.c
@@ -89,7 +89,8 @@ static void __dump_stack(const char *log
 }
 
 /**
- * dump_stack - dump the current task information and its stack trace
+ * dump_stack_lvl - dump the current task information and its stack trace
+ * @log_lvl: log level
  *
  * Architectures can override this implementation by implementing its own.
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-dump_stack-correct-kernel-doc-notation.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

