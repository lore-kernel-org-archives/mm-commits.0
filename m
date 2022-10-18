Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E99FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 02:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJRCNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 22:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJRCNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 22:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A3962F6
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 19:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160A261347
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 02:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1B5C433C1;
        Tue, 18 Oct 2022 02:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666059206;
        bh=KO0YtxcBnwKkffMyee/hFW7Q6LX8bxUqpCBnVqD0uoU=;
        h=Date:To:From:Subject:From;
        b=iLWlvghyoCKS/lND/SPbg9slGsc7CEqE0hyRYIIziFBRS7F4XaXJtrSdIUc7P8lDT
         DFOye8UEFZpiZAhSfFXQrPpOyJDcW1kpvdlIr7M8mpBcWm2YSpt2gb3n43LzSkPxqi
         cZPA/n7KI2KpQw6zFqPQP5Kz4xp4lb+xnJY+/c8Y=
Date:   Mon, 17 Oct 2022 19:13:25 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        joao.m.martins@oracle.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, linyujun809@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch removed from -mm tree
Message-Id: <20221018021326.6B1B5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ACPI: HMAT: release platform device in case of platform_device_add_data() failure
has been removed from the -mm tree.  Its filename was
     acpi-hmat-release-platform-device-in-case-of-platform_device_add_data-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/dax/hmem/device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


