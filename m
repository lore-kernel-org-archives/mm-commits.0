Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5381C04FF3
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 00:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9158B613EC
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 00:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhEVAWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 May 2021 20:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhEVAVv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 May 2021 20:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37722613D6;
        Sat, 22 May 2021 00:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621642826;
        bh=U1sH6yKQK7nUczyjR1FatvgoMJ6aopMmaTEC529EcNM=;
        h=Date:From:To:Subject:From;
        b=rfCxTGN+oU6O70vnc1/K0NPYmbRwI7jhNJJS+z8rzonHP+R7M7Lm/gJiS+GamZ8PB
         y+jva2ibIicq8Fvkv2LtgzbzwqGaJzjrl/h10K7IoVKaceHQDU48whnd6xeS3wiNq7
         v1+sJGodHmJbTRCbq+KnzKRM94De+alRRrRB9DBE=
Date:   Fri, 21 May 2021 17:20:25 -0700
From:   akpm@linux-foundation.org
To:     ananth@in.ibm.com, christian.brauner@ubuntu.com, corbet@lwn.net,
        hca@linux.ibm.com, joe@perches.com, jszhang@kernel.org,
        jthumshirn@suse.de, marc@koderer.com, mathieu.desnoyers@polymtl.ca,
        mchehab+huawei@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        schwidefsky@de.ibm.com, yangtiezhu@loongson.cn
Subject:  [obsolete]
 samples-kprobes-fix-typo-in-handler_fault.patch removed from -mm tree
Message-ID: <20210522002025.ckKFKmrCK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: fix typo in handler_fault()
has been removed from the -mm tree.  Its filename was
     samples-kprobes-fix-typo-in-handler_fault.patch

This patch was dropped because it is obsolete

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

samples-kprobes-fix-typo-in-handler_post.patch

