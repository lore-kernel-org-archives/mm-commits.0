Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7225EC433E9
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 20:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F15364ECE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 20:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhBIUJK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 15:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhBITyP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 14:54:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF6664ED4;
        Tue,  9 Feb 2021 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612898907;
        bh=vTHgCI0C2j3+WelfYXcB/XIkIgYHFl4KbBCBCqHAHto=;
        h=Date:From:To:Subject:From;
        b=fNn8Qd1/eRlSmKUrPVkEdwPoL1n15ECuAt3FZIKqusMAIYWx86CQ5hMyQF24uig0Z
         2y5TKSTKpDMMfMYlGspnUpGpvCXB+fXMlkS+9YrlMGsYoU/V8eQS3hCuZhB3G1Id+0
         66RfXLOKoFnYGV42KB4tsMECd8YtKCNxzNO7PeWg=
Date:   Tue, 09 Feb 2021 11:28:26 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  + mm-backing-dev-remove-duplicated-macro-definition.patch
 added to -mm tree
Message-ID: <20210209192826.RMJ4CTwx3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: backing-dev: Remove duplicated macro definition
has been added to the -mm tree.  Its filename is
     mm-backing-dev-remove-duplicated-macro-definition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-backing-dev-remove-duplicated-macro-definition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-backing-dev-remove-duplicated-macro-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: backing-dev: Remove duplicated macro definition

Move the K() macro a little forward to remove the same macro definition.

Link: https://lkml.kernel.org/r/d1ccdf2d3116dce9814f2bcc1f0415ecb4c76ea5.1612862230.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-remove-duplicated-macro-definition
+++ a/mm/backing-dev.c
@@ -32,6 +32,8 @@ LIST_HEAD(bdi_list);
 /* bdi_wq serves all asynchronous writeback tasks */
 struct workqueue_struct *bdi_wq;
 
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -69,7 +71,6 @@ static int bdi_debug_stats_show(struct s
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 	wb_thresh = wb_calc_thresh(wb, dirty_thresh);
 
-#define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
 		   "BdiWriteback:       %10lu kB\n"
 		   "BdiReclaimable:     %10lu kB\n"
@@ -98,7 +99,6 @@ static int bdi_debug_stats_show(struct s
 		   nr_more_io,
 		   nr_dirty_time,
 		   !list_empty(&bdi->bdi_list), bdi->wb.state);
-#undef K
 
 	return 0;
 }
@@ -146,8 +146,6 @@ static ssize_t read_ahead_kb_store(struc
 	return count;
 }
 
-#define K(pages) ((pages) << (PAGE_SHIFT - 10))
-
 #define BDI_SHOW(name, expr)						\
 static ssize_t name##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *buf)	\
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-remove-unused-parameter-and-change-to-void-type-for-replace_page_cache_page.patch
mm-backing-dev-remove-duplicated-macro-definition.patch

