Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6579AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358176AbiATCIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50524 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCI3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAA7EB81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9653C004E1;
        Thu, 20 Jan 2022 02:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644507;
        bh=U6B4qglAt+oZVw2DWNlJrCL9GyjFqfaVRjnPyypyIcQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dlDvLkszQX9a0Y6LPpNiegxzrlxsqBsLlgLAVPmMtNRCDX9QObRReaL35AL8gDJQg
         ur+Y5JGe29aoEZRn7j8D8ROTmgoW8Ej4e25Aay+EyJZUfnnmIULAcug6vUQGfYB5E2
         LFRKwPmLaUoLSM0WBPnVd+xVFEBG8RgyJM6RU4Sw=
Date:   Wed, 19 Jan 2022 18:08:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexei.starovoitov@gmail.com,
        andrii.nakryiko@gmail.com, andrii@kernel.org,
        arnaldo.melo@gmail.com, david@redhat.com,
        dennis.dalessandro@cornelisnetworks.com, keescook@chromium.org,
        laoar.shao@gmail.com, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, mirq-linux@rere.qmqm.pl,
        mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 14/55] drivers/infiniband: replace open-coded
 string copy with get_task_comm
Message-ID: <20220120020826.bnZuddQgG%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: drivers/infiniband: replace open-coded string copy with get_task_comm

We'd better use the helper get_task_comm() rather than the open-coded
strlcpy() to get task comm.  As the comment above the hard-coded 16, we
can replace it with TASK_COMM_LEN.

Link: https://lkml.kernel.org/r/20211120112738.45980-4-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib.h          |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_file_ops.c~drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportda
 	rcd->tid_pg_list = ptmp;
 	rcd->pid = current->pid;
 	init_waitqueue_head(&dd->rcd[ctxt]->wait);
-	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
+	get_task_comm(rcd->comm, current);
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
 	dd->freectxts--;
--- a/drivers/infiniband/hw/qib/qib.h~drivers-infiniband-replace-open-coded-string-copy-with-get_task_comm
+++ a/drivers/infiniband/hw/qib/qib.h
@@ -196,7 +196,7 @@ struct qib_ctxtdata {
 	pid_t pid;
 	pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
 	/* same size as task_struct .comm[], command that opened context */
-	char comm[16];
+	char comm[TASK_COMM_LEN];
 	/* pkeys set by this use of this ctxt */
 	u16 pkeys[4];
 	/* so file ops can get at unit */
_
