Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04B8C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5671D21D79
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGufqOiX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgKMAcn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAcn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:32:43 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF5620B80;
        Fri, 13 Nov 2020 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605227563;
        bh=yyWgKBRPRegdbNENQaMYK1bpGPwcDw8vaeTPeqphzno=;
        h=Date:From:To:Subject:From;
        b=rGufqOiX1T7CdtTuktfZgbm3jNjvcHwlJQCDAjqYNN7hJSQCH9GV+gfMbbu1zOEhs
         1scy+04k/pD8jj7lEKRzFJF4H0zlPblOx5LEcEWF+lX8sCYzPmug8nGRFTVeMyIvr3
         VQ/w/opRx5yKtQU45jiRh9ZZZ5ew+9TWkmLN38jc=
Date:   Thu, 12 Nov 2020 16:32:42 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  + mm-page-flags-fix-comment.patch added to -mm tree
Message-ID: <20201113003242.H9Tm0TSwM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-flags: fix comment
has been added to the -mm tree.  Its filename is
     mm-page-flags-fix-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-flags-fix-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-flags-fix-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-flags: fix comment

We haven't had 'dontuse' flags since 2002.  Replace this obsolete warning
with a hopefully more useful one.

Link: https://lkml.kernel.org/r/20201027025823.3704-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-fix-comment
+++ a/include/linux/page-flags.h
@@ -86,8 +86,7 @@
  */
 
 /*
- * Don't use the *_dontuse flags.  Use the macros.  Otherwise you'll break
- * locked- and dirty-page accounting.
+ * Don't use the pageflags directly.  Use the PageFoo macros.
  *
  * The page flags field is split into two parts, the main flags area
  * which extends from the low bits upwards, and the fields area which
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch

