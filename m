Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D30C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKIBmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiKIBka (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8255168685
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F948617D1
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75155C433D7;
        Wed,  9 Nov 2022 01:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957983;
        bh=LnIq7uLxgk+Hirb5JwDXnP51qJoYMnhK1eWg4b6nICE=;
        h=Date:To:From:Subject:From;
        b=iWJb3tFxLrAXl2ICGBNrQHBoGfkUfB+9JhRIiv2/t28iLLgnjvIq8kGJp4rGNN8lz
         5lS709lI/BkKLuqbXFQR/fJ+U2HJcgPSfmCH2X2HJhNN/bGz9pdJEGGjXf3HfFsD3U
         Iivr5XM3IZgvAxbX++GK+UpJFiaDVT6ehQLx241Q=
Date:   Tue, 08 Nov 2022 17:39:43 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch removed from -mm tree
Message-Id: <20221109013943.75155C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: remove parameters of damon_sysfs_region_alloc()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove parameters of damon_sysfs_region_alloc()
Date: Wed, 26 Oct 2022 22:59:37 +0000

'damon_sysfs_region_alloc()' is always called with zero-filled 'struct
damon_addr_range', because the start and end addresses should set by
users.  Remove unnecessary parameters of the function and simplify the
body by using 'kzalloc()'.

Link: https://lkml.kernel.org/r/20221026225943.100429-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc
+++ a/mm/damon/sysfs.c
@@ -1065,17 +1065,9 @@ struct damon_sysfs_region {
 	struct damon_addr_range ar;
 };
 
-static struct damon_sysfs_region *damon_sysfs_region_alloc(
-		struct damon_addr_range ar)
+static struct damon_sysfs_region *damon_sysfs_region_alloc(void)
 {
-	struct damon_sysfs_region *region = kmalloc(sizeof(*region),
-			GFP_KERNEL);
-
-	if (!region)
-		return NULL;
-	region->kobj = (struct kobject){};
-	region->ar = ar;
-	return region;
+	return kzalloc(sizeof(struct damon_sysfs_region), GFP_KERNEL);
 }
 
 static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1184,7 +1176,7 @@ static int damon_sysfs_regions_add_dirs(
 	regions->regions_arr = regions_arr;
 
 	for (i = 0; i < nr_regions; i++) {
-		region = damon_sysfs_region_alloc((struct damon_addr_range){});
+		region = damon_sysfs_region_alloc();
 		if (!region) {
 			damon_sysfs_regions_rm_dirs(regions);
 			return -ENOMEM;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

