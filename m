Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0074CC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA95611EE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhIIVGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346067AbhIIVGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772A2611C3;
        Thu,  9 Sep 2021 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221521;
        bh=8jZ1xRI9IWUHSMevZPuGZpnkAw9ta7XGUMQrmouaDxQ=;
        h=Date:From:To:Subject:From;
        b=MJIhRuULbiad0QlDzSxseXtjONza/kFMxWrwktuZOwdRKU4suAFp67ky+h6EaDkcE
         iVH3wzCwUSbZKkLfIY7qaGZxAikQQp9Mbdz0XuQHB8uQ3Z9wF0jFUJJbU28utQKXiJ
         ICamYhz1buETcYYzShnZvMGpexQZmfeOKqtCQGXQ=
Date:   Thu, 09 Sep 2021 14:05:21 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org
Subject:  [merged] kernel-unexport-get_mmtask_exe_file.patch
 removed from -mm tree
Message-ID: <20210909210521.ql7hEhI_k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: unexport get_{mm,task}_exe_file
has been removed from the -mm tree.  Its filename was
     kernel-unexport-get_mmtask_exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1187,7 +1187,6 @@ struct file *get_mm_exe_file(struct mm_s
 	rcu_read_unlock();
 	return exe_file;
 }
-EXPORT_SYMBOL(get_mm_exe_file);
 
 /**
  * get_task_exe_file - acquire a reference to the task's executable file
@@ -1210,7 +1209,6 @@ struct file *get_task_exe_file(struct ta
 	task_unlock(task);
 	return exe_file;
 }
-EXPORT_SYMBOL(get_task_exe_file);
 
 /**
  * get_task_mm - acquire a reference to the task's mm
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

