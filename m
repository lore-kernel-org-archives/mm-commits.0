Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00813C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 21:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiCNVDg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 17:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiCNVDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 17:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612663D1FE
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 14:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F193F612DA
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 21:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53366C340E9;
        Mon, 14 Mar 2022 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647291743;
        bh=AfEfwBoVYiXUMocAmEMR6eyeon0RZ40Vy9N0fS8Sbqs=;
        h=Date:To:From:Subject:From;
        b=Fg4R6TytDzc3RRnhsdQpCSOviiDHYm3818oahoeE//QFzmyD1gSOdKJig2xbqFvpF
         ZP41j4T034hInxlltkZKUhHvaV/pMijPQpw7j4Q0Cob3B4+cQ26mPOhk3EYZOY7Y/0
         +UllXrAQi0pdMh9QBhTMk6ZG9UqgzrEbEbT5YLf4=
Date:   Mon, 14 Mar 2022 14:02:22 -0700
To:     mm-commits@vger.kernel.org, huntbag@linux.vnet.ibm.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch added to -mm tree
Message-Id: <20220314210223.53366C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3
has been added to the -mm tree.  Its filename is
     mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch

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
Subject: mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3

add feedback from Huang Ying

Link: https://lkml.kernel.org/r/20220314150945.12694-1-osalvador@suse.de
Fixes: 884a6e5d1f93b ("mm/migrate: update node demotion order on hotplug events")
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Abhishek Goel <huntbag@linux.vnet.ibm.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3
+++ a/mm/migrate.c
@@ -3280,12 +3280,16 @@ void __init migrate_on_reclaim_init(void
 				      GFP_KERNEL);
 	WARN_ON(!node_demotion);
 
+	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
 	/*
 	 * At this point, all numa nodes with memory/CPus have their state
 	 * properly set, so we can build the demotion order now.
+	 * Let us hold the cpu_hotplug lock just, as we could possibily have
+	 * CPU hotplug events during boot.
 	 */
+	cpus_read_lock();
 	set_migration_target_nodes();
-	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
+	cpus_read_unlock();
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
_

Patches currently in -mm which might be from osalvador@suse.de are

arch-x86-mm-numa-do-not-initialize-nodes-twice.patch
arch-x86-mm-numa-do-not-initialize-nodes-twice-v2.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch

