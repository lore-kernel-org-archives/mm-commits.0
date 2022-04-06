Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0A9C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiDFVAD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiDFU7y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:59:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567DB98F5F
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE219B8252B
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF07C385A1;
        Wed,  6 Apr 2022 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649273160;
        bh=ZxDmMeQZAQ8PWC08h89ZEnU/0VvKlup7WvKNxdlPD9I=;
        h=Date:To:From:Subject:From;
        b=p2uS+A4tm+nq0tyaS9RoAtLAJLbgODR3zQpLPVuzAz5aURk5/9ay6f8+dIGxNzNTL
         0ItMfxYoGIrm8Z6xAY3Z3HHQ6Foa6rcuCMa5Htep+Y5mxmzVEzK5007jOTnARNxni5
         lMu6Ap5pbbaDefWHOdT6Jnuw1i7fxyPqe/E4Z5o4=
Date:   Wed, 06 Apr 2022 12:25:59 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ptrace-fix-wrong-comment-of-pt_dtrace.patch added to -mm tree
Message-Id: <20220406192600.5DF07C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: fix wrong comment of PT_DTRACE
has been added to the -mm tree.  Its filename is
     ptrace-fix-wrong-comment-of-pt_dtrace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ptrace-fix-wrong-comment-of-pt_dtrace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ptrace-fix-wrong-comment-of-pt_dtrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: ptrace: fix wrong comment of PT_DTRACE

PT_DTRACE is only used on um now, fix the wrong comment.

Link: https://lkml.kernel.org/r/1649240981-11024-3-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ptrace.h~ptrace-fix-wrong-comment-of-pt_dtrace
+++ a/include/linux/ptrace.h
@@ -30,7 +30,7 @@ extern int ptrace_access_vm(struct task_
 
 #define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
-#define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
+#define PT_DTRACE	0x00000002	/* delayed trace (used on um) */
 
 #define PT_OPT_FLAG_SHIFT	3
 /* PT_TRACE_* event enable flags */
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch
ptrace-fix-wrong-comment-of-pt_dtrace.patch
maintainers-remove-redundant-file-of-ptrace-support-entry.patch

