Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5483BC43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16E6F21548
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600053685;
	bh=icOjV/2bhDY+dPcHpuL6p3cYaERGiWBvJ6uPIFZoP70=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YQhGp8Q4xxEeMG7/lpfviZMRJMkf1ie+SLRmmlgf+eZD6IYc/cWWEWfixD7JyyGz6
	 jS9APXR+a8gU8kY/DKBsnGclF7660Y3xMfOHBCtWgbtuGNeJBLPTkqeoaOrzmqc4XM
	 1jjoP+xyFiaexKvV0/UvIHfIR7hu6gOi7Xsn7j0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgINDVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINDVY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:21:24 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB4D8208E4;
        Mon, 14 Sep 2020 03:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600053683;
        bh=icOjV/2bhDY+dPcHpuL6p3cYaERGiWBvJ6uPIFZoP70=;
        h=Date:From:To:Subject:From;
        b=ru+AGxSK5EY2nVWl12z0Xo55rH0xZI2xQOscRFYSMFXr+7jt3AdqR+y6KD7NnDkGJ
         4BEBD6jAjP3Ub1+OmK9NaBHJ/f1lQt7CbBRRU43e5kkKtqrdgkU19mAfU9nOEXzABe
         fDEHzS8aSIo0qvBXVH3eVnlbx3K35k/Vu1b08Xrk=
Date:   Sun, 13 Sep 2020 20:21:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
        tklauser@distanz.ch
Subject:  +
 stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch added
 to -mm tree
Message-ID: <20200914032123.a2yje%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stackleak: let stack_erasing_sysctl take a kernel pointer buffer
has been added to the -mm tree.  Its filename is
     stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: stackleak: let stack_erasing_sysctl take a kernel pointer buffer

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
signature of stack_erasing_sysctl to match ctl_table.proc_handler which
fixes the following sparse warning:

kernel/stackleak.c:31:50: warning: incorrect type in argument 3 (different address spaces)
kernel/stackleak.c:31:50:    expected void *
kernel/stackleak.c:31:50:    got void [noderef] __user *buffer

Link: https://lkml.kernel.org/r/20200907093253.13656-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackleak.h |    2 +-
 kernel/stackleak.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/stackleak.h~stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer
+++ a/include/linux/stackleak.h
@@ -25,7 +25,7 @@ static inline void stackleak_task_init(s
 
 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 int stack_erasing_sysctl(struct ctl_table *table, int write,
-			void __user *buffer, size_t *lenp, loff_t *ppos);
+			void *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
 #else /* !CONFIG_GCC_PLUGIN_STACKLEAK */
--- a/kernel/stackleak.c~stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer
+++ a/kernel/stackleak.c
@@ -20,7 +20,7 @@
 static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
 
 int stack_erasing_sysctl(struct ctl_table *table, int write,
-			void __user *buffer, size_t *lenp, loff_t *ppos)
+			void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret = 0;
 	int state = !static_branch_unlikely(&stack_erasing_bypass);
_

Patches currently in -mm which might be from tklauser@distanz.ch are

ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch
stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch

