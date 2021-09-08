Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FCEC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0050761164
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbhIHC6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347049AbhIHC6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 608E260E52;
        Wed,  8 Sep 2021 02:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069853;
        bh=uJeDGmuGZ3EPDwOoq24r4yvvQ1TSe/HAuPoXcI20n80=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1ltraHOq0KEM1V0mKqtbJxmWrVDA4sPQ48VvWOwp9Tz1En9QqPe8iXi4l27ZZdIdR
         KjK1FegeNJ9dnwfF0UTY7cs6PBCCmSIeVCwZPiQKhZ5C7ceSNOicBtz7EnXObyC//W
         0pDf0H4i9SEzZlIhVUOQA9TFzLxMCYQlE8bcO0g8=
Date:   Tue, 07 Sep 2021 19:57:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 080/147] proc: stop using seq_get_buf in
 proc_task_name
Message-ID: <20210908025733.WqO2snQjP%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: proc: stop using seq_get_buf in proc_task_name

Use seq_escape_str and seq_printf instead of poking holes into the
seq_file abstraction.

Link: https://lkml.kernel.org/r/20210810151945.1795567-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/fs/proc/array.c~proc-stop-using-seq_get_buf-in-proc_task_name
+++ a/fs/proc/array.c
@@ -98,27 +98,17 @@
 
 void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 {
-	char *buf;
-	size_t size;
 	char tcomm[64];
-	int ret;
 
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
 	else
 		__get_task_comm(tcomm, sizeof(tcomm), p);
 
-	size = seq_get_buf(m, &buf);
-	if (escape) {
-		ret = string_escape_str(tcomm, buf, size,
-					ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
-		if (ret >= size)
-			ret = -1;
-	} else {
-		ret = strscpy(buf, tcomm, size);
-	}
-
-	seq_commit(m, ret);
+	if (escape)
+		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+	else
+		seq_printf(m, "%.64s", tcomm);
 }
 
 /*
_
