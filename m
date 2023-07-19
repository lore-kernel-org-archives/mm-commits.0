Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78A9C001DC
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 22:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGSW2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 18:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjGSW2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 18:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26B71FE8
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 15:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CFCC61862
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 22:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24AFC433C7;
        Wed, 19 Jul 2023 22:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689805698;
        bh=GD2mQXEp++RDZqHGp2uchYN44cIaJSP3/+lQDJp+Ly4=;
        h=Date:To:From:Subject:From;
        b=E9IS2J3J0RP6u/yBb4ySX7n4gen7okyV6Llj6iCOWcCG8T/rn/D92fT27L6YeUOrJ
         KCS6mj+rQpK5T6GNnPaZUcWbJ0gF8ckN10S2Xv0j32aFUW67RsJ/Sz9NUS43FvGsqB
         2czUwSVYsmfAz7eqGjX+73v2DvAeif+z94Xd/ubg=
Date:   Wed, 19 Jul 2023 15:28:17 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-struct_size.patch added to mm-nonmm-unstable branch
Message-Id: <20230719222818.A24AFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: Use struct_size()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-struct_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-struct_size.patch

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

ipc-sem-use-flexible-array-in-struct-sem_undo.patch
ocfs2-use-flexible-array-in-struct-ocfs2_recovery_map.patch
ocfs2-use-struct_size.patch

