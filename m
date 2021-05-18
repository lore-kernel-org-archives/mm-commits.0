Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA646C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82FD361353
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhERXh5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 19:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhERXh5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 19:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F7BB60FE6;
        Tue, 18 May 2021 23:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621380998;
        bh=QC1AkngoHU4LuQlZYdyq+3Mm5ONtn8/qZqoqQDFJg0c=;
        h=Date:From:To:Subject:From;
        b=t8wyueiOTGcZcLLNi/9+itExj4mfsxCvZSEP7yxSNORNgl8tqGcQDyyFkMq7OFJsK
         jA2JyWc6CyyflWv1E60spIYSDeI1y5ISW3EERHH41Dbo62WYQFk2/fcimELzd612ZP
         Hd6hjMVeQrj8jjt0Zv5SUTpOEV5TSpNXaX/5BY+o=
Date:   Tue, 18 May 2021 16:36:37 -0700
From:   akpm@linux-foundation.org
To:     ananth@in.ibm.com, christian.brauner@ubuntu.com, corbet@lwn.net,
        hca@linux.ibm.com, joe@perches.com, jszhang@kernel.org,
        jthumshirn@suse.de, marc@koderer.com, mathieu.desnoyers@polymtl.ca,
        mchehab+huawei@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        schwidefsky@de.ibm.com, yangtiezhu@loongson.cn
Subject:  + samples-kprobes-fix-typo-in-handler_fault.patch added
 to -mm tree
Message-ID: <20210518233637.q_6xsCndR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: fix typo in handler_fault()
has been added to the -mm tree.  Its filename is
     samples-kprobes-fix-typo-in-handler_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/samples-kprobes-fix-typo-in-handler_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/samples-kprobes-fix-typo-in-handler_fault.patch

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
Subject: samples/kprobes: fix typo in handler_fault()

Fix a defective format in handler_fault() ending with an 'n' that
should be '\n'.

Link: https://lkml.kernel.org/r/1621218083-23519-2-git-send-email-yangtiezhu@loongson.cn
Fixes: 804defea1c02 ("Kprobes: move kprobe examples to samples/")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Koderer <marc@koderer.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kprobe_example.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/kprobes/kprobe_example.c~samples-kprobes-fix-typo-in-handler_fault
+++ a/samples/kprobes/kprobe_example.c
@@ -101,7 +101,7 @@ static void __kprobes handler_post(struc
  */
 static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
 {
-	pr_info("fault_handler: p->addr = 0x%p, trap #%dn", p->addr, trapnr);
+	pr_info("fault_handler: p->addr = 0x%p, trap #%d\n", p->addr, trapnr);
 	/* Return 0 because we don't handle the fault. */
 	return 0;
 }
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

samples-kprobes-fix-typo-in-handler_fault.patch
samples-kprobes-fix-typo-in-handler_post.patch

