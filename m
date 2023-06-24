Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0011DC0015E
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjFXAAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjFXAAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E192710
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B630615E3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7337BC433C8;
        Sat, 24 Jun 2023 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564814;
        bh=hTdZIFlwhhFI7GTyEcPuOtgIcAiPS1GeIMVFeqdjpJg=;
        h=Date:To:From:Subject:From;
        b=e1igbghh5B/eksGLt6vpFGkh5dPYwmwWhCloCReWep4JCTaQEICMtXb6Sgclufw4c
         uwtsUZBrrCD4fLFi8i7sYyaQIXEtPVO8hUa7jc9PJroBVVyawXu6ju211RLB4xy4xC
         nMpurdsR9yTS7wPj6sI+FhiM6XvSaezg/SwjS/yY=
Date:   Fri, 23 Jun 2023 17:00:13 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, gregkh@linuxfoundation.org,
        axboe@kernel.dk, ivan.orlov0322@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-backing-dev-make-bdi_class-a-static-const-structure.patch removed from -mm tree
Message-Id: <20230624000014.7337BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: backing-dev: make bdi_class a static const structure
has been removed from the -mm tree.  Its filename was
     mm-backing-dev-make-bdi_class-a-static-const-structure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: mm: backing-dev: make bdi_class a static const structure
Date: Tue, 20 Jun 2023 20:33:15 +0200

Now that the driver core allows for struct class to be in read-only
memory, move the bdi_class structure to be declared at build time placing
it into read-only memory, instead of having to be dynamically allocated at
load time.

Link: https://lkml.kernel.org/r/20230620183314.682822-2-gregkh@linuxfoundation.org
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-make-bdi_class-a-static-const-structure
+++ a/mm/backing-dev.c
@@ -20,7 +20,6 @@
 struct backing_dev_info noop_backing_dev_info;
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
-static struct class *bdi_class;
 static const char *bdi_unknown_name = "(unknown)";
 
 /*
@@ -345,13 +344,19 @@ static struct attribute *bdi_dev_attrs[]
 };
 ATTRIBUTE_GROUPS(bdi_dev);
 
+static const struct class bdi_class = {
+	.name		= "bdi",
+	.dev_groups	= bdi_dev_groups,
+};
+
 static __init int bdi_class_init(void)
 {
-	bdi_class = class_create("bdi");
-	if (IS_ERR(bdi_class))
-		return PTR_ERR(bdi_class);
+	int ret;
+
+	ret = class_register(&bdi_class);
+	if (ret)
+		return ret;
 
-	bdi_class->dev_groups = bdi_dev_groups;
 	bdi_debug_init();
 
 	return 0;
@@ -1001,7 +1006,7 @@ int bdi_register_va(struct backing_dev_i
 		return 0;
 
 	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
-	dev = device_create(bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
+	dev = device_create(&bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
_

Patches currently in -mm which might be from ivan.orlov0322@gmail.com are


