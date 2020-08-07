Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A82C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080E12086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596778998;
	bh=A6irEdXZRVMy+uQwz/qUvTbTo+3FKZCUBiiN+j8XWz0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lklPThQFicQccEK7LaQ3RTShQofFIAlf6vm7EFEp9HuDbXxT04H4nD/wRFRrZPINC
	 yB/lIivoVGiXWGd09+XmUZ6FIhpzEjceYdE8LvclCWu9oFNDFW23IAeHAUEvNaS9Rs
	 /ExJa/7RD7ypYfUvpB/xqY7dbRDYoRq1rRmu4kFM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGFnR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFnR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:43:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01AA20855;
        Fri,  7 Aug 2020 05:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596778996;
        bh=A6irEdXZRVMy+uQwz/qUvTbTo+3FKZCUBiiN+j8XWz0=;
        h=Date:From:To:Subject:From;
        b=lM4pQ2CzSm38CUygzsGmcPuFGWpIwKeCPnYQNDg12BM5CiG5rS2uxiS5/fDLYtJOy
         Z/Mgp6WuGICfqS1JoslpeKUQKFwKIlT8CQhCSbmRfb58ZVmxFKjgqw0THKXntEgrT1
         Ze1sMPl1+A3NiE4pjneOIHgYY3gN4HcSGk86QDNs=
Date:   Thu, 06 Aug 2020 22:43:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        peterz@infradead.org
Subject:  [folded-merged]
 mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch removed from -mm tree
Message-ID: <20200807054316.SNeAjVG1S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-kthread_use_mm-vs-tlb-invalidate-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch

This patch was dropped because it was folded into mm-fix-kthread_use_mm-vs-tlb-invalidate.patch

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

mm-fix-kthread_use_mm-vs-tlb-invalidate.patch
mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch
mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

