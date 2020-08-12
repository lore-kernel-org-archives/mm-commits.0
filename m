Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0240C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0CBB20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266209;
	bh=CeX4ZIrX2lLrcAiLb6APrDt2aU9el796M+Cck1R/ukY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dfKcDaoREdZcsW7eRdV7U9P2ApiKpQmljsDEyEfOKwii/3pzDK0hvgki0wqEE6B3O
	 0BOJAQhweQOH1BxtcjrSD8HfCgTIyfD2YVQMNXWX/JW/Xu3rUfpTX2QOwRR5uQc8wC
	 5HHwc6Qk79bLEGkagV81t9zcCfJIskgvLrMPmVjA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgHLVD3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVD3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60DC22078B;
        Wed, 12 Aug 2020 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266208;
        bh=CeX4ZIrX2lLrcAiLb6APrDt2aU9el796M+Cck1R/ukY=;
        h=Date:From:To:Subject:From;
        b=ECZvwAaG5M1badkhvpJ93bo+5bTExhorzezi0qRTIoE73KNb5YMWpp65gkgEcYwYZ
         qdg7KMtdnkSdzRRPMkFvel7wW4K3T/KHSpEVdHfdb+ppe3t9z/S054IZO6/EJ7UrVh
         4Rn14pJuEGeB/yzV7CVqtpao2GpywPz60UVi/Z9M=
Date:   Wed, 12 Aug 2020 14:03:28 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, geert@linux-m68k.org, green.hu@gmail.com,
        hch@lst.de, mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [merged]
 exec-use-force_uaccess_begin-during-exec-and-exit.patch removed from -mm
 tree
Message-ID: <20200812210328.iKo-4sbJh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: use force_uaccess_begin during exec and exit
has been removed from the -mm tree.  Its filename was
     exec-use-force_uaccess_begin-during-exec-and-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from hch@lst.de are


