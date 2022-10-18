Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAC8C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJRBk4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiJRBku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106491094
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4854B81C59
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D725C433C1;
        Tue, 18 Oct 2022 01:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666057242;
        bh=qHuwGN+tZvTKfcrTwIlh/OYjKro4nm/YpPY2b+rkdXQ=;
        h=Date:To:From:Subject:From;
        b=sl6bGMHzjRdFZtmCt9W19pTOmpqk54v91y28ijNw5etDqKRCP+28dIb0lap0MPwIw
         R4C0k8Ib3bWadXbeC2HIAcv7VrfVnDnbJ049yOeBkcGzwaVOAnx3x/F6cpcABQWxYM
         Qp19URrL+uasDXv6G3RxFoNozm5Ot/M16DBhnMh4=
Date:   Mon, 17 Oct 2022 18:40:41 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-remove-unused-register_hotmemory_notifier.patch added to mm-unstable branch
Message-Id: <20221018014042.9D725C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory: remove unused register_hotmemory_notifier()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-remove-unused-register_hotmemory_notifier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-remove-unused-register_hotmemory_notifier.patch

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

cgroup-cpuset-use-hotplug_memory_notifier-directly.patch
fs-proc-kcorec-use-hotplug_memory_notifier-directly.patch
mm-slubc-use-hotplug_memory_notifier-directly.patch
mm-mmap-use-hotplug_memory_notifier-directly.patch
mm-mm_initc-use-hotplug_memory_notifier-directly.patch
acpi-hmat-use-hotplug_memory_notifier-directly.patch
memory-remove-unused-register_hotmemory_notifier.patch
memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting.patch

