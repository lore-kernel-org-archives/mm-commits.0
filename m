Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9B5C001B0
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 22:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjGSW2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 18:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGSW2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 18:28:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2C3E5
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 15:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F66616AF
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 22:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9DEC433C7;
        Wed, 19 Jul 2023 22:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689805695;
        bh=iELWoS19uk5LIMhHaeYKxKkkPdhE+MNdW+eiw/4x9Tw=;
        h=Date:To:From:Subject:From;
        b=2ZTLzklmGbHIBq+xeq3rZLVtRJLbr6cebEzHPhHPaLkVKKTvs7DlGHaxNn7m07XAN
         xSu7BPMudOaFaizWUYtqKlisXNblA1RO8bcru0gTMhPdlQ6/d29P7XeBXmdwpEf4ma
         fZy3/ehJb/kB/u7j/ArJFpQQJ49wBjgedUVH5GQg=
Date:   Wed, 19 Jul 2023 15:28:15 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch added to mm-nonmm-unstable branch
Message-Id: <20230719222815.AC9DEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use flexible array in 'struct ocfs2_recovery_map'
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ipc-sem-use-flexible-array-in-struct-sem_undo.patch
ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch
ocfs2-use-struct_size.patch

