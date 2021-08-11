Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB77C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A414760EE9
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhHKBXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 21:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhHKBXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 21:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A2E600CD;
        Wed, 11 Aug 2021 01:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628644995;
        bh=uHN3v+QoCsH5/TGKopz29+vvFWkZCE1Rhcj6dCKO9mE=;
        h=Date:From:To:Subject:From;
        b=Ytzh7Je+e+rjQxfM+uJzsDwI1wMVSfyJbgGBJPMdCEIUlaHcTHyeVy7rOoChPBYRt
         qUtYn0rl7tubmeENkCHPuYoZ/wlxMxRFG6MlZKv0t5CnguTeNAhv+Yil0Zr6qK+Sk5
         hhLmZ9fj1TDt7nPqpAt/avFhyJYPuW3P6JLcsIM0=
Date:   Tue, 10 Aug 2021 18:23:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, hch@lst.de
Subject:  + proc-stop-using-seq_get_buf-in-proc_task_name.patch added
 to -mm tree
Message-ID: <20210811012315.Fl0ki%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: stop using seq_get_buf in proc_task_name
has been added to the -mm tree.  Its filename is
     proc-stop-using-seq_get_buf-in-proc_task_name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-stop-using-seq_get_buf-in-proc_task_name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-stop-using-seq_get_buf-in-proc_task_name.patch

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
Subject: proc: stop using seq_get_buf in proc_task_name

Use seq_escape_str and seq_printf instead of poking holes into the
seq_file abstraction.

Link: https://lkml.kernel.org/r/20210810151945.1795567-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

Patches currently in -mm which might be from hch@lst.de are

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch

