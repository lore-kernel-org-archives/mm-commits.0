Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696B3C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiBATyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:54:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiBATyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:54:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC64B82F7C
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C811BC340EB;
        Tue,  1 Feb 2022 19:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745240;
        bh=zWmwCn9LPTbdug6xh3Eq+bV4sixarDJ3OqyHZ1rHNH0=;
        h=Date:To:From:Subject:From;
        b=GrZPJkrL4MSCQ09HRLE4hi/25eTM/pMxdU97nHZhRAFo1f3Qk1XW3MmbNjrYQ++2l
         CqSuPN60gOz2ZtBMIsYQ41RbGSYIV8vDPHMvLtdkeGrxUmHNqmfVCsqCRS6cbAoSsD
         wCOd7UOke+qCnSe7uUQudhg2+Rl7DZJwir5Cx/VU=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:58 -0800
Date:   Tue, 01 Feb 2022 11:53:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-add-ioctl-to-get-zone-device-type.patch added to -mm tree
Message-Id: <20220201195358.C811BC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test_hmm add ioctl to get zone device type
has been added to the -mm tree.  Its filename is
     lib-test_hmm-add-ioctl-to-get-zone-device-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_hmm-add-ioctl-to-get-zone-device-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: lib: test_hmm add ioctl to get zone device type

New ioctl cmd added to query zone device type.  This will be used once
test_hmm adds zone device coherent type.

Link: https://lkml.kernel.org/r/20220201154901.7921-7-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c      |   23 +++++++++++++++++++++--
 lib/test_hmm_uapi.h |    8 ++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-add-ioctl-to-get-zone-device-type
+++ a/lib/test_hmm.c
@@ -84,6 +84,7 @@ struct dmirror_chunk {
 struct dmirror_device {
 	struct cdev		cdevice;
 	struct hmm_devmem	*devmem;
+	unsigned int            zone_device_type;
 
 	unsigned int		devmem_capacity;
 	unsigned int		devmem_count;
@@ -1024,6 +1025,15 @@ static int dmirror_snapshot(struct dmirr
 	return ret;
 }
 
+static int dmirror_get_device_type(struct dmirror *dmirror,
+			    struct hmm_dmirror_cmd *cmd)
+{
+	mutex_lock(&dmirror->mutex);
+	cmd->zone_device_type = dmirror->mdevice->zone_device_type;
+	mutex_unlock(&dmirror->mutex);
+
+	return 0;
+}
 static long dmirror_fops_unlocked_ioctl(struct file *filp,
 					unsigned int command,
 					unsigned long arg)
@@ -1074,6 +1084,9 @@ static long dmirror_fops_unlocked_ioctl(
 		ret = dmirror_snapshot(dmirror, &cmd);
 		break;
 
+	case HMM_DMIRROR_GET_MEM_DEV_TYPE:
+		ret = dmirror_get_device_type(dmirror, &cmd);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1258,14 +1271,20 @@ static void dmirror_device_remove(struct
 static int __init hmm_dmirror_init(void)
 {
 	int ret;
-	int id;
+	int id = 0;
+	int ndevices = 0;
 
 	ret = alloc_chrdev_region(&dmirror_dev, 0, DMIRROR_NDEVICES,
 				  "HMM_DMIRROR");
 	if (ret)
 		goto err_unreg;
 
-	for (id = 0; id < DMIRROR_NDEVICES; id++) {
+	memset(dmirror_devices, 0, DMIRROR_NDEVICES * sizeof(dmirror_devices[0]));
+	dmirror_devices[ndevices++].zone_device_type =
+				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
+	dmirror_devices[ndevices++].zone_device_type =
+				HMM_DMIRROR_MEMORY_DEVICE_PRIVATE;
+	for (id = 0; id < ndevices; id++) {
 		ret = dmirror_device_init(dmirror_devices + id, id);
 		if (ret)
 			goto err_chrdev;
--- a/lib/test_hmm_uapi.h~lib-test_hmm-add-ioctl-to-get-zone-device-type
+++ a/lib/test_hmm_uapi.h
@@ -19,6 +19,7 @@
  * @npages: (in) number of pages to read/write
  * @cpages: (out) number of pages copied
  * @faults: (out) number of device page faults seen
+ * @zone_device_type: (out) zone device memory type
  */
 struct hmm_dmirror_cmd {
 	__u64		addr;
@@ -26,6 +27,7 @@ struct hmm_dmirror_cmd {
 	__u64		npages;
 	__u64		cpages;
 	__u64		faults;
+	__u64		zone_device_type;
 };
 
 /* Expose the address space of the calling process through hmm device file */
@@ -35,6 +37,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_GET_MEM_DEV_TYPE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
 
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
@@ -62,4 +65,9 @@ enum {
 	HMM_DMIRROR_PROT_DEV_PRIVATE_REMOTE	= 0x30,
 };
 
+enum {
+	/* 0 is reserved to catch uninitialized type fields */
+	HMM_DMIRROR_MEMORY_DEVICE_PRIVATE = 1,
+};
+
 #endif /* _LIB_TEST_HMM_UAPI_H */
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

