Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52ADC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6640F64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhBYTWq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234637AbhBYTUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC5064F55;
        Thu, 25 Feb 2021 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280412;
        bh=JbsGcw7pGSvkl5c4rOFOLQBSPYp8pNT+E/lmwpUn8EA=;
        h=Date:From:To:Subject:From;
        b=XvXgyNDnKWOcHFk04OF4nHoFwEOZz429D9eJl8MfWJxwm7xrPN1Id23Uuwkg8eb68
         jGCvwt3/lJMheIbtfEQn8N+VpLd7vIpmRigbcLFSRMxKOJrPI4MIb7bf8wAm7LoMkq
         BipWUbBLrnUqCYcxFJ6z8Y2hiQbEa2gSi9Thtf/g=
Date:   Thu, 25 Feb 2021 11:13:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-backing-dev-remove-duplicated-macro-definition.patch removed from -mm
 tree
Message-ID: <20210225191332.KC8AHR5-_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: backing-dev: Remove duplicated macro definition
has been removed from the -mm tree.  Its filename was
     mm-backing-dev-remove-duplicated-macro-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


