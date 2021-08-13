Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064E6C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36B160EB5
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhHMULw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233995AbhHMULv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 16:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98C6060EB5;
        Fri, 13 Aug 2021 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628885484;
        bh=dbMdtJv5jMBJCNsml2D9NtcxkeYdQfRgeQQEA+Mc/dw=;
        h=Date:From:To:Subject:From;
        b=iJ8R754x93ZSbMrmS893lAO/4itIpnK9L6JqkhsnmfrXx7CniAz55eePT3+GC9jE7
         cWOKGEnIDXu9+9j7XYR018hPz/Idi9/PT/9z7AA2mQq7t6AhZVjikL1bIsSywsEqUu
         M0BKDibQZiokzt9FxswpwKVv1lICXt95iYT/F4Dc=
Date:   Fri, 13 Aug 2021 13:11:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, changbin.du@gmail.com
Subject:  + mm-in_irq-cleanup.patch added to -mm tree
Message-ID: <20210813201124.8qzzx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: in_irq() cleanup
has been added to the -mm tree.  Its filename is
     mm-in_irq-cleanup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-in_irq-cleanup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-in_irq-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: mm: in_irq() cleanup

Replace the obsolete and ambiguos macro in_irq() with new macro
in_hardirq().

Link: https://lkml.kernel.org/r/20210813145245.86070-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c  |    2 +-
 mm/kmemleak.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-in_irq-cleanup
+++ a/mm/highmem.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL(zero_user_segments);
 
 static inline int kmap_local_idx_push(void)
 {
-	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	WARN_ON_ONCE(in_hardirq() && !irqs_disabled());
 	current->kmap_ctrl.idx += KM_INCR;
 	BUG_ON(current->kmap_ctrl.idx >= KM_MAX_IDX);
 	return current->kmap_ctrl.idx - 1;
--- a/mm/kmemleak.c~mm-in_irq-cleanup
+++ a/mm/kmemleak.c
@@ -598,7 +598,7 @@ static struct kmemleak_object *create_ob
 	object->checksum = 0;
 
 	/* task information */
-	if (in_irq()) {
+	if (in_hardirq()) {
 		object->pid = 0;
 		strncpy(object->comm, "hardirq", sizeof(object->comm));
 	} else if (in_serving_softirq()) {
_

Patches currently in -mm which might be from changbin.du@gmail.com are

mm-in_irq-cleanup.patch

