Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DACC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiLAAGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLAAEb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACCC8FD5D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B30B81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CEEC433D6;
        Thu,  1 Dec 2022 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852915;
        bh=RpYXSgkEQa9lkIbxrY1/t74bXl3u5qZ+vfiXwyPGBuY=;
        h=Date:To:From:Subject:From;
        b=g4ohfdjPIq/U6mY2dvlZVkb4CSFHD60WQHgeJoOW/6wR97CmXqMDkpMml9SjvNFbj
         Ivxdc1ntimd2IRlHyLaRCH4/OULXAkx4e6vtpoHygfWSdUS2wCQtcO3Gwxp9wuyr8A
         8Ra9nm+whSdSOASJ5HBmT3s/gldrYz+4Pi/IVvvM=
Date:   Wed, 30 Nov 2022 16:01:55 -0800
To:     mm-commits@vger.kernel.org, you.zhou@intel.com,
        vdavydov.dev@gmail.com, shakeelb@google.com, pengfei.xu@intel.com,
        jack@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch removed from -mm tree
Message-Id: <20221201000155.A8CEEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make drop_caches keep reclaiming on all nodes
has been removed from the -mm tree.  Its filename was
     mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: make drop_caches keep reclaiming on all nodes
Date: Tue, 15 Nov 2022 13:32:55 +0100

Currently, drop_caches are reclaiming node-by-node, looping on each node
until reclaim could not make progress.  This can however leave quite some
slab entries (such as filesystem inodes) unreclaimed if objects say on
node 1 keep objects on node 0 pinned.  So move the "loop until no
progress" loop to the node-by-node iteration to retry reclaim also on
other nodes if reclaim on some nodes made progress.  This fixes problem
when drop_caches was not reclaiming lots of otherwise perfectly fine to
reclaim inodes.

Link: https://lkml.kernel.org/r/20221115123255.12559-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: You Zhou <you.zhou@intel.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/mm/vmscan.c~mm-make-drop_caches-keep-reclaiming-on-all-nodes
+++ a/mm/vmscan.c
@@ -1021,31 +1021,34 @@ out:
 	return freed;
 }
 
-static void drop_slab_node(int nid)
+static unsigned long drop_slab_node(int nid)
 {
-	unsigned long freed;
-	int shift = 0;
+	unsigned long freed = 0;
+	struct mem_cgroup *memcg = NULL;
 
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		struct mem_cgroup *memcg = NULL;
-
-		if (fatal_signal_pending(current))
-			return;
+		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-		freed = 0;
-		memcg = mem_cgroup_iter(NULL, NULL, NULL);
-		do {
-			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
-		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-	} while ((freed >> shift++) > 1);
+	return freed;
 }
 
 void drop_slab(void)
 {
 	int nid;
+	int shift = 0;
+	unsigned long freed;
+
+	do {
+		freed = 0;
+		for_each_online_node(nid) {
+			if (fatal_signal_pending(current))
+				return;
 
-	for_each_online_node(nid)
-		drop_slab_node(nid);
+			freed += drop_slab_node(nid);
+		}
+	} while ((freed >> shift++) > 1);
 }
 
 static int reclaimer_offset(void)
_

Patches currently in -mm which might be from jack@suse.cz are


