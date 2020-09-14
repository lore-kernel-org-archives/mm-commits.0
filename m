Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A365CC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6712C208E4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600053682;
	bh=fFy40A1ioSH+I96+RukHrdD1i8TeW4NXM7z6LAJAV20=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rUVFIjXmrODSHBUEdRMrcSUZszgEkxMv8A6ulT5jOkUtr4h80LRnayZA7N9+CbvvM
	 IjvSJMjVP0gKlSuD8VRCa1i/M6ioGJ3AVh2zrP6JBp4PiwypoWe5lCAS15cDm5cfeB
	 nFNPxFBu2yP6Q6uGVZBNniyIEgLw/8G9Uqroqd9Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgINDVV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINDVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:21:21 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1368208DB;
        Mon, 14 Sep 2020 03:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600053681;
        bh=fFy40A1ioSH+I96+RukHrdD1i8TeW4NXM7z6LAJAV20=;
        h=Date:From:To:Subject:From;
        b=xqRp8krktasdxzSHdHh2IPjIsa4w7AQE+9VZQWHN1CfvU7oT3Ktm++xGxNbaw5m2R
         0RTj3D+guNjRdhoWbiMhZr3N9Zj27Za0MaBwl2ZeY+znLuAKRtTvg4jgCY2dAqgXPA
         2GXdLvSikT6r1QIhypzN5hqWToZjKXEozBc1ihPI=
Date:   Sun, 13 Sep 2020 20:21:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
        tklauser@distanz.ch
Subject:  +
 ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch added to
 -mm tree
Message-ID: <20200914032120.BwVYn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ftrace: let ftrace_enable_sysctl take a kernel pointer buffer
has been added to the -mm tree.  Its filename is
     ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch

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
Subject: ftrace: let ftrace_enable_sysctl take a kernel pointer buffer

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
changed ctl_table.proc_handler to take a kernel pointer.  Adjust the
signature of ftrace_enable_sysctl to match ctl_table.proc_handler which
fixes the following sparse warning:

kernel/trace/ftrace.c:7544:43: warning: incorrect type in argument 3 (different address spaces)
kernel/trace/ftrace.c:7544:43:    expected void *
kernel/trace/ftrace.c:7544:43:    got void [noderef] __user *buffer

Link: https://lkml.kernel.org/r/20200907093207.13540-1-tklauser@distanz.ch
Fixes: 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |    3 +--
 kernel/trace/ftrace.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/ftrace.h~ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer
+++ a/include/linux/ftrace.h
@@ -85,8 +85,7 @@ static inline int ftrace_mod_get_kallsym
 extern int ftrace_enabled;
 extern int
 ftrace_enable_sysctl(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp,
-		     loff_t *ppos);
+		     void *buffer, size_t *lenp, loff_t *ppos);
 
 struct ftrace_ops;
 
--- a/kernel/trace/ftrace.c~ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer
+++ a/kernel/trace/ftrace.c
@@ -7531,8 +7531,7 @@ static bool is_permanent_ops_registered(
 
 int
 ftrace_enable_sysctl(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp,
-		     loff_t *ppos)
+		     void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret = -ENODEV;
 
_

Patches currently in -mm which might be from tklauser@distanz.ch are

ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch
stackleak-let-stack_erasing_sysctl-take-a-kernel-pointer-buffer.patch

