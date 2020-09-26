Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB69C4741F
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E29120BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085502;
	bh=cM5NwGUg2gyUD4NSpgzz1nYcblawMZ+R4dNqiRG/DwY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EXZhDGG1pPTQVDloVtQK08LxSnCnCQrf3CeXCeHTv4EZja/8QeyoUbEkujyh6/965
	 xFqeHhjZtxXsDqxMWFT3tTtyPYRtUypOM+blu8cWnzhHN57eLi1FHw8Yo1ubpsn83l
	 FO0JeeuTJ8CxDLXQIWQLF0GXKlbBGXh5KDEbCPSM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIZB6W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgIZB6V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E96F21D7F;
        Sat, 26 Sep 2020 01:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085500;
        bh=cM5NwGUg2gyUD4NSpgzz1nYcblawMZ+R4dNqiRG/DwY=;
        h=Date:From:To:Subject:From;
        b=lMVCZLfx+UVOSxjHEBwQ7cNfXunuBMpmQuh2KpFQU1NOP6pd/dX/lRKBn++QizIAr
         GBeyzybyqtfARxzFxs+0MPQSkYgW0qtvNzfqJQY7iJ9S1EJ0vj4pfL3c+nKkzgkJOJ
         9KKAa8M0qYzjIsuVhMHC75bSepyLqauCmHdhXLRI=
Date:   Fri, 25 Sep 2020 18:58:20 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch
 removed from -mm tree
Message-ID: <20200926015820.iPPXnRihm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stackleak: let stack_erasing_sysctl take a kernel pointer buffer
has been removed from the -mm tree.  Its filename was
     stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


