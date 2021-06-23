Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AADAC48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 23:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E38611CE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 23:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFWX5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 19:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWX5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 19:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A4C6611CB;
        Wed, 23 Jun 2021 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624492530;
        bh=cTCPckUi/zlKw/7yyY2jS4EuPjNT1IRFErWAoUFIzfs=;
        h=Date:From:To:Subject:From;
        b=vNqZ0tdXYA4zCk54MSSjDmY9zQU+aFu0fSOquqUoN+zdqxKYxD+GkA1iE3NGiEz+Z
         xbLYwgQ9EjlioGqJKJBYI8NWE+Z6u+Qmuv9eWid0FibH+xN6asz/MmPcc7C4g3foOo
         b/cp9sdOcwHKIwS2iSyGVvqM8uQRUQr/OC5F0PQ4=
Date:   Wed, 23 Jun 2021 16:55:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  + hfsplus-remove-unnecessary-oom-message.patch added to
 -mm tree
Message-ID: <20210623235530.KdvkNJpWL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove unnecessary oom message
has been added to the -mm tree.  Its filename is
     hfsplus-remove-unnecessary-oom-message.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hfsplus-remove-unnecessary-oom-message.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-remove-unnecessary-oom-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: hfsplus: remove unnecessary oom message

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Link: https://lkml.kernel.org/r/20210617084944.1279-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hfsplus/xattr.c~hfsplus-remove-unnecessary-oom-message
+++ a/fs/hfsplus/xattr.c
@@ -204,7 +204,6 @@ check_attr_tree_state_again:
 
 	buf = kzalloc(node_size, GFP_NOFS);
 	if (!buf) {
-		pr_err("failed to allocate memory for header node\n");
 		err = -ENOMEM;
 		goto end_attr_file_creation;
 	}
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-clear-spelling-mistakes.patch
lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch
lib-decompressors-fix-spelling-mistakes.patch
lib-mpi-fix-spelling-mistakes.patch
hfsplus-remove-unnecessary-oom-message.patch
lib-test-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes-in-header-files.patch
mm-fix-spelling-mistakes-in-header-files.patch

