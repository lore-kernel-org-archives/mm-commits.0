Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED8FC00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiHKAEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHKAEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:04:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6855A3C9
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCAF3B81EA9
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED62C433D6;
        Thu, 11 Aug 2022 00:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660176283;
        bh=ZgLuaHrqbBc/rSP76+ZE0o6w6ZOA1GwfQDlgByW5W/k=;
        h=Date:To:From:Subject:From;
        b=g1/x6+yT9zBXAlnP/UhgpOWRy9RTdRWWu86ofVRHSFesTcyW1naWf10FVD5cXS8p7
         /RZ0QA/hXb4xfsxdOkNLFmSLR0Q1QsIY8N0Dia2eT+f/nWIqvfC0oj2Xw/O2wwCGNf
         1cGBz39FgByjEcngQdm+ZcwZ65kTaOHkexnDh7/E=
Date:   Wed, 10 Aug 2022 17:04:42 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, klee33@uw.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch added to mm-unstable branch
Message-Id: <20220811000443.5ED62C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: use kmalloc for allocating only one element
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kenneth Lee <klee33@uw.edu>
Subject: mm/damon/dbgfs: use kmalloc for allocating only one element
Date: Mon, 8 Aug 2022 15:00:19 -0700

Use kmalloc(...) rather than kmalloc_array(1, ...) because the number of
elements we are specifying in this case is 1, kmalloc would accomplish the
same thing and we can simplify.

Link: https://lkml.kernel.org/r/20220808220019.1680469-1-klee33@uw.edu
Signed-off-by: Kenneth Lee <klee33@uw.edu>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element
+++ a/mm/damon/dbgfs.c
@@ -1041,7 +1041,7 @@ static int __init __damon_dbgfs_init(voi
 				fops[i]);
 	dbgfs_fill_ctx_dir(dbgfs_root, dbgfs_ctxs[0]);
 
-	dbgfs_dirs = kmalloc_array(1, sizeof(dbgfs_root), GFP_KERNEL);
+	dbgfs_dirs = kmalloc(sizeof(dbgfs_root), GFP_KERNEL);
 	if (!dbgfs_dirs) {
 		debugfs_remove(dbgfs_root);
 		return -ENOMEM;
_

Patches currently in -mm which might be from klee33@uw.edu are

mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch

