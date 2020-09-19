Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC30CC4346A
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A19EF23447
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489235;
	bh=gk24wV3WVTBzPPveOonr3cUF08YOq2VfR9ge8keh9dM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Vq7fmD+oCCSeKAjAJ/razLFhs0rH7nWMVDhylXgKxS2emXjITlaehBnU7S5YJ+iqr
	 XWXm7bxtX14lDZdp14Bok4q7/D1p8GtnCo4HSBpdEl3oBsTnVMMzbKoEZCYK7uiD5m
	 UH2WvDGGQn5uSyAghudiWQlNRpXJcZGNzm5ER/tM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISEUf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A707221EC;
        Sat, 19 Sep 2020 04:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489234;
        bh=gk24wV3WVTBzPPveOonr3cUF08YOq2VfR9ge8keh9dM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tZLnN09029tAVv8NDjQJhlC9HLbZzxw714rJMVi+IAy5F0jXzA31BxaAHTDSjvOoQ
         iUc1sKZhaLlWgD9kclr3+nc8BrVd29M6WMv1SFewofQbg88dkewH/GhBfIkKzd1iBd
         vtBCCFpYXPPRPNqM37kqDYXVz5NGxLRzaztQRmDg=
Date:   Fri, 18 Sep 2020 21:20:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tklauser@distanz.ch,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 12/15] ftrace: let ftrace_enable_sysctl take a
 kernel pointer buffer
Message-ID: <20200919042034.zNxoolnD3%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
