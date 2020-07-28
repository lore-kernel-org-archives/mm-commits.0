Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC41EC433E3
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A68492065E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595967986;
	bh=uYjA0ZuKom3c7Ir7sy53+eBDw5kn5A/on+/vbzrTIJw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0lZrhbuX47gXTAvZ8RkpKu5CWefZ8ZqI87Opn1F8bPKGGslVSvuO08l1QVRRApnia
	 oybrU1jJjBK/Env8mbzuIYUEMjcdOfTc18ktYQJhOn4A6h/9SHAEn9Ju60jvBfOkmX
	 jGhvuYd861iyFgRXJLG39w40B0wpn+j2H3FRQQnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgG1U00 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgG1U00 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 16:26:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 277F12065E;
        Tue, 28 Jul 2020 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967985;
        bh=uYjA0ZuKom3c7Ir7sy53+eBDw5kn5A/on+/vbzrTIJw=;
        h=Date:From:To:Subject:From;
        b=h83gI6RiDLEFoMX2HRhU2UJA8ZP8mN11Sluxyn0vkI3b6FJK8TNVL3KC0JPKxS8+Z
         9Pm3RdAJjulCAReeZczIRfL3RovmyrKnI8w87I3iQNn1T6tBLi2gJ0iSGHOy+p9CYv
         uTcPKxG8XlDdkhIV7/M7HN3ZXuSc42/l4TM//27M=
Date:   Tue, 28 Jul 2020 13:26:24 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200728202624.plKlLgf7E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/entry-common.S |   31 -------------------------------
 1 file changed, 31 deletions(-)

--- a/arch/sh/kernel/entry-common.S~linux-next-git-rejects
+++ a/arch/sh/kernel/entry-common.S
@@ -178,37 +178,6 @@ syscall_exit_work:
 	bra	resume_userspace
 	 nop
 
-<<<<<<< HEAD
-	.align	2
-syscall_trace_entry:
-	!                     	Yes it is traced.
-	mov     r15, r4
-	mov.l	7f, r11		! Call do_syscall_trace_enter which notifies
-	jsr	@r11	    	! superior (will chomp R[0-7])
-	 nop
-	mov.l	r0, @(OFF_R0,r15)	! Save return value
-	!			Reload R0-R4 from kernel stack, where the
-	!   	    	    	parent may have modified them using
-	!   	    	    	ptrace(POKEUSR).  (Note that R0-R2 are
-	!   	    	    	reloaded from the kernel stack by syscall_call
-	!   	    	    	below, so don't need to be reloaded here.)
-	!   	    	    	This allows the parent to rewrite system calls
-	!   	    	    	and args on the fly.
-	mov.l	@(OFF_R4,r15), r4   ! arg0
-	mov.l	@(OFF_R5,r15), r5
-	mov.l	@(OFF_R6,r15), r6
-	mov.l	@(OFF_R7,r15), r7   ! arg3
-	mov.l	@(OFF_R3,r15), r3   ! syscall_nr
-	!
-	mov.l	6f, r10			! Number of syscalls
-	cmp/hs	r10, r3
-	bf	syscall_call
-	mov	#-ENOSYS, r0
-	bra	syscall_exit
-	 mov.l	r0, @(OFF_R0,r15)	! Return value
-
-=======
->>>>>>> linux-next/akpm-base
 __restore_all:
 	mov	#OFF_SR, r0
 	mov.l	@(r0,r15), r0	! get status register
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

