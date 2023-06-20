Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D8FEB64DB
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jun 2023 19:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjFTTK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jun 2023 15:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjFTTK0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2023 15:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEABE9B
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 12:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 430426142F
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 19:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976AEC433C8;
        Tue, 20 Jun 2023 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687288223;
        bh=HwA6ZOWJHBZnfyXgkz5iU8TrHWqr4wBtfA5JKqZio3E=;
        h=Date:To:From:Subject:From;
        b=KykDDmQ3OYuf6BqMYLuCL4LXH2icoHT+ztati6h/xBXY8FJAGT05Ei+oN6PJ4I2Gm
         EV+XKiIO0bJdV+dJne9m+n6MtV83jsTfmUp6nBHTg+zLpj1koLSklgeLVFHjVDL5RH
         JxtqJvgNQO3D8qz2NH+vR4JI/4kkJSQxGuMnkBsI=
Date:   Tue, 20 Jun 2023 12:10:22 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, gregkh@linuxfoundation.org,
        axboe@kernel.dk, ivan.orlov0322@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-backing-dev-make-bdi_class-a-static-const-structure.patch added to mm-unstable branch
Message-Id: <20230620191023.976AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: backing-dev: make bdi_class a static const structure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-backing-dev-make-bdi_class-a-static-const-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-backing-dev-make-bdi_class-a-static-const-structure.patch

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

mm-backing-dev-make-bdi_class-a-static-const-structure.patch

