Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216EDC433E2
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C2A20720
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595365617;
	bh=V4eKBJgJBYr3r6zjnNu/Wx/1lFfSCmAIiXuIegghKaY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Jsbbm3ieBdHKFk4SyP95E+IV6UkMsXZi3iF0cSA3qm8KpBrdDTe3ybwR3SybPOGMq
	 +BZ6Vce2YsVBHw8lXhz+y7F0G/Xrayw8NX4fv1LPrxSDt9WpWqUdmjgtTfAo5gFW1w
	 aDXM6mVjgG+w/RXiNZdkAaT4lvOd8Kfdq3H8AuDs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbgGUVG5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 17:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgGUVG5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 17:06:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C6F20729;
        Tue, 21 Jul 2020 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365617;
        bh=V4eKBJgJBYr3r6zjnNu/Wx/1lFfSCmAIiXuIegghKaY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=se0h3x9Qudpoc2MZXE8OAKxEd5sK6UW9NrFh9ts6newbCDjtqx0AZvuGduKAwiHoH
         xusZe8qHEzGzTxyyIId02BhnpORdz4VMk+P0p3v832z4EbnfAfvDYi07kJdZHho4Vc
         2UGrrVuMtud4KIb388kHrtePA4I9Z3vQdi+0LAnk=
Date:   Tue, 21 Jul 2020 14:06:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        peterz@infradead.org
Subject:  + mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch added
 to -mm tree
Message-ID: <20200721210656.jAE6TQnxP%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-kthread_use_mm-vs-tlb-invalidate-fix
has been added to the -mm tree.  Its filename is
     mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch

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
Subject: mm-fix-kthread_use_mm-vs-tlb-invalidate-fix

add comment

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kthread.c~mm-fix-kthread_use_mm-vs-tlb-invalidate-fix
+++ a/kernel/kthread.c
@@ -1239,6 +1239,7 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(tsk->mm);
 
 	task_lock(tsk);
+	/* Hold off tlb flush IPIs while switching mm's */
 	local_irq_disable();
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
io-mapping-indicate-mapping-failure-fix.patch
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
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

