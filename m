Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3E2C43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiGYTdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiGYTdI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:33:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA8813EB6
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B8A61045
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C270C341C8;
        Mon, 25 Jul 2022 19:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658777586;
        bh=vZuZod/YAMfrkTdd95/SQKpPHjDLIPFhfgpZyTHOHMY=;
        h=Date:To:From:Subject:From;
        b=uJXkk1kfrAAGn7/LkYm5pOHqUO78LwoMzbd6Gx7PmM0GVIQs4v4g7kn+c0JJXw819
         M5TD2ecTngmYhlNxgY36adkj4utZsrDQguxmlxBhNUyEyP9MVqjtSwnoSdO/DapqzZ
         DLjPjR/FP+oWPCrITWK9ZqKuPrkuTFPYkKersQSY=
Date:   Mon, 25 Jul 2022 12:33:05 -0700
To:     mm-commits@vger.kernel.org, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-the-bitmap-api-to-simplify-code.patch added to mm-nonmm-unstable branch
Message-Id: <20220725193306.5C270C341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use the bitmap API to simplify code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-the-bitmap-api-to-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-the-bitmap-api-to-simplify-code.patch

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
Subject: ocfs2: use the bitmap API to simplify code
Date: Thu, 21 Jul 2022 22:49:37 +0200

Use bitmap_zero() instead of hand-writing it.  It is less verbose.

While at it, add an explicit #include <linux/bitmap.h>.

Link: https://lkml.kernel.org/r/86d2a027c319db12055c98f00c65f7d01e703722.1658436259.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/heartbeat.c~ocfs2-use-the-bitmap-api-to-simplify-code
+++ a/fs/ocfs2/heartbeat.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
  */
 
+#include <linux/bitmap.h>
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/highmem.h>
@@ -29,8 +30,7 @@
 static void ocfs2_node_map_init(struct ocfs2_node_map *map)
 {
 	map->num_nodes = OCFS2_NODE_MAP_MAX_NODES;
-	memset(map->map, 0, BITS_TO_LONGS(OCFS2_NODE_MAP_MAX_NODES) *
-	       sizeof(unsigned long));
+	bitmap_zero(map->map, OCFS2_NODE_MAP_MAX_NODES);
 }
 
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

ocfs2-remove-some-useless-functions.patch
ocfs2-use-the-bitmap-api-to-simplify-code.patch
ocfs2-fix-a-typo-in-a-comment.patch

