Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BC4C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKIBkP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiKIBix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B48714D2A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC929B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793F2C433C1;
        Wed,  9 Nov 2022 01:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957929;
        bh=OWi4BoOnAP7IryPNVo9aIu0mRDCZbqZ3AoGdU/5/XTs=;
        h=Date:To:From:Subject:From;
        b=DgvVfOrmasUkCNH14FU7xTPmMrwNYDLz3ncRQw+pJfEQd/+/tGQl333iCdc3FAgZv
         nOTlsIOZ6I4o9qMgYWYSgGebLy765AQ2nM45/ZlKIRzYDOGrgr+Lqri2QD9oqP2id6
         PTN1ftcu1ShgLSuxlvRPLqoUqffRFmkQWc7MMXYw=
Date:   Tue, 08 Nov 2022 17:38:49 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-remove-unused-register_hotmemory_notifier.patch removed from -mm tree
Message-Id: <20221109013849.793F2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory: remove unused register_hotmemory_notifier()
has been removed from the -mm tree.  Its filename was
     memory-remove-unused-register_hotmemory_notifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: memory: remove unused register_hotmemory_notifier()
Date: Fri, 23 Sep 2022 11:33:46 +0800

Remove unused register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-8-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/memory.h~memory-remove-unused-register_hotmemory_notifier
+++ a/include/linux/memory.h
@@ -19,7 +19,6 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
-#include <linux/notifier.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -136,9 +135,6 @@ static inline int hotplug_memory_notifie
 {
 	return 0;
 }
-/* These aren't inline functions due to a GCC bug. */
-#define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
-#define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
 #else /* CONFIG_MEMORY_HOTPLUG */
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
@@ -166,8 +162,6 @@ int walk_dynamic_memory_groups(int nid,
 		{ .notifier_call = fn, .priority = pri };\
 	register_memory_notifier(&fn##_mem_nb);			\
 })
-#define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
-#define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
 
 #ifdef CONFIG_NUMA
 void memory_block_add_nid(struct memory_block *mem, int nid,
_

Patches currently in -mm which might be from liushixin2@huawei.com are


