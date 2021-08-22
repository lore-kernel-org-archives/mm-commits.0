Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F852C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F53D60FE6
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 22:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhHVWCB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 18:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhHVWCA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 18:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CEFA61186;
        Sun, 22 Aug 2021 22:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629669679;
        bh=bbXQNWCKahBq/5rmtpU3qB3adTexa46xGd8sqbTLfL8=;
        h=Date:From:To:Subject:From;
        b=SdUwPWPtnuijD1DxrHy2d3205yxCRJ/+qXC7U9tTb8vbXBD5XjX/oYnCot7q/HpCF
         Y4Ci3Ii3ivC8U3J/rW+WZyuulqq/EdLQ3aG/J0eeiLJHwzJWB3pTq6RdKPgGdqVaMv
         c128t6ypHJAw4ewSUSG7RvMGTkrJ0F7UisZk7aVM=
Date:   Sun, 22 Aug 2021 15:01:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  + kernel-unexport-get_mmtask_exe_file.patch added to -mm
 tree
Message-ID: <20210822220119.6wxhs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: unexport get_{mm,task}_exe_file
has been added to the -mm tree.  Its filename is
     kernel-unexport-get_mmtask_exe_file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-unexport-get_mmtask_exe_file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-unexport-get_mmtask_exe_file.patch

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
Subject: kernel/fork.c: unexport get_{mm,task}_exe_file

Only used by core code and the tomoyo which can't be a module either.

Link: https://lkml.kernel.org/r/20210820095430.445242-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/fork.c~kernel-unexport-get_mmtask_exe_file
+++ a/kernel/fork.c
@@ -1238,7 +1238,6 @@ struct file *get_mm_exe_file(struct mm_s
 	rcu_read_unlock();
 	return exe_file;
 }
-EXPORT_SYMBOL(get_mm_exe_file);
 
 /**
  * get_task_exe_file - acquire a reference to the task's executable file
@@ -1261,7 +1260,6 @@ struct file *get_task_exe_file(struct ta
 	task_unlock(task);
 	return exe_file;
 }
-EXPORT_SYMBOL(get_task_exe_file);
 
 /**
  * get_task_mm - acquire a reference to the task's mm
_

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

