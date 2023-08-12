Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771DBC04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjHLWGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjHLWFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF821992
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E16620CD
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79618C433C7;
        Sat, 12 Aug 2023 22:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877952;
        bh=ceMfjN5j4fD93WU7cwv1065iElHBzwQO57plmC5HBe4=;
        h=Date:To:From:Subject:From;
        b=MiIy7y5zFVi8yNMy51aY4ZXyVbue+rRffaBLTtfHwlmxoI0EH4MwC5RtCpHpZmzg0
         D16F7W6vckjrDjVt0HUHsSrBwwc0KA3rx4bEkEUSb+ehTiknzAeoj2jfTyKEgD+bh+
         IDR2BqWE8cZk3i9hhvRi+bFsddiqmFQEuDSyzBqg=
Date:   Sat, 12 Aug 2023 15:05:51 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-struct_size.patch removed from -mm tree
Message-Id: <20230812220552.79618C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: Use struct_size()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-struct_size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: Use struct_size()
Date: Sun, 16 Jul 2023 20:48:57 +0200

Use struct_size() instead of hand-writing it, when allocating a structure
with a flex array.

This is less verbose.

Link: https://lkml.kernel.org/r/9d99ea2090739f816d0dc0c4ebaa42b26fc48a9e.1689533270.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-use-struct_size
+++ a/fs/ocfs2/journal.c
@@ -114,9 +114,9 @@ int ocfs2_compute_replay_slots(struct oc
 	if (osb->replay_map)
 		return 0;
 
-	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
-			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
-
+	replay_map = kzalloc(struct_size(replay_map, rm_replay_slots,
+					 osb->max_slots),
+			     GFP_KERNEL);
 	if (!replay_map) {
 		mlog_errno(-ENOMEM);
 		return -ENOMEM;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


