Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED95EC19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiG3BNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbiG3BNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAAA8AECA
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AF4561D48
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E280C433C1;
        Sat, 30 Jul 2022 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143598;
        bh=ywZZD8nLg7NNsASGPNbpxRnGjKEB989dsG3FUnkFuJ4=;
        h=Date:To:From:Subject:From;
        b=jBNWA1znTX7Ad9NXwMcPsVnoah84xzLcVBcewkXIbFwsW0QyvObcZsbW2y3Lt96fg
         zw+sarT6N2huQlwZd9QCXJWMywgykepQ2CoT3J1/My7cbfaC+CJVx2krFsyww0ButZ
         LupaH2Kv8b4nbE/oPLOQh5F/a4UgxKfYBx2cltg4=
Date:   Fri, 29 Jul 2022 18:13:18 -0700
To:     mm-commits@vger.kernel.org, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-the-bitmap-api-to-simplify-code.patch removed from -mm tree
Message-Id: <20220730011318.9E280C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: use the bitmap API to simplify code
has been removed from the -mm tree.  Its filename was
     ocfs2-use-the-bitmap-api-to-simplify-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


