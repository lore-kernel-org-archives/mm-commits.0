Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23523C04FDF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjHLWGL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjHLWFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF0B198E
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 141C260BFC
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990CC433C8;
        Sat, 12 Aug 2023 22:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877951;
        bh=VRXQ7qXJVdmSNk/NYiSq6ps25t0NZxvlN15hMdxpolY=;
        h=Date:To:From:Subject:From;
        b=umN/rHmUDsUon65a8hLFwE/s3ZH6b2AOYk8XWl/rzdbZ6zTe+54rkvBMgg99ACjHu
         BnsIMswIJguZzzXpCtiy2JUpBwWcj4MAi6jJiJLl6o3NWS43MpMAF4KjA5EkC4/LG5
         a8xWeB1ULMJDCaE1cdmRuYajJm8ITGn+oJpcb3l0=
Date:   Sat, 12 Aug 2023 15:05:50 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch removed from -mm tree
Message-Id: <20230812220551.6990CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: use flexible array in 'struct ocfs2_recovery_map'
has been removed from the -mm tree.  Its filename was
     ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: use flexible array in 'struct ocfs2_recovery_map'
Date: Sun, 16 Jul 2023 20:48:56 +0200

Turn 'rm_entries' in 'struct ocfs2_recovery_map' into a flexible array.

The advantages are:
   - save the size of a pointer when the new undo structure is allocated
   - avoid some always ugly pointer arithmetic to get the address of
    'rm_entries'
   - avoid an indirection when the array is accessed

While at it, use struct_size() to compute the size of the new undo
structure.

Link: https://lkml.kernel.org/r/c645911ffd2720fce5e344c17de642518cd0db52.1689533270.git.christophe.jaillet@wanadoo.fr
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

 fs/ocfs2/journal.c |    5 +----
 fs/ocfs2/journal.h |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map
+++ a/fs/ocfs2/journal.c
@@ -178,16 +178,13 @@ int ocfs2_recovery_init(struct ocfs2_sup
 	osb->recovery_thread_task = NULL;
 	init_waitqueue_head(&osb->recovery_event);
 
-	rm = kzalloc(sizeof(struct ocfs2_recovery_map) +
-		     osb->max_slots * sizeof(unsigned int),
+	rm = kzalloc(struct_size(rm, rm_entries, osb->max_slots),
 		     GFP_KERNEL);
 	if (!rm) {
 		mlog_errno(-ENOMEM);
 		return -ENOMEM;
 	}
 
-	rm->rm_entries = (unsigned int *)((char *)rm +
-					  sizeof(struct ocfs2_recovery_map));
 	osb->recovery_map = rm;
 
 	return 0;
--- a/fs/ocfs2/journal.h~ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map
+++ a/fs/ocfs2/journal.h
@@ -29,7 +29,7 @@ struct ocfs2_dinode;
 
 struct ocfs2_recovery_map {
 	unsigned int rm_used;
-	unsigned int *rm_entries;
+	unsigned int rm_entries[];
 };
 
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


