Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E13C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 22:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbiBKWLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:11:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353972AbiBKWLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 17:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEA8CFE
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 14:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BA58B82D4E
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 22:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288EC340E9;
        Fri, 11 Feb 2022 22:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644617474;
        bh=5O9iJ7MgTHU1ELLzyUn1mGKA/aYE7xXzuXCBPw+69QI=;
        h=Date:To:From:Subject:From;
        b=D7vzJHtvJm0KGQXfnGq8vPo8IVgzuPc/MOLv3d/l700BQk4ClwPlmuJGJveXdeLrN
         aXwKDV31hbTbJtjG+ln2G6edOcJcbmxR2AOJUFtnNan8Vtljxvh+qxNohORp4YvFQt
         Hi1iyaaHlx8SumRixzi9Z3/TA5Fn/W5fM7ej1oHo=
Date:   Fri, 11 Feb 2022 14:11:13 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch added to -mm tree
Message-Id: <20220211221113.F288EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-include-linux-memremaph-in-linux-mmh-fix
has been added to the -mm tree.  Its filename is
     mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dont-include-linux-memremaph-in-linux-mmh-fix

fix fx/proc/page.c

fs/proc/page.c: In function 'stable_page_flags':
fs/proc/page.c:120:13: error: implicit declaration of function 'pfn_zone_device_reserved' [-Werror=implicit-function-declaration]
  120 |         if (pfn_zone_device_reserved(page_to_pfn(page)))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/page.c~mm-dont-include-linux-memremaph-in-linux-mmh-fix
+++ a/fs/proc/page.c
@@ -10,6 +10,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
+#include <linux/memremap.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-outline-copy_overflow-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

