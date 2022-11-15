Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBB2C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 19:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKOTqW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiKOTqU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 14:46:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC6624BEF
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 11:46:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3A9619D9
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 19:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3EC433D6;
        Tue, 15 Nov 2022 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668541578;
        bh=PAtlozwltWiWLO5cmY32EEKBWGfYJHeJtLrp9CZFSh4=;
        h=Date:To:From:Subject:From;
        b=gXP/+gHkgGWwd0atcwLiPM9smarWcVeW3GuNm/rmJzrGlWbDsdqPUH+ISAuxOYRTy
         WRj9rAYtWcCkpqKW7Et+T/wEp/moLrj7hksUPJNPk0CoDztfEb5N+1koy+PaO4dJle
         g/0a6aPaiL68mmZtIkh4Px/b/hbSjWG6S8X/cLCg=
Date:   Tue, 15 Nov 2022 11:46:17 -0800
To:     mm-commits@vger.kernel.org, you.zhou@intel.com,
        vdavydov.dev@gmail.com, shakeelb@google.com, pengfei.xu@intel.com,
        jack@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch added to mm-unstable branch
Message-Id: <20221115194618.2AA3EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make drop_caches keep reclaiming on all nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch

This patch will later appear in the mm-unstable branch at
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

mm-make-drop_caches-keep-reclaiming-on-all-nodes.patch

