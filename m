Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78DAC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346877AbiBKUtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:49:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243065AbiBKUtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:49:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4D0CFD
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB8BA620AA
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040CCC340E9;
        Fri, 11 Feb 2022 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612579;
        bh=YMSSm8e2Ak1TPGmEU9tNeOcXWVoGqKaJ3JLaZsYidI0=;
        h=Date:To:From:Subject:From;
        b=qGjb61zpubIpJ3P2YTRs7DNuJ2AutFH+gVl6Agx9d6rNSVeXWF8EWTV5Qf9shfRkZ
         bcPnnyO7sbvhOea0No653y4wrgkx6106+M0ccRco4f9syWS8uDhq4j4Vw96Rwz5wXW
         fV6WyYjkH9aqsWZjGcntjohYt/tsBAUC7ap5OcEg=
Date:   Fri, 11 Feb 2022 12:49:38 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alexander.deucher@amd.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch added to -mm tree
Message-Id: <20220211204939.040CCC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fail get_user_pages for LONGTERM dev coherent type
has been added to the -mm tree.  Its filename is
     mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch

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
Subject: mm/gup: fail get_user_pages for LONGTERM dev coherent type

Avoid long term pinning for Coherent device type pages.  This could
interfere with their own device memory manager.  For now, we are just
returning error for PIN_LONGTERM Coherent device type pages.  Eventually,
these type of pages will get migrated to system memory, once the device
migration pages support is added.

[hch@lst.de: rebased on previous cleanups, split the two checks]
Link: https://lkml.kernel.org/r/20220210072828.2930359-18-hch@lst.de
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type
+++ a/mm/gup.c
@@ -1857,6 +1857,19 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_head = head;
 
+		/*
+		 * Device private pages will get faulted in during gup so it
+		 * shouldn't be possible to see one here.
+		 */
+		if (WARN_ON_ONCE(is_device_private_page(head))) {
+			ret = -EFAULT;
+			goto unpin_pages;
+		}
+		if (is_device_coherent_page(head)) {
+			ret = -EFAULT;
+			goto unpin_pages;
+		}
+
 		if (is_pinnable_page(head))
 			continue;
 
@@ -1901,7 +1914,7 @@ unpin_pages:
 			put_page(pages[i]);
 	}
 
-	if (!list_empty(&movable_page_list)) {
+	if (!ret && !list_empty(&movable_page_list)) {
 		struct migration_target_control mtc = {
 			.nid = NUMA_NO_NODE,
 			.gfp_mask = GFP_USER | __GFP_NOWARN,
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

