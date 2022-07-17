Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B99C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiGQEh6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiGQEh5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:37:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BCE22285
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D3A8B80D2A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49EBC3411E;
        Sun, 17 Jul 2022 04:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032673;
        bh=dJZIqAczUq0saSEd/DhplcIErKltctJuYgoRyFDOGJo=;
        h=Date:To:From:Subject:From;
        b=cgUfeiy7Ynkwo6xUkbpYl6G0qIAyDztdWodNh3PQmzpHpX0SnTvZwGBA0IYj+40G1
         N6Mk6pUz6ey4GQ2UYNyj7bkOg5mCxN0iY2UmvGARTu2ku1DgIoChw+Y6TcXV/njIUO
         jBXEKxuvHg+bEOW+VwGElcVDv+srIESMIBek74n8=
Date:   Sat, 16 Jul 2022 21:37:53 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, luomeng12@huawei.com, hughd@google.com,
        chengzhihao1@huawei.com, wangzhaolong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tmpfs-fix-the-issue-that-the-mount-and-remount-results-are-inconsistent.patch removed from -mm tree
Message-Id: <20220717043753.C49EBC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: fix the issue that the mount and remount results are inconsistent.
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-the-issue-that-the-mount-and-remount-results-are-inconsistent.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhaoLong Wang <wangzhaolong1@huawei.com>
Subject: tmpfs: fix the issue that the mount and remount results are inconsistent.
Date: Wed, 29 Jun 2022 20:43:24 +0800

An undefined-behavior issue has not been completely fixed since commit
d14f5efadd84 ("tmpfs: fix undefined-behaviour in shmem_reconfigure()"). 
In the commit, check in the shmem_reconfigure() is added in remount
process to avoid the Ubsan problem.  However, the check is not added to
the mount process.  It causes inconsistent results between mount and
remount.  The operations to reproduce the problem in user mode as follows:

If nr_blocks is set to 0x8000000000000000, the mounting is successful.

  # mount tmpfs /dev/shm/ -t tmpfs -o nr_blocks=0x8000000000000000

However, when -o remount is used, the mount fails because of the
check in the shmem_reconfigure()

  # mount tmpfs /dev/shm/ -t tmpfs -o remount,nr_blocks=0x8000000000000000
  mount: /dev/shm: mount point not mounted or bad option.

Therefore, add checks in the shmem_parse_one() function and remove the
check in shmem_reconfigure() to avoid this problem.

Link: https://lkml.kernel.org/r/20220629124324.1640807-1-wangzhaolong1@huawei.com
Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Cc: Luo Meng <luomeng12@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~tmpfs-fix-the-issue-that-the-mount-and-remount-results-are-inconsistent
+++ a/mm/shmem.c
@@ -3392,7 +3392,7 @@ static int shmem_parse_one(struct fs_con
 		break;
 	case Opt_nr_blocks:
 		ctx->blocks = memparse(param->string, &rest);
-		if (*rest)
+		if (*rest || ctx->blocks > S64_MAX)
 			goto bad_value;
 		ctx->seen |= SHMEM_SEEN_BLOCKS;
 		break;
@@ -3514,10 +3514,7 @@ static int shmem_reconfigure(struct fs_c
 
 	raw_spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (ctx->blocks > S64_MAX) {
-		err = "Number of blocks too large";
-		goto out;
-	}
+
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
 		if (!sbinfo->max_blocks) {
 			err = "Cannot retroactively limit size";
_

Patches currently in -mm which might be from wangzhaolong1@huawei.com are


