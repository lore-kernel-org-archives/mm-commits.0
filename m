Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC592C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8770922211
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489238;
	bh=c/5YX7/XsB50Z9xLC1/TiX160ykBQL44OxtocA/8dN8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rFwKo7AY6ef/G9qzj0mIl2PNpV3elKBnaWL/BFwu6krhmNXa5Oor1s71oALDt4r8K
	 L568i0DdPFaYuG+BaQMciE3aKIaH+V869vtREfKyAWGSd/biQLOQ/nUJBfU7ujDWwD
	 o/U1Fwec3NfT8TsRU9cKSiz7PPOWsr+ozDjhBXD8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgISEUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB7C21D43;
        Sat, 19 Sep 2020 04:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489237;
        bh=c/5YX7/XsB50Z9xLC1/TiX160ykBQL44OxtocA/8dN8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iJUSrOUe42lnT0T9b0YPHQVk2I5vtq4jmeG0gqUcUKC7O4IEGGK2dcCkmbGfNy6NQ
         AJnTwHY5ebeY0OnuirJAQWfsIEhyQatX9zKucdiXRl0uRmXNDpcGSvVJG3rgn/2klj
         6e+f2Ex3pJ3sJ3rc7jpWjdQc+qfPvQGZ4y2HFlzI=
Date:   Fri, 18 Sep 2020 21:20:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tklauser@distanz.ch,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 13/15] stackleak: let stack_erasing_sysctl take a
 kernel pointer buffer
Message-ID: <20200919042037.YummvrgIW%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
