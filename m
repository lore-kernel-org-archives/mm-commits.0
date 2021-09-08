Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D543CC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBDE86115B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhIHDB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243156AbhIHDBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F15661131;
        Wed,  8 Sep 2021 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070036;
        bh=aeFkU7szAQ3a+zo/FMFMTu3yED8DKB0nfZxN6oRlfvo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fp2IufF0wd7JqQSHsMb0ciZjeXxDCU4yU+MnJMDaK+yiOO1G1P8LF5YTACQlXn8fl
         wj3bXtXfdepsycP2ICcuY1Op6vGSBEzOuNVaCA2BTqqu/5ojo+j5IIyCI7Gp9Ab0FA
         OO4/7DKuF7PyVZMBNeDY2lAIyevUwWSNsUmTika0=
Date:   Tue, 07 Sep 2021 20:00:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 139/147] kernel/fork.c: unexport
 get_{mm,task}_exe_file
Message-ID: <20210908030035.Ts5IRyChM%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
