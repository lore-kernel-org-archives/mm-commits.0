Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC11C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiKIBkO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiKIBix (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6310663E4
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B72B81CC9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6B3C433D7;
        Wed,  9 Nov 2022 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957928;
        bh=0LiaE8RdnttTTcLXVIqloim5zfAqgW1ltVDKfyCKPcs=;
        h=Date:To:From:Subject:From;
        b=ogFQ0esMb6oD5q/vSJtxajhkLkRoHWDeAyjLpNSjUph1DvthsiOxMpwdoDTbzy0Bc
         8klG/80XAnhId9IMtdlfnw3h1fR+VebMFr7JC/9a96lw6/cyx/m5YIFY1/bhmldkx9
         1VziRWeiwtQ00Nr00yPYTkI+ZrztYjG0Rbt4wmAg=
Date:   Tue, 08 Nov 2022 17:38:47 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] acpi-hmat-use-hotplug_memory_notifier-directly.patch removed from -mm tree
Message-Id: <20221109013848.6C6B3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ACPI: HMAT: use hotplug_memory_notifier() directly
has been removed from the -mm tree.  Its filename was
     acpi-hmat-use-hotplug_memory_notifier-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


