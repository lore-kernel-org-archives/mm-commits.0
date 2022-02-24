Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF086C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiBXEsd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiBXEsd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:48:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCE4168089
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784666175F
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C00C340E9;
        Thu, 24 Feb 2022 04:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645678082;
        bh=ccsy0KR9YazhZpEGuktBsYxe2nfWjN67joDEyHXEGLo=;
        h=Date:To:From:Subject:From;
        b=0iD7JKHD8EPugsrjHE9Khrsw6VBZJ6K5qFzPJAjk0Q2V9jC2qNXnFL8VNC6MQu/xi
         6HQl3UjgLzzg8KOrQfuDNvHdalq5xgwgK/1YtiGrJYSc49M19DFZmZRHuZqDTWmIrq
         4m5MD2xkgHkAySz4hfAl9yOER2Mn9jhym80HkVUk=
Date:   Wed, 23 Feb 2022 20:48:02 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, osalvador@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch added to -mm tree
Message-Id: <20220224044802.C3C00C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-x86-mm-numa-do-not-initialize-nodes-twice-v2
has been added to the -mm tree.  Its filename is
     arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch

