Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA24C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiCVTRm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiCVTRl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15748B87D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A71D461634
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085F2C340EC;
        Tue, 22 Mar 2022 19:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976573;
        bh=PTQVtxyAZb/Yzi5zNVF19Ms7lbYQFoVVNnZbSHpGtoY=;
        h=Date:To:From:Subject:From;
        b=lkydTaEwBl+cTEzo9y1YmKyfrYonDsLhGo6ZGhdIQWYsYrUvRfCXN5OrDVaRV5jFs
         Xi/SE+qJIzKHowjAeg51Jmnz0MqoNQpB3qI3MldYnl2LkAGSd0tQQARaLVZC48um5h
         bEgAAmmRJteAnqbpLMEiN0pdM7gPIuWIVSj7PL1I=
Date:   Tue, 22 Mar 2022 12:16:12 -0700
To:     mm-commits@vger.kernel.org, huntbag@linux.vnet.ibm.com,
        dave.hansen@linux.intel.com, baolin.wang@linux.alibaba.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch removed from -mm tree
Message-Id: <20220322191613.085F2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3
has been removed from the -mm tree.  Its filename was
     mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state-v3.patch

This patch was dropped because it was folded into mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

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
mm-only-re-generate-demotion-targets-when-a-numa-node-changes-its-n_cpu-state.patch

