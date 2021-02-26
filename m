Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7FBC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A6D64F27
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBZAn2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhBZAnZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 712A560202;
        Fri, 26 Feb 2021 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300164;
        bh=7hoCWngyqH5GgeYiqHcRHBz0BrjmOfKLcSQbbkM6B2U=;
        h=Date:From:To:Subject:From;
        b=wzLlejz4wLNBondhhu9XWLqpNgvu4pOIzZFONsl4GONudZhtyPTMHhI+XjvC3xEjW
         9Gwn+w5U0Z6+giBPfn288ROw7gj2ug6m/6Jl+YZK2Zrrbln4WNTpYa/4yemJ/56IG5
         1aYuO6gMZHLSujE1nF1zKtDSkKPI6Sn9TcTGlk6I=
Date:   Thu, 25 Feb 2021 16:42:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, dan.carpenter@oracle.com,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        jasowang@redhat.com, Jonathan.Cameron@huawei.com, lkp@intel.com,
        mark.rutland@arm.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@cloud.ionos.com,
        richard.weiyang@linux.alibaba.com, teawaterz@linux.alibaba.com,
        will@kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-prevalidate-the-address-range-being-a?=
 =?US-ASCII?Q?dded-with-platform-fix.patch?= removed from -mm tree
Message-ID: <20210226004243.fW2ZbSQw9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch

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

mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

