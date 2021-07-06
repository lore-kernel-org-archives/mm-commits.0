Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E8BC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF316192B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhGFTWm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhGFTWl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59DA61C7F;
        Tue,  6 Jul 2021 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599201;
        bh=0SOwH+xDw29D+mlmnobURhus8HCZnLEPsIxjy3+ME8E=;
        h=Date:From:To:Subject:From;
        b=hB7nHYAFsvc0f7yXqfQyiNbQhfZCGHrW6N5p5MXxF0jHXc7ILJseSh1uXqS/cJm5W
         hzCiRodTqoOSD7fp5jXQn682UCtGorikMZKdyYGJFv106ol4QW0cKXiVzE+S54hAGy
         euEJca/lyLzL8BP2XMheNv7DJThuxPZnnedMVQl0=
Date:   Tue, 06 Jul 2021 12:20:01 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged] mm-thp-fix-strncpy-warning.patch removed from
 -mm tree
Message-ID: <20210706192001.TVqS9mVnZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix strncpy warning
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-strncpy-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/thp: fix strncpy warning

Using MAX_INPUT_BUF_SZ as the maximum length of the string makes fortify
complain as it thinks the string might be longer than the buffer, and if
it is, we will end up with a "string" that is missing a NUL terminator. 
It's trivial to show that 'tok' points to a NUL-terminated string which is
less than MAX_INPUT_BUF_SZ in length, so we may as well just use strcpy()
and avoid the warning.

Link: https://lkml.kernel.org/r/20210615200242.1716568-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-strncpy-warning
+++ a/mm/huge_memory.c
@@ -3101,7 +3101,7 @@ static ssize_t split_huge_pages_write(st
 
 		tok = strsep(&buf, ",");
 		if (tok) {
-			strncpy(file_path, tok, MAX_INPUT_BUF_SZ);
+			strcpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch

