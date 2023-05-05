Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69FFC77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjEEWpY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjEEWpX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C864EC6
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69E09635C7
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D6BC433EF;
        Fri,  5 May 2023 22:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326721;
        bh=VDFEe4peYyx23O8+rNk/azfsjkLCir6qlvn4j8xmS7I=;
        h=Date:To:From:Subject:From;
        b=bM9hm+RwlxS1aqDX41YLDLdYTYa7B0ay6Ur2yNLbhFBBZHe1osvgVkgRNv1zcKTdQ
         e+9RPAIJ83p1JII+Eg0znlc2zaFuB9WYOM0LAsZdNBezniusgAsY/ll9iaUs60+RST
         R4PPCsj4HhxT+4QnUG56cwzD12FvbLzVsn/7O6rc=
Date:   Fri, 05 May 2023 15:45:21 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        rostedt@goodmis.org, pmladek@suse.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] seq_buf-add-seq_buf_do_printk-helper.patch removed from -mm tree
Message-Id: <20230505224521.C3D6BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: seq_buf: add seq_buf_do_printk() helper
has been removed from the -mm tree.  Its filename was
     seq_buf-add-seq_buf_do_printk-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: seq_buf: add seq_buf_do_printk() helper
Date: Sat, 15 Apr 2023 19:01:10 +0900

(akpm: temporary addition for
memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch)

Sometimes we use seq_buf to format a string buffer, which we then pass to
printk().  However, in certain situations the seq_buf string buffer can
get too big, exceeding the PRINTKRB_RECORD_MAX bytes limit, and causing
printk() to truncate the string.

Add a new seq_buf helper.  This helper prints the seq_buf string buffer
line by line, using as a delimiter, rather than passing the whole string
buffer to printk() at once.

Link: https://lkml.kernel.org/r/20230415100110.1419872-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_buf.h |    2 ++
 lib/seq_buf.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/seq_buf.h~seq_buf-add-seq_buf_do_printk-helper
+++ a/include/linux/seq_buf.h
@@ -159,4 +159,6 @@ extern int
 seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
 #endif
 
+void seq_buf_do_printk(struct seq_buf *s, const char *lvl);
+
 #endif /* _LINUX_SEQ_BUF_H */
--- a/lib/seq_buf.c~seq_buf-add-seq_buf_do_printk-helper
+++ a/lib/seq_buf.c
@@ -93,6 +93,38 @@ int seq_buf_printf(struct seq_buf *s, co
 }
 EXPORT_SYMBOL_GPL(seq_buf_printf);
 
+/**
+ * seq_buf_do_printk - printk seq_buf line by line
+ * @s: seq_buf descriptor
+ * @lvl: printk level
+ *
+ * printk()-s a multi-line sequential buffer line by line. The function
+ * makes sure that the buffer in @s is nul terminated and safe to read
+ * as a string.
+ */
+void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
+{
+	const char *start, *lf;
+
+	if (s->size == 0 || s->len == 0)
+		return;
+
+	seq_buf_terminate(s);
+
+	start = s->buffer;
+	while ((lf = strchr(start, '\n'))) {
+		int len = lf - start + 1;
+
+		printk("%s%.*s", lvl, len, start);
+		start = ++lf;
+	}
+
+	/* No trailing LF */
+	if (start < s->buffer + s->len)
+		printk("%s%s\n", lvl, start);
+}
+EXPORT_SYMBOL_GPL(seq_buf_do_printk);
+
 #ifdef CONFIG_BINARY_PRINTF
 /**
  * seq_buf_bprintf - Write the printf string from binary arguments
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


