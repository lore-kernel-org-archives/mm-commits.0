Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C14DC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Feb 2021 22:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51D064EBA
	for <mm-commits@archiver.kernel.org>; Thu, 18 Feb 2021 22:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBRW3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Feb 2021 17:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhBRW3T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Feb 2021 17:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06B0064EB4;
        Thu, 18 Feb 2021 22:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613687317;
        bh=oC39Koo/CCaIiScWk8ucCehYiJhbQaXsrTNUoLMW/Ng=;
        h=Date:From:To:Subject:From;
        b=xT4dUWgI+TaZ0iy2ckJQesdmV9sRvK+SkrvZGbSTtArCbCTFQy7IN+TiEI3e7rr6F
         MQil21dQLKc/q4CCC0HcNrNam0PUNdMB9lOez0inf2eh/wY5/NoPU3AZuodoB9SiRf
         zT3mOLo/Rogq0mqaB+MtUbRb2qV+Todanq1ny34w=
Date:   Thu, 18 Feb 2021 14:28:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        teawaterz@linux.alibaba.com, richard.weiyang@linux.alibaba.com,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@cloud.ionos.com,
        osalvador@suse.de, mst@redhat.com, mhocko@kernel.org,
        mark.rutland@arm.com, lkp@intel.com, Jonathan.Cameron@huawei.com,
        jasowang@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, dan.carpenter@oracle.com,
        catalin.marinas@arm.com, ardb@kernel.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
Subject:  +
 =?us-ascii?Q?mm-memory=5Fhotplug-prevalidate-the-address-range-being-a?=
 =?us-ascii?Q?dded-with-platform-fix.patch?= added to -mm tree
Message-ID: <20210218222836.52mtf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch

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
Subject: mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix

make pagemap_range() return -EINVAL when mhp_range_allowed() fails

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix
+++ a/mm/memremap.c
@@ -266,8 +266,10 @@ static int pagemap_range(struct dev_page
 	if (error)
 		goto err_pfn_remap;
 
-	if (!mhp_range_allowed(range->start, range_len(range), !is_private))
+	if (!mhp_range_allowed(range->start, range_len(range), !is_private)) {
+		error = -EINVAL;
 		goto err_pfn_remap;
+	}
 
 	mem_hotplug_begin();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

