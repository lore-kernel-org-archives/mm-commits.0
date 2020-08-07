Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AB3C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5AA22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596776509;
	bh=RrgArAuvfoZQ+km4zwT4qdLG/BnWT82O99V5ugrTAD0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A1EkRxxADJ+kOWclJYpur8ztogx0XTX4SUHuMIDTVsx2TaZD6Y70wCrKdxxPj5m2j
	 8UNv+uSLFho8FTpMMP59wNrI0OTnoZ3YGTE/KslGs/JlpS7sXFDSHBOzVdElLse8EE
	 JySbhJi8fiNBvn+PnQpASbrFeclWfUNwOn6UtUpI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725265AbgHGFBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbgHGFBs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:01:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 428E120866;
        Fri,  7 Aug 2020 05:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596776508;
        bh=RrgArAuvfoZQ+km4zwT4qdLG/BnWT82O99V5ugrTAD0=;
        h=Date:From:To:Subject:From;
        b=WgZPKij78syq3e4b0FP80uNCn7YUwvPo0PqyV8EEsdagKjyYibfOyeP0ZUGm3oWIf
         84lSM6ycItraPLo1ebjiKQAbfl38JqcAaHXSTcq2tzrb1NRybWC2nO3qv5HynVPZLY
         MLRqgI6poyQWntl9YaBPZEmBpzm6XZALlGRvYvzc=
Date:   Thu, 06 Aug 2020 22:01:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, longman@redhat.com,
        mm-commits@vger.kernel.org
Subject:  + mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch
 added to -mm tree
Message-ID: <20200807050147.DeS666pef%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix
has been added to the -mm tree.  Its filename is
     mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch

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
Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix

fs/crypto/inline_crypt.c needs linux/slab.h

Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/inline_crypt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/crypto/inline_crypt.c~mm-treewide-rename-kzfree-to-kfree_sensitive-fix
+++ a/fs/crypto/inline_crypt.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
+#include <linux/slab.h>
 
 #include "fscrypt_private.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch
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

