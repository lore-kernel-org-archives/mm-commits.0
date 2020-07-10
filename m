Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E03C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F1D20772
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417679;
	bh=HMtjMpHrm2wd1sMl3EROLDNsxa0+lWh1SMFmMmusO28=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pXefyv3VqeMRWc52jcuC9gKeyh/LinxrIwFDH+7R1N6knNq+SmCF6wBFR+tmZWqC8
	 o8ZLSiFF8Zrenl+EegA9Ih+nAKK+QyrldmLE4QO/ttrm9u+54VgRfGbzLOhwJyiw8e
	 E1UYD+ZxFitsjQHuE7sUts75PZtoiCKQB6/Vb7Hw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgGJVr6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVr6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:47:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96282075D;
        Fri, 10 Jul 2020 21:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417678;
        bh=HMtjMpHrm2wd1sMl3EROLDNsxa0+lWh1SMFmMmusO28=;
        h=Date:From:To:Subject:From;
        b=CpyG1wyVUmO8Ey3RUOq0mptUL0k7Ds1JmitXsTINlwCUaksG0B6KMv5PGLf4JErQs
         bT5JlxHgfKQKITLGMTW67V+UR5JAFjKD4YNWl3GPFR4kpEPIQOXRHw0lI7lh/iSLMt
         7UQ1KznASu36E9dgPdVSrQ9NUp8QQQiL8oHDaeOo=
Date:   Fri, 10 Jul 2020 14:47:57 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  + exec-use-force_uaccess_begin-during-exec-and-exit.patch
 added to -mm tree
Message-ID: <20200710214757.arhc1xXkt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: use force_uaccess_begin during exec and exit
has been added to the -mm tree.  Its filename is
     exec-use-force_uaccess_begin-during-exec-and-exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-use-force_uaccess_begin-during-exec-and-exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-use-force_uaccess_begin-during-exec-and-exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    7 ++++++-
 kernel/exit.c |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/exec.c~exec-use-force_uaccess_begin-during-exec-and-exit
+++ a/fs/exec.c
@@ -1380,7 +1380,12 @@ int begin_new_exec(struct linux_binprm *
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
@@ -731,7 +731,7 @@ void __noreturn do_exit(long code)
 	 * mm_release()->clear_child_tid() from writing to a user-controlled
 	 * kernel address.
 	 */
-	set_fs(USER_DS);
+	force_uaccess_begin();
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
_

Patches currently in -mm which might be from hch@lst.de are

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

