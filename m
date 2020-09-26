Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16D6C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B154F20BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085501;
	bh=Ulvy5eY5FnTJTb2TYCid0HO++pfgBq493oP/PjP7+hA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xcOkiwBpYXQS1VgVx/Esrw7g8JA6/HHEhZpMBv0DsYqLsDxhDHUwxMq9J1JeC3DtB
	 99F8P+RR6+Qa6hpd9VmoE6uEWJPXRFa5Ix4OfJe5Gs6AWWtywUXVtqMXjH3nkt0Y7o
	 iyS1ztsgN2xOHXKgxC4xOBpkggwFxh83L+4Xd1cU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgIZB6V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8043021741;
        Sat, 26 Sep 2020 01:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085498;
        bh=Ulvy5eY5FnTJTb2TYCid0HO++pfgBq493oP/PjP7+hA=;
        h=Date:From:To:Subject:From;
        b=j0dORsZw6yqQsgxi1zF/iiDEHYHiFXaCrJ7kokW6WNGCi8w3gYEgRhC5bIpj4CFgv
         0MCxCupWvOX9orTnqenW3WkQi0q3vTdrJN5OVgRbxtOOde+5ncr5LNoudbkNRZkGMn
         Z868vB7n9mGVRqErUhTKu5plytzhOwHE7R2QjDvI=
Date:   Fri, 25 Sep 2020 18:58:18 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, tklauser@distanz.ch,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch removed
 from -mm tree
Message-ID: <20200926015818.2z-zhk--8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ftrace: let ftrace_enable_sysctl take a kernel pointer buffer
has been removed from the -mm tree.  Its filename was
     ftrace-let-ftrace_enable_sysctl-take-a-kernel-pointer-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


