Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1312C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 04:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiBWEEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiBWEEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 23:04:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBA36663E
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 20:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6834B617A7
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 04:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3C2C340E7;
        Wed, 23 Feb 2022 04:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645589044;
        bh=bq61cYF7Kou4NPBdTrUY3cDZA4rwHhDxp2qrAifmq7A=;
        h=Date:To:From:Subject:From;
        b=OEd3tXiykI1px1gJUQM3aNB04JCq6cI9JoKKGg5tiEYFe7pg8xSISMwbpM1qhmpsf
         64KrfBRfCIbXKo8eCDA1bDB8Mmkn3In9iBry6lXbukO7Xd2BYWT5YGuwr0C81kA1ya
         d95LiQCNkHxBddF33RU0+4C210jSFoYAr1aCt6SI=
Date:   Tue, 22 Feb 2022 20:04:04 -0800
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-ksysfsc-use-helper-macro-__attr_rw.patch added to -mm tree
Message-Id: <20220223040404.BB3C2C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/ksysfs.c: use helper macro __ATTR_RW
has been added to the -mm tree.  Its filename is
     kernel-ksysfsc-use-helper-macro-__attr_rw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-ksysfsc-use-helper-macro-__attr_rw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-ksysfsc-use-helper-macro-__attr_rw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: kernel/ksysfs.c: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define kobj_attribute to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112034.48298-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ksysfs.c~kernel-ksysfsc-use-helper-macro-__attr_rw
+++ a/kernel/ksysfs.c
@@ -24,8 +24,7 @@
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
 #define KERNEL_ATTR_RW(_name) \
-static struct kobj_attribute _name##_attr = \
-	__ATTR(_name, 0644, _name##_show, _name##_store)
+static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch

