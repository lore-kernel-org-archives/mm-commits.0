Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D69C56201
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEA920781
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxfDUWcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgKJVEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJVEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:04:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F532074B;
        Tue, 10 Nov 2020 21:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605042293;
        bh=dXdbFTmxIQ4UHIZ6aIyXM8sWTxGt653147zbXUX7/Z8=;
        h=Date:From:To:Subject:From;
        b=DxfDUWcO+lSLXD/mLePJADGRuDYNEIv2pgSVuJRKh+uoyVvLCO6iqqdNRTaiCsR0Q
         10gOCkPaPk3fSwQNsNUdESEPWIxdo8z8X8JuRKpAN1go7yN51w1Pnq+zpozhLiK0MO
         AGolP5iTeitqeVBJ8GZE19HmR7BhgKPppQk+H4+w=
Date:   Tue, 10 Nov 2020 13:04:52 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        wen.gang.wang@oracle.com
Subject:  + ocfs2-initialize-ip_next_orphan.patch added to -mm tree
Message-ID: <20201110210452.ZfQIEtxhx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: initialize ip_next_orphan
has been added to the -mm tree.  Its filename is
     ocfs2-initialize-ip_next_orphan.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-initialize-ip_next_orphan.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-initialize-ip_next_orphan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: initialize ip_next_orphan

Though problem if found on a lower 4.1.12 kernel, I think upstream has
same issue.

In one node in the cluster, there is the following callback trace:

# cat /proc/21473/stack
[<ffffffffc09a2f06>] __ocfs2_cluster_lock.isra.36+0x336/0x9e0 [ocfs2]
[<ffffffffc09a4481>] ocfs2_inode_lock_full_nested+0x121/0x520 [ocfs2]
[<ffffffffc09b2ce2>] ocfs2_evict_inode+0x152/0x820 [ocfs2]
[<ffffffff8122b36e>] evict+0xae/0x1a0
[<ffffffff8122bd26>] iput+0x1c6/0x230
[<ffffffffc09b60ed>] ocfs2_orphan_filldir+0x5d/0x100 [ocfs2]
[<ffffffffc0992ae0>] ocfs2_dir_foreach_blk+0x490/0x4f0 [ocfs2]
[<ffffffffc099a1e9>] ocfs2_dir_foreach+0x29/0x30 [ocfs2]
[<ffffffffc09b7716>] ocfs2_recover_orphans+0x1b6/0x9a0 [ocfs2]
[<ffffffffc09b9b4e>] ocfs2_complete_recovery+0x1de/0x5c0 [ocfs2]
[<ffffffff810a1399>] process_one_work+0x169/0x4a0
[<ffffffff810a1bcb>] worker_thread+0x5b/0x560
[<ffffffff810a7a2b>] kthread+0xcb/0xf0
[<ffffffff816f5d21>] ret_from_fork+0x61/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

The above stack is not reasonable, the final iput shouldn't happen in
ocfs2_orphan_filldir() function. Looking at the code,

2067         /* Skip inodes which are already added to recover list, since dio may
2068          * happen concurrently with unlink/rename */
2069         if (OCFS2_I(iter)->ip_next_orphan) {
2070                 iput(iter);
2071                 return 0;
2072         }
2073

The logic thinks the inode is already in recover list on seeing
ip_next_orphan is non-NULL, so it skip this inode after dropping a
reference which incremented in ocfs2_iget().

While, if the inode is already in recover list, it should have another
reference and the iput() at line 2070 should not be the final iput
(dropping the last reference).  So I don't think the inode is really in
the recover list (no vmcore to confirm).

Note that ocfs2_queue_orphans(), though not shown up in the call back
trace, is holding cluster lock on the orphan directory when looking up for
unlinked inodes.  The on disk inode eviction could involve a lot of IOs
which may need long time to finish.  That means this node could hold the
cluster lock for very long time, that can lead to the lock requests (from
other nodes) to the orhpan directory hang for long time.

Looking at more on ip_next_orphan, I found it's not initialized when
allocating a new ocfs2_inode_info structure.

Fix: initialize ip_next_orphan as NULL.

Link: https://lkml.kernel.org/r/20201109171746.27884-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/super.c~ocfs2-initialize-ip_next_orphan
+++ a/fs/ocfs2/super.c
@@ -1713,6 +1713,7 @@ static void ocfs2_inode_init_once(void *
 
 	oi->ip_blkno = 0ULL;
 	oi->ip_clusters = 0;
+	oi->ip_next_orphan = NULL;
 
 	ocfs2_resv_init_once(&oi->ip_la_data_resv);
 
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-initialize-ip_next_orphan.patch

