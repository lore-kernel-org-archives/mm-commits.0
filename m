Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA88C4167D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE517611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346320AbhIIVFj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348439AbhIIVEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687B7611CA;
        Thu,  9 Sep 2021 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221403;
        bh=wCLTk0OryhOH0h8o0MB2POu/xovFtAmaBYQyGwz5fUU=;
        h=Date:From:To:Subject:From;
        b=feKF6mUmSmy/B3QADJvRJ8zbdvb5+ohxEn3VUTGSoYsm67yOKmWxkqbVXu56Dk4u0
         B7e6jqclnDhQ/2tV/I/fxYAUX4nsIGLmkYNjhAdaoyZJaWF0GQBilWhKDDxx+6Fth1
         XahpIaCCRh0b6Lfc62Cac+erDJ9L+zwI4wkAHYCM=
Date:   Thu, 09 Sep 2021 14:03:23 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com, hch@lst.de,
        mm-commits@vger.kernel.org
Subject:  [merged]
 proc-stop-using-seq_get_buf-in-proc_task_name.patch removed from -mm tree
Message-ID: <20210909210323.TifPA0GXO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: stop using seq_get_buf in proc_task_name
has been removed from the -mm tree.  Its filename was
     proc-stop-using-seq_get_buf-in-proc_task_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

