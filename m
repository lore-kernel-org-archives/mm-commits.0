Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B2BC38145
	for <mm-commits@archiver.kernel.org>; Tue,  6 Sep 2022 23:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIFXVj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 19:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIFXVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 19:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2BF8E4F2
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 16:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA70B81AD6
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 23:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91566C433C1;
        Tue,  6 Sep 2022 23:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662506494;
        bh=DYW3Z5f5qX3wNtJ6/Z4wP3xDY5eHeDysT6EyyVcEo6U=;
        h=Date:To:From:Subject:From;
        b=oIIcOYrU1ABgi7Ml1gKqi6kBcbWV+o6j8LfmorS55FYPF5JzxQ3DhCFWYLChmv+MJ
         gwdHKV9EZkRYng7duv9t+ouiEBL6h4L0XLdvYTMapLmaUpKTJEu2uEF7AEJ0dCtnpT
         qVmE1InTeCOktJOKcbiGe2tFsNo2CaGDv/bs7To8=
Date:   Tue, 06 Sep 2022 16:21:33 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rcampbell@nvidia.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hch@lst.de,
        apopple@nvidia.com, mpenttil@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node.patch added to mm-unstable branch
Message-Id: <20220906232134.91566C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm/test: use char dev with struct device to get device node
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node.patch

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
From: Mika Penttilä <mpenttil@redhat.com>
Subject: mm/hmm/test: use char dev with struct device to get device node
Date: Fri, 26 Aug 2022 08:06:31 +0300

HMM selftests use an in-kernel pseudo device to emulate device memory. 
The pseudo device registers a major device range for two or four pseudo
device instances.  User space has a script that reads /proc/devices in
order to find the assigned major number, and sends that to mknod(1), once
for each node.

Change this to properly use cdev and struct device APIs.

Delete the /proc/devices parsing from the user-space test script, now that
it is unnecessary.

Also, delete an unused field in struct dmirror_device: devmem.

Link: https://lkml.kernel.org/r/20220826050631.25771-1-mpenttil@redhat.com
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c                         |   13 ++++++++++---
 tools/testing/selftests/vm/test_hmm.sh |   10 ----------
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/lib/test_hmm.c~mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node
+++ a/lib/test_hmm.c
@@ -107,8 +107,8 @@ struct dmirror_chunk {
  */
 struct dmirror_device {
 	struct cdev		cdevice;
-	struct hmm_devmem	*devmem;
 	unsigned int            zone_device_type;
+	struct device		device;
 
 	unsigned int		devmem_capacity;
 	unsigned int		devmem_count;
@@ -1390,7 +1390,14 @@ static int dmirror_device_init(struct dm
 
 	cdev_init(&mdevice->cdevice, &dmirror_fops);
 	mdevice->cdevice.owner = THIS_MODULE;
-	ret = cdev_add(&mdevice->cdevice, dev, 1);
+	device_initialize(&mdevice->device);
+	mdevice->device.devt = dev;
+
+	ret = dev_set_name(&mdevice->device, "hmm_dmirror%u", id);
+	if (ret)
+		return ret;
+
+	ret = cdev_device_add(&mdevice->cdevice, &mdevice->device);
 	if (ret)
 		return ret;
 
@@ -1416,7 +1423,7 @@ static void dmirror_device_remove(struct
 		kfree(mdevice->devmem_chunks);
 	}
 
-	cdev_del(&mdevice->cdevice);
+	cdev_device_del(&mdevice->cdevice, &mdevice->device);
 }
 
 static int __init hmm_dmirror_init(void)
--- a/tools/testing/selftests/vm/test_hmm.sh~mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node
+++ a/tools/testing/selftests/vm/test_hmm.sh
@@ -52,21 +52,11 @@ load_driver()
 			usage
 		fi
 	fi
-	if [ $? == 0 ]; then
-		major=$(awk "\$2==\"HMM_DMIRROR\" {print \$1}" /proc/devices)
-		mknod /dev/hmm_dmirror0 c $major 0
-		mknod /dev/hmm_dmirror1 c $major 1
-		if [ $# -eq 2 ]; then
-			mknod /dev/hmm_dmirror2 c $major 2
-			mknod /dev/hmm_dmirror3 c $major 3
-		fi
-	fi
 }
 
 unload_driver()
 {
 	modprobe -r $DRIVER > /dev/null 2>&1
-	rm -f /dev/hmm_dmirror?
 }
 
 run_smoke()
_

Patches currently in -mm which might be from mpenttil@redhat.com are

mm-hmm-test-use-char-dev-with-struct-device-to-get-device-node.patch

