Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A90BC4741F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C04E22273
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279292;
	bh=ZMKCFLLrBEvTV6BjrBuoGB+YdyTQXDnnp7wqyi9Lo4w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=x8Up2NA4/tZDJ2gN09YKWXeBlPDRvN4h3hMzCVotJWHnEiXYsnPm1wT0FtN9yjznr
	 kTUP8+mngC0rqSTTMenTejU0ZnJwNzdbHVt92HABS5/KTh6UL5SeS7zbOcV6GZc8EL
	 sOIo9sEER5kMGfml/XHhltUZqDmIwfGbp63+vH3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgKBBIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:08:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D0A22272;
        Mon,  2 Nov 2020 01:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279291;
        bh=ZMKCFLLrBEvTV6BjrBuoGB+YdyTQXDnnp7wqyi9Lo4w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V1FlTCiaVuAdxdlQchvVMn5dPeWVhZiu/DQSdj49rJMP/ImFWURhEgCCHScQSyJYV
         6LmF09awvlwYqogXdTd3LGj4q1heMOYKA2Cgk4R3OZO7PrsZte5ZAApg+sg2G746nw
         DfDJDsdQcwb53r2xV9AmfAoWiK8oAwmgHkLwJnpc=
Date:   Sun, 01 Nov 2020 17:08:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, rdna@fb.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 15/15] kernel/hung_task.c: make type annotations
 consistent
Message-ID: <20201102010810.fKUP5FhiG%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: kernel/hung_task.c: make type annotations consistent

Commit 32927393dc1c ("sysctl: pass kernel pointers to ->proc_handler")
removed various __user annotations from function signatures as part of its
refactoring.

It also removed the __user annotation for proc_dohung_task_timeout_secs()
at its declaration in ./sched/sysctl.h, but not at its definition in
./kernel/hung_task.c.

Hence, sparse complains:

  kernel/hung_task.c:271:5: error: \
  symbol 'proc_dohung_task_timeout_secs' redeclared with different type \
  (incompatible argument 3 (different address spaces))

Adjust the annotation at the definition fitting to that refactoring to make
sparse happy again, which also resolves this warning from sparse:

  kernel/hung_task.c:277:52: warning: incorrect type in argument 3 \
    (different address spaces)
  kernel/hung_task.c:277:52:    expected void *
  kernel/hung_task.c:277:52:    got void [noderef] __user *buffer

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20201028130541.20320-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/hung_task.c~kernel-hung_taskc-make-type-annotations-consistent
+++ a/kernel/hung_task.c
@@ -225,8 +225,7 @@ static long hung_timeout_jiffies(unsigne
  * Process updating of timeout sysctl
  */
 int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos)
+				  void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
_
