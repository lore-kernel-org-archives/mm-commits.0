Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4450AC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB1561474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhGABu7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABu7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C137561090;
        Thu,  1 Jul 2021 01:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104109;
        bh=YsizUCViGmidYVNh6PTUlSBYfdXMUnBWhuzIEpIGP1s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2g+uLhRv1Idq9bTFvCwwgI08/TLCrT9Li5PCrgEaN0MjTkbThZ4G7e6FH6ed8dct1
         K8suOEMPxskCmLjZJQXYID8ZcIMs3Y2JTyJtyUV/DOQR/fEwN6z9Steox3SdXPlDF1
         eaw/Z4Uhu9zZ9AHmmzo4iw9ZNEpABKjeevdRtSjs=
Date:   Wed, 30 Jun 2021 18:48:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenhuang5@huawei.com, corbet@lwn.net,
        david@redhat.com, duanxiongchun@bytedance.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 026/192] mm: hugetlb: introduce
 CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
Message-ID: <20210701014828.73mtzQZj9%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: introduce CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON

When using HUGETLB_PAGE_FREE_VMEMMAP, the freeing unused vmemmap pages
associated with each HugeTLB page is default off.  Now the vmemmap is PMD
mapped.  So there is no side effect when this feature is enabled with no
HugeTLB pages in the system.  Someone may want to enable this feature in
the compiler time instead of using boot command line.  So add a config to
make it default on when someone do not want to enable it via command line.

Link: https://lkml.kernel.org/r/20210616094915.34432-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    3 +++
 fs/Kconfig                                      |   10 ++++++++++
 mm/hugetlb_vmemmap.c                            |    6 ++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1577,6 +1577,9 @@
 			on:  enable the feature
 			off: disable the feature
 
+			Built with CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON=y,
+			the default is on.
+
 			This is not compatible with memory_hotplug.memmap_on_memory.
 			If both parameters are enabled, hugetlb_free_vmemmap takes
 			precedence over memory_hotplug.memmap_on_memory.
--- a/fs/Kconfig~mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on
+++ a/fs/Kconfig
@@ -245,6 +245,16 @@ config HUGETLB_PAGE_FREE_VMEMMAP
 	depends on X86_64
 	depends on SPARSEMEM_VMEMMAP
 
+config HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
+	bool "Default freeing vmemmap pages of HugeTLB to on"
+	default n
+	depends on HUGETLB_PAGE_FREE_VMEMMAP
+	help
+	  When using HUGETLB_PAGE_FREE_VMEMMAP, the freeing unused vmemmap
+	  pages associated with each HugeTLB page is default off. Say Y here
+	  to enable freeing vmemmap pages of HugeTLB by default. It can then
+	  be disabled on the command line via hugetlb_free_vmemmap=off.
+
 config MEMFD_CREATE
 	def_bool TMPFS || HUGETLBFS
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on
+++ a/mm/hugetlb_vmemmap.c
@@ -182,7 +182,7 @@
 #define RESERVE_VMEMMAP_NR		2U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-bool hugetlb_free_vmemmap_enabled;
+bool hugetlb_free_vmemmap_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON);
 
 static int __init early_hugetlb_free_vmemmap_param(char *buf)
 {
@@ -197,7 +197,9 @@ static int __init early_hugetlb_free_vme
 
 	if (!strcmp(buf, "on"))
 		hugetlb_free_vmemmap_enabled = true;
-	else if (strcmp(buf, "off"))
+	else if (!strcmp(buf, "off"))
+		hugetlb_free_vmemmap_enabled = false;
+	else
 		return -EINVAL;
 
 	return 0;
_
