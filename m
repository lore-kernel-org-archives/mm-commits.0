Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D3AC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKIBkC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiKIBiq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B9663C7
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226CC61803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA4FC433D6;
        Wed,  9 Nov 2022 01:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957922;
        bh=4D8p85NW4CPRF7m9paiOERsfFvyKSfNYrQ3xvUDEBQ4=;
        h=Date:To:From:Subject:From;
        b=fEeVuIIz5mgThLjIUCKQ70NAFLltrBvgNHOkYsDFGj9cQKeKsIB3sjArWID5fwILP
         1K7LH+qbQRNVcJItijL1Wbl7k5gVpdPuprvIeb72/ocE5hQN/B4pYEZDgTu4s5EuLT
         33v8HSU4/n9QyruuziMmS5nUrqJfoZNAMkdVkKCo=
Date:   Tue, 08 Nov 2022 17:38:42 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-cpuset-use-hotplug_memory_notifier-directly.patch removed from -mm tree
Message-Id: <20221109013842.7CA4FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cgroup/cpuset: use hotplug_memory_notifier() directly
has been removed from the -mm tree.  Its filename was
     cgroup-cpuset-use-hotplug_memory_notifier-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: cgroup/cpuset: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:40 +0800

Patch series "mm: Use hotplug_memory_notifier() instead of
register_hotmemory_notifier()", v4.

Commit f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") introduced register_hotmemory_notifier()
to avoid a compile problem with gcc-4.4.4:

    When CONFIG_MEMORY_HOTPLUG=n, we don't want the memory-hotplug notifier
    handlers to be included in the .o files, for space reasons.
    
    The existing hotplug_memory_notifier() tries to handle this but testing
    with gcc-4.4.4 shows that it doesn't work - the hotplug functions are
    still present in the .o files.

Since commit 76ae847497bc52 ("Documentation: raise minimum supported
version of GCC to 5.1") has already updated the minimum gcc version to
5.1.  The previous problem mentioned in f02c69680088 does not exist.  So
we can now revert to use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

In the last patch, we move all hotplug memory notifier priority to same
file for easy sorting.


This patch (of 8):

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20220923033347.3935160-2-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/cgroup/cpuset.c~cgroup-cpuset-use-hotplug_memory_notifier-directly
+++ a/kernel/cgroup/cpuset.c
@@ -3630,11 +3630,6 @@ static int cpuset_track_online_nodes(str
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpuset_track_online_nodes_nb = {
-	.notifier_call = cpuset_track_online_nodes,
-	.priority = 10,		/* ??! */
-};
-
 /**
  * cpuset_init_smp - initialize cpus_allowed
  *
@@ -3652,7 +3647,7 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
 	top_cpuset.effective_mems = node_states[N_MEMORY];
 
-	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
+	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 
 	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
 	BUG_ON(!cpuset_migrate_mm_wq);
_

Patches currently in -mm which might be from liushixin2@huawei.com are


