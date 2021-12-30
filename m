Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EBEC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Dec 2021 00:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhL3AFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 19:05:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhL3AFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 19:05:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABEF961579
        for <mm-commits@vger.kernel.org>; Thu, 30 Dec 2021 00:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF345C36AEA;
        Thu, 30 Dec 2021 00:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640822709;
        bh=PUUd3F30nFS4Yh5mU3y1VgWpjvV5jeKrN5dD9aiNORs=;
        h=Date:From:To:Subject:From;
        b=mcYskElwtvafIerYn/bLjpNZsFWmjMDan7F8IJdzqMIlZ+Ob6LJ2QS5596kOSHCLA
         ABuBz6igGm+4PJWg5hkggtfp4VvukF5mY3Ij0zVyrEHNCfiqEfz+FvCaBhzRvyc1TL
         mAGJ41ehLuJqHcTLoSu118h5rCnWtICOHWU0MstA=
Date:   Wed, 29 Dec 2021 16:05:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        colin.i.king@gmail.com
Subject:  +
 ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch added to -mm tree
Message-ID: <20211230000507.OxzIc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to pointer root_bh
has been added to the -mm tree.  Its filename is
     ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: ocfs2: remove redundant assignment to pointer root_bh

Pointer root_bh is being initialized with a value that is not read, it is
being re-assigned later on closer to its use.  The early initialization is
redundant and can be removed.

Link: https://lkml.kernel.org/r/20211228013719.620923-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-redundant-assignment-to-pointer-root_bh
+++ a/fs/ocfs2/alloc.c
@@ -2040,7 +2040,7 @@ static void ocfs2_complete_edge_insert(h
 	int i, idx;
 	struct ocfs2_extent_list *el, *left_el, *right_el;
 	struct ocfs2_extent_rec *left_rec, *right_rec;
-	struct buffer_head *root_bh = left_path->p_node[subtree_index].bh;
+	struct buffer_head *root_bh;
 
 	/*
 	 * Update the counts and position values within all the
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch
mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
nilfs2-remove-redundant-pointer-sbufs.patch
kernel-sysctlc-remove-unused-variable-ten_thousand.patch

