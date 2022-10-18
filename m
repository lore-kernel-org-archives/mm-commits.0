Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0522C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJRBks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJRBkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865A2AE0C
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F60661323
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858E1C433D6;
        Tue, 18 Oct 2022 01:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666057232;
        bh=PZRc6S4sVowgVmG9FSewcGyWM5VR5jo5MJWHDO+lU4I=;
        h=Date:To:From:Subject:From;
        b=y/VqEaBmP6pzvhtBrgxaeem4NJjmDgKR/KRSc8+b92SxRVyjFrhOv67FlnvXcjQs9
         XNICpV3DE1Ws2JOAIPLScoqQxnwCBEDE5wVP29CrN87idi2OQOfwu4N9wGTSV8nHW+
         1Hzg5g3kUv6doVydISmTkLrXPs7OenmfMBawSUgA=
Date:   Mon, 17 Oct 2022 18:40:31 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-use-hotplug_memory_notifier-directly.patch added to mm-unstable branch
Message-Id: <20221018014032.858E1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: use hotplug_memory_notifier() directly
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-kcorec-use-hotplug_memory_notifier-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcorec-use-hotplug_memory_notifier-directly.patch

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
Subject: fs/proc/kcore.c: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:41 +0800

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-use-hotplug_memory_notifier-directly
+++ a/fs/proc/kcore.c
@@ -18,7 +18,6 @@
 #include <linux/capability.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
-#include <linux/notifier.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/printk.h>
@@ -638,10 +637,6 @@ static int __meminit kcore_callback(stru
 	return NOTIFY_OK;
 }
 
-static struct notifier_block kcore_callback_nb __meminitdata = {
-	.notifier_call = kcore_callback,
-	.priority = 0,
-};
 
 static struct kcore_list kcore_vmalloc;
 
@@ -694,7 +689,7 @@ static int __init proc_kcore_init(void)
 	add_modules_range();
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
-	register_hotmemory_notifier(&kcore_callback_nb);
+	hotplug_memory_notifier(kcore_callback, 0);
 
 	return 0;
 }
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

