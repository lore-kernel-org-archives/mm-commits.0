Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F76CC6FA8B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiILD25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiILD23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF326558
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6968DB80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D33CC433D6;
        Mon, 12 Sep 2022 03:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953305;
        bh=BY4w10muJO2oIbYCLYbCGz9aQdGOEXiGgBkqKw8+0Bc=;
        h=Date:To:From:Subject:From;
        b=OkGvT9ZHHiiM3GXUBYCEL8yQ2dg7sGxleCHeCqjyA58iVSTFHwvx/HKoYVcP6f+B+
         FwB1GNLEXH30zXnfUodgI2p2wavfXXEjZxGl3V32+WwPEb4son7r6ZKv/zs3SnDa5p
         Sm4+tiVdY98IuYxqo9gTJ50lR0WnipLbNmbNMHWc=
Date:   Sun, 11 Sep 2022 20:28:24 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, klee33@uw.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch removed from -mm tree
Message-Id: <20220912032825.1D33CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/dbgfs: use kmalloc for allocating only one element
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kenneth Lee <klee33@uw.edu>
Subject: mm/damon/dbgfs: use kmalloc for allocating only one element
Date: Mon, 8 Aug 2022 15:00:19 -0700

Use kmalloc(...) rather than kmalloc_array(1, ...) because the number of
elements we are specifying in this case is 1, kmalloc would accomplish the
same thing and we can simplify.

Link: https://lkml.kernel.org/r/20220808220019.1680469-1-klee33@uw.edu
Signed-off-by: Kenneth Lee <klee33@uw.edu>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-kmalloc-for-allocating-only-one-element
+++ a/mm/damon/dbgfs.c
@@ -1044,7 +1044,7 @@ static int __init __damon_dbgfs_init(voi
 				fops[i]);
 	dbgfs_fill_ctx_dir(dbgfs_root, dbgfs_ctxs[0]);
 
-	dbgfs_dirs = kmalloc_array(1, sizeof(dbgfs_root), GFP_KERNEL);
+	dbgfs_dirs = kmalloc(sizeof(dbgfs_root), GFP_KERNEL);
 	if (!dbgfs_dirs) {
 		debugfs_remove(dbgfs_root);
 		return -ENOMEM;
_

Patches currently in -mm which might be from klee33@uw.edu are


