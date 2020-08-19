Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39496C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E3F207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865504;
	bh=qO60lZU84ZYh82b1RW+YP/Qdn7ItMxS0MFIwkYmJgWg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hylnRjSJrpBVAT4oyKaYeebztHqjLLzIyJBhxE9Mh1pwoXcQaEqg3Gan81Rq5y1ym
	 17UYeZh3f8QHzHOO68ONT/5srLLiAxB7SU9b7fFZ+esB8T6OO7/gK0IAPP+FEFTtEA
	 NKQxTc5c1oPhDOS5quAvU+2czQhl9dVqmJc09lqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSTbn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHSTbm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:31:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3225207BB;
        Wed, 19 Aug 2020 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865502;
        bh=qO60lZU84ZYh82b1RW+YP/Qdn7ItMxS0MFIwkYmJgWg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RmxpGAtbb0R77fBjpCXC4TZ6A932BD14dxoHG4u01M+UfBElE/FpNBwyGBrZ83SzX
         qYyTZqSCo+o1fJxFFbOWHHzrPORP1lpQHfAJgCFfgcZmoeeMc5F2Qzy7ZmDTWk0HW9
         IFKTdykhkc/2z99M/FrLC1b6tEFHcxhTkWrQsvU8=
Date:   Wed, 19 Aug 2020 12:31:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + fs-ocfs2-delete-repeated-words-in-comments.patch added
 to -mm tree
Message-ID: <20200819193141.wdxGSFByN%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delete repeated words in comments
has been added to the -mm tree.  Its filename is
     fs-ocfs2-delete-repeated-words-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-delete-repeated-words-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-delete-repeated-words-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ocfs2: delete repeated words in comments

Drop duplicated words {the, and} in comments.

Link: https://lkml.kernel.org/r/20200811021845.25134-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c      |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/alloc.c~fs-ocfs2-delete-repeated-words-in-comments
+++ a/fs/ocfs2/alloc.c
@@ -6013,7 +6013,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out;
 	}
 
-	/* Appending truncate log(TA) and and flushing truncate log(TF) are
+	/* Appending truncate log(TA) and flushing truncate log(TF) are
 	 * two separated transactions. They can be both committed but not
 	 * checkpointed. If crash occurs then, both two transaction will be
 	 * replayed with several already released to global bitmap clusters.
--- a/fs/ocfs2/localalloc.c~fs-ocfs2-delete-repeated-words-in-comments
+++ a/fs/ocfs2/localalloc.c
@@ -677,7 +677,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 		/*
 		 * Under certain conditions, the window slide code
 		 * might have reduced the number of bits available or
-		 * disabled the the local alloc entirely. Re-check
+		 * disabled the local alloc entirely. Re-check
 		 * here and return -ENOSPC if necessary.
 		 */
 		status = -ENOSPC;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch

