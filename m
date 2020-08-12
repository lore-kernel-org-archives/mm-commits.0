Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFBC433EC
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061652076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196034;
	bh=iuaLi2FypdCjQV79tqe21ngZf2j5qAR+pxnP+dvjgrQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=G1QK65fkhsk4BSJEaHGsNICmw+lV9EEFyr4f+uugpT5xmzJIlw0qbNju7lnIbXHTx
	 9TXQauCEG9hgV92ybPxsaWz6E0mtKi7AhgVeV8IcS6OBhsHRyYITWGSMSfESCxRc1X
	 xvqn1Ok79gx2LTtWLKvCpmmILPksd3g2tTIxOeKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHLBdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgHLBdw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44CC72087C;
        Wed, 12 Aug 2020 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196031;
        bh=iuaLi2FypdCjQV79tqe21ngZf2j5qAR+pxnP+dvjgrQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JY9HwEL7ZtmVdt6v6dV6cnyD4XdZ1kpbi8tBYvGL+LWiWFFJRPLLo84l994L8Ze1i
         OzRxpiqkLJaNZr4oWtQxXHgWXDsria+4UqrtgSjKETG6UHpI9GbiNRDiBkquYlbJcP
         Id4ANqVvn/fNGwUFF2fhLHSQ/rVAZO/tczwI2Xks=
Date:   Tue, 11 Aug 2020 18:33:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com,
        geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [patch 068/165] exec: use force_uaccess_begin during exec
 and exit
Message-ID: <20200812013350.pxHVIskxW%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: exec: use force_uaccess_begin during exec and exit

Both exec and exit want to ensure that the uaccess routines actually do
access user pointers.  Use the newly added force_uaccess_begin helper
instead of an open coded set_fs for that to prepare for kernel builds
where set_fs() does not exist.

Link: http://lkml.kernel.org/r/20200710135706.537715-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    7 ++++++-
 kernel/exit.c |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/exec.c~exec-use-force_uaccess_begin-during-exec-and-exit
+++ a/fs/exec.c
@@ -1402,7 +1402,12 @@ int begin_new_exec(struct linux_binprm *
 	if (retval)
 		goto out_unlock;
 
-	set_fs(USER_DS);
+	/*
+	 * Ensure that the uaccess routines can actually operate on userspace
+	 * pointers:
+	 */
+	force_uaccess_begin();
+
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
--- a/kernel/exit.c~exec-use-force_uaccess_begin-during-exec-and-exit
+++ a/kernel/exit.c
@@ -732,7 +732,7 @@ void __noreturn do_exit(long code)
 	 * mm_release()->clear_child_tid() from writing to a user-controlled
 	 * kernel address.
 	 */
-	set_fs(USER_DS);
+	force_uaccess_begin();
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
_
