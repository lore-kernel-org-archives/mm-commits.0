Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F87E936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245145AbjJDUYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244863AbjJDUXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11979102
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76700C433CA;
        Wed,  4 Oct 2023 20:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450996;
        bh=SSZF+sBqVdwuydFLxnxofm/E0JIwZ4E5GrrAtjzfZPw=;
        h=Date:To:From:Subject:From;
        b=VJoHueU4iZseQcKvfHsuJFgf7M/FsREFD7E6/1sZRxJE4tllSb61F00JiSTElADMV
         2H8OGbNxW1Rb7OUYFPZy35qGvuuG27QHkLj8yoeFzVBQBOlS6YWPioDEW9qT4kVht7
         EMhFeq7fEJK22x29z7xPgZPhnS5HRfm5b57F9m+A=
Date:   Wed, 04 Oct 2023 13:23:15 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        yuanhengzhang1214@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-correct-range-len-in-ocfs2_trim_fs.patch removed from -mm tree
Message-Id: <20231004202316.76700C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: correct range->len in ocfs2_trim_fs()
has been removed from the -mm tree.  Its filename was
     ocfs2-correct-range-len-in-ocfs2_trim_fs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Subject: ocfs2: correct range->len in ocfs2_trim_fs()
Date: Mon, 28 Aug 2023 13:17:41 +0800

global bitmap is a cluster allocator,so after we traverse the global
bitmap and finished the fstrim,the trimmed range should be 'trimmed *
clustersize'.otherwise,the trimmed range printed by 'fstrim -v' is not as
expected.

Link: https://lkml.kernel.org/r/20230828051741.204577-1-yuanhengzhang1214@gmail.com
Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-correct-range-len-in-ocfs2_trim_fs
+++ a/fs/ocfs2/alloc.c
@@ -7642,7 +7642,7 @@ out_mutex:
 		goto next_group;
 	}
 out:
-	range->len = trimmed * sb->s_blocksize;
+	range->len = trimmed * osb->s_clustersize;
 	return ret;
 }
 
_

Patches currently in -mm which might be from yuanhengzhang1214@gmail.com are


