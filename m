Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542BBC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4299D611CC
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348120AbhIIVGL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348701AbhIIVFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B92161208;
        Thu,  9 Sep 2021 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221458;
        bh=mimhEDFYoCVsiHuOzrlPbowNkZvzMIipdbizO4zY+PA=;
        h=Date:From:To:Subject:From;
        b=NhgIiJYhtbFCNEZkQFweDIsZYyPHLomOGapFTrEck8W0flKJKr1F5YS3fmUNAaVGY
         pkD/P8ZRh1rvz/IZDm49ywb6/dNcuVKk+KGZRAYWBAohBKWgh0uH98qeCRszuiVTj/
         2TOiiMAX+mN3F3J1IE1BM83cExcZFgjMpGf/bsDo=
Date:   Thu, 09 Sep 2021 14:04:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged] lib-dump_stack-correct-kernel-doc-notation.patch
 removed from -mm tree
Message-ID: <20210909210418.ECGIPXWYt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dump_stack: correct kernel-doc notation
has been removed from the -mm tree.  Its filename was
     lib-dump_stack-correct-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/dump_stack: correct kernel-doc notation

Fix kernel-doc warnings in dump_stack.c:

lib/dump_stack.c:97: warning: Function parameter or member 'log_lvl' not described in 'dump_stack_lvl'
lib/dump_stack.c:97: warning: expecting prototype for dump_stack(). Prototype was for dump_stack_lvl() instead

Link: https://lkml.kernel.org/r/20210809051643.17567-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c~lib-dump_stack-correct-kernel-doc-notation
+++ a/lib/dump_stack.c
@@ -89,7 +89,8 @@ static void __dump_stack(const char *log
 }
 
 /**
- * dump_stack - dump the current task information and its stack trace
+ * dump_stack_lvl - dump the current task information and its stack trace
+ * @log_lvl: log level
  *
  * Architectures can override this implementation by implementing its own.
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are


