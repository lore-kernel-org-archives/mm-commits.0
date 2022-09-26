Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A05C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiIZRGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiIZRGM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:06:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D994E491DC
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CBD5B80AE3
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1306C433D6;
        Mon, 26 Sep 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664208616;
        bh=quJC7BagLpcToqzJKrMzwdzUJjkYLhFgDc2RC34Q8hw=;
        h=Date:To:From:Subject:From;
        b=iDMkLzGtAtVkkK8FZ5yLBPV0+WkCeBTpE0QQZZyybddng5xXnmq3Avg5vURFBhXtM
         z/MkiHAMxB8CypkJoukTnL+2e4D+IHtMFgdFKM0QVF52DQZJX7J3wx5Sckeev9W6+/
         yhUm6rjO/uf4oJ0++4LsOwx71bQVqTxoJlyF7lNA=
Date:   Mon, 26 Sep 2022 09:10:14 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        joao.m.martins@oracle.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, linyujun809@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch added to mm-unstable branch
Message-Id: <20220926161015.E1306C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ACPI: HMAT: release platform device in case of platform_device_add_data() failure
has been added to the -mm mm-unstable branch.  Its filename is
     acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch

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
From: Lin Yujun <linyujun809@huawei.com>
Subject: ACPI: HMAT: release platform device in case of platform_device_add_data() failure
Date: Wed, 14 Sep 2022 11:37:55 +0800

The platform device is not released when platform_device_add_data() fails.
And platform_device_put() performs one more pointer check than
put_device() to check for errors in the 'pdev' pointer.

Use platform_device_put() to release platform device in
platform_device_add()/platform_device_add_data()/
platform_device_add_resources() error case.

Link: https://lkml.kernel.org/r/20220914033755.99924-1-linyujun809@huawei.com
Fixes: c01044cc8191 ("ACPI: HMAT: refactor hmat_register_target_device to hmem_register_device")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/dax/hmem/device.c~acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails
+++ a/drivers/dax/hmem/device.c
@@ -47,7 +47,7 @@ void hmem_register_device(int target_nid
 	rc = platform_device_add_data(pdev, &info, sizeof(info));
 	if (rc < 0) {
 		pr_err("hmem memregion_info allocation failure for %pr\n", &res);
-		goto out_pdev;
+		goto out_resource;
 	}
 
 	rc = platform_device_add_resources(pdev, &res, 1);
@@ -65,7 +65,7 @@ void hmem_register_device(int target_nid
 	return;
 
 out_resource:
-	put_device(&pdev->dev);
+	platform_device_put(pdev);
 out_pdev:
 	memregion_free(id);
 }
_

Patches currently in -mm which might be from linyujun809@huawei.com are

acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch

