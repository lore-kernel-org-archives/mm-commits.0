Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB0AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A9E61184
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbhJOTc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238365AbhJOTc6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F3061151;
        Fri, 15 Oct 2021 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634326251;
        bh=8aG7CHlRxTVlpxc1/Tj2G9oSJkIprBsmHeO1KxWfbcc=;
        h=Date:From:To:Subject:From;
        b=cUyYbX35hrdYa5Dfo+8fM0SoN2fCzXCwyHhRER3mjtxDJiakTV90VzB8x78qNN2ij
         R+Q3XXUUYnSCyRm5FUsESatTcZHEpweqXduJYg6dOUEloP7rQ65sH07KtZYaDhllmY
         MBi0LigjwJ0/pgrgVGxoMvWwy6fZkflqupbBlsmM=
Date:   Fri, 15 Oct 2021 12:30:51 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allo?=
 =?US-ASCII?Q?cation-by-kvmalloc-fix.patch?= added to -mm tree
Message-ID: <20211015193051.opsa--aOi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: fix spelling mistake and grammar in pr_err message
has been added to the -mm tree.  Its filename is
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/stackdepot: fix spelling mistake and grammar in pr_err message

There is a spelling mistake of the work allocation so fix this and
re-phrase the message to make it easier to read.

Link: https://lkml.kernel.org/r/20211015104159.11282-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix
+++ a/lib/stackdepot.c
@@ -186,7 +186,7 @@ __ref int stack_depot_init(void)
 			for (i = 0; i < STACK_HASH_SIZE;  i++)
 				stack_table[i] = NULL;
 		} else {
-			pr_err("Stack Depot failed hash table allocationg, disabling\n");
+			pr_err("Stack Depot hash table allocation failed, disabling\n");
 			stack_depot_disable = true;
 			mutex_unlock(&stack_depot_init_mutex);
 			return -ENOMEM;
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch
mm-damon-core-nullify-pointer-ctx-kdamond-with-a-null.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

