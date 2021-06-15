Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34EFC49EBB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C403E61246
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFOWxB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhFOWxA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 18:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60A56128C;
        Tue, 15 Jun 2021 22:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623797454;
        bh=0ZvExTZxrvpgpGLnKlbjFjnPgNRSGbmWLLzbLlYC/zE=;
        h=Date:From:To:Subject:From;
        b=xxAvt+DCEeRHzMvGgytWBppR4hekulpULZZxg2x3fpfcfLcfznRbKqruo6VyKCwg/
         DwkMKnjLUm8+ruazY7CDd4oJYgQTs4IE1WxqYGuWJysYco+Fz6AbUULOGtDPFWvnC8
         1fQuRpHsaqY2Jdbg972hZBAp63KY3Yntf+JNcxAs=
Date:   Tue, 15 Jun 2021 15:50:54 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-thp-fix-strncpy-warning.patch added to -mm tree
Message-ID: <20210615225054.4SJsF--NC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix strncpy warning
has been added to the -mm tree.  Its filename is
     mm-thp-fix-strncpy-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-strncpy-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-strncpy-warning.patch

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
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-thp-fix-strncpy-warning.patch

