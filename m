Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90464C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiCVTMn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiCVTMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9715E8F9B3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5671AB81D39
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7B6C340EC;
        Tue, 22 Mar 2022 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976272;
        bh=rZK0IZ5UtK9dGEiZgpI9PXmN0B3PfsL5YWCa9QzDAII=;
        h=Date:To:From:Subject:From;
        b=zwZAsTYPO+Zzg8cwBYJtE1ZJdcDAqKAQA/MEp2Yw+vNRDQWpUijn7HiIblaiDSmFb
         NPExUq97W21BOUA8p14AdH4xN6NR9/tv/el5pnRyS9kyRLQlQGgAyBq3KUTr+i3KDL
         BV4xONZfZvbKPgSdlSVxap2esvTUEasjmJKBGUmo=
Date:   Tue, 22 Mar 2022 12:11:12 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, osalvador@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch removed from -mm tree
Message-Id: <20220322191112.CF7B6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-x86-mm-numa-do-not-initialize-nodes-twice-v2
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch

This patch was dropped because it was folded into arch-x86-mm-numa-do-not-initialize-nodes-twice.patch

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch-x86-mm-numa-do-not-initialize-nodes-twice-v2

add comments

Link: https://lkml.kernel.org/r/20220221142649.3457-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/mm/numa.c~arch-x86-mm-numa-do-not-initialize-nodes-twice-v2
+++ a/arch/x86/mm/numa.c
@@ -755,6 +755,15 @@ void __init init_gi_nodes(void)
 {
 	int nid;
 
+	/*
+	 * Exclude this node from
+	 * bringup_nonboot_cpus
+	 *  cpu_up
+	 *   __try_online_node
+	 *    register_one_node
+	 * because node_subsys is not initialized yet.
+	 * TODO remove dependency on node_online
+	 */
 	for_each_node_state(nid, N_GENERIC_INITIATOR)
 		if (!node_online(nid))
 			node_set_online(nid);
@@ -787,6 +796,15 @@ void __init init_cpu_to_node(void)
 		if (node == NUMA_NO_NODE)
 			continue;
 
+		/*
+		 * Exclude this node from
+		 * bringup_nonboot_cpus
+		 *  cpu_up
+		 *   __try_online_node
+		 *    register_one_node
+		 * because node_subsys is not initialized yet.
+		 * TODO remove dependency on node_online
+		 */
 		if (!node_online(node))
 			node_set_online(node);
 
_

Patches currently in -mm which might be from osalvador@suse.de are

arch-x86-mm-numa-do-not-initialize-nodes-twice.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch

