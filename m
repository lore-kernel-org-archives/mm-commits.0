Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2F5C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiG3BNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiG3BN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583BC8AECC
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E856FB82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CF1C433D6;
        Sat, 30 Jul 2022 01:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143597;
        bh=DgIusb1h79FzBKETRrRcFJWV8SgoNkbCHqOoG7NEQb0=;
        h=Date:To:From:Subject:From;
        b=LaFrHj0QPfwcYyUR1gXsTymFKGqpMOh1HYDCWBqFK4UVmi3F9sSgUyjCYmFmNpbF7
         J5J/Ft1om3sGUgqbL0l6SPd/orQU0Jzgmj6JRqOyZE8NdiO8/12FdP72wWCA9jecRS
         EkAYzNZUYo/lgdSGOylHWHB1PHgDwzzeoJey7PUI=
Date:   Fri, 29 Jul 2022 18:13:16 -0700
To:     mm-commits@vger.kernel.org, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-some-useless-functions.patch removed from -mm tree
Message-Id: <20220730011317.83CF1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: remove some useless functions
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-some-useless-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: remove some useless functions
Date: Thu, 21 Jul 2022 22:49:25 +0200

Patch series "ocfs2: A few clean_ups", v2.

__ocfs2_node_map_set_bit() and __ocfs2_node_map_clear_bit() are just
wrapper around set_bit() and clear_bit().

The leading __ also makes think that these functions are non-atomic just
like __set_bit() and __clear_bit().

So, just remove these wrappers and call set_bit() and clear_bit()
directly.

Link: https://lkml.kernel.org/r/cover.1658436259.git.christophe.jaillet@wanadoo.fr
Link: https://lkml.kernel.org/r/bd1429c84ec7d174c96dbb67a2b42b1b456d9394.1658436259.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/heartbeat.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/fs/ocfs2/heartbeat.c~ocfs2-remove-some-useless-functions
+++ a/fs/ocfs2/heartbeat.c
@@ -24,11 +24,6 @@
 
 #include "buffer_head_io.h"
 
-static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
-					    int bit);
-static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
-					      int bit);
-
 /* special case -1 for now
  * TODO: should *really* make sure the calling func never passes -1!!  */
 static void ocfs2_node_map_init(struct ocfs2_node_map *map)
@@ -65,12 +60,6 @@ void ocfs2_do_node_down(int node_num, vo
 	ocfs2_recovery_thread(osb, node_num);
 }
 
-static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
-					    int bit)
-{
-	set_bit(bit, map->map);
-}
-
 void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
 			    struct ocfs2_node_map *map,
 			    int bit)
@@ -79,16 +68,10 @@ void ocfs2_node_map_set_bit(struct ocfs2
 		return;
 	BUG_ON(bit >= map->num_nodes);
 	spin_lock(&osb->node_map_lock);
-	__ocfs2_node_map_set_bit(map, bit);
+	set_bit(bit, map->map);
 	spin_unlock(&osb->node_map_lock);
 }
 
-static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
-					      int bit)
-{
-	clear_bit(bit, map->map);
-}
-
 void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
 			      struct ocfs2_node_map *map,
 			      int bit)
@@ -97,7 +80,7 @@ void ocfs2_node_map_clear_bit(struct ocf
 		return;
 	BUG_ON(bit >= map->num_nodes);
 	spin_lock(&osb->node_map_lock);
-	__ocfs2_node_map_clear_bit(map, bit);
+	clear_bit(bit, map->map);
 	spin_unlock(&osb->node_map_lock);
 }
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


