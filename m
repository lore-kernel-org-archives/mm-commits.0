Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1741FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJRBkv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiJRBks (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243E2C110
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEC54B81C58
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D0FC433C1;
        Tue, 18 Oct 2022 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666057240;
        bh=QA6ORGwqFWZ5ME46G3lvHZUdc0guHV1Tw0pzuP9THJo=;
        h=Date:To:From:Subject:From;
        b=T/haTWSRIpW2RtY+32JcXZl4iMbOkGNRvecgxRHuCC73YAgrN2LrPbr9gUqxzmsLr
         t2akh/A7eIh2uuymqoxhRqSrnF/XtwFaaKW2ISzF/IC7gNhh6X4jFMvAItucPH0jZS
         KSt3+XjykVz1b9oU2bV7DD+/E2n8BQx5UNQu/PnI=
Date:   Mon, 17 Oct 2022 18:40:39 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-use-hotplug_memory_notifier-directly.patch added to mm-unstable branch
Message-Id: <20221018014040.95D0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ACPI: HMAT: use hotplug_memory_notifier() directly
has been added to the -mm mm-unstable branch.  Its filename is
     acpi-hmat-use-hotplug_memory_notifier-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-use-hotplug_memory_notifier-directly.patch

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
Subject: ACPI: HMAT: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:45 +0800

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-7-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-use-hotplug_memory_notifier-directly
+++ a/drivers/acpi/numa/hmat.c
@@ -767,11 +767,6 @@ static int hmat_callback(struct notifier
 	return NOTIFY_OK;
 }
 
-static struct notifier_block hmat_callback_nb = {
-	.notifier_call = hmat_callback,
-	.priority = 2,
-};
-
 static __init void hmat_free_structures(void)
 {
 	struct memory_target *target, *tnext;
@@ -854,7 +849,7 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (!register_hotmemory_notifier(&hmat_callback_nb))
+	if (!hotplug_memory_notifier(hmat_callback, 2))
 		return 0;
 out_put:
 	hmat_free_structures();
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

