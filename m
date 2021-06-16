Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8C0C48BE6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA04613B9
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 23:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhFPXnB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234700AbhFPXm6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 19:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC41061159;
        Wed, 16 Jun 2021 23:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623886852;
        bh=yQJlNauJ3ul1O6N7GGGc92yhxgLL9W7YWPH2wKBz3u0=;
        h=Date:From:To:Subject:From;
        b=fbSZkidOPj7GsxwutSCR3vAkmVpABO3PPXB9CoNLfsj0kbZcbLDYlLarpYylCygcw
         5qAKXwUKnR6RBAMNZLYh+ThUYjiSMx4wKdTTyndDKV6FxXT/O+ALOUUjzZaK2iAkpu
         vTdIHzzOMDK9XH7+CUg3ahwZkz3x8HVtL2D8iGbw=
Date:   Wed, 16 Jun 2021 16:40:51 -0700
From:   akpm@linux-foundation.org
To:     chenhuang5@huawei.com, corbet@lwn.net, david@redhat.com,
        duanxiongchun@bytedance.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  +
 mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch
 added to -mm tree
Message-ID: <20210616234051.g2JHt4YNV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: introduce CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch
mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch
mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages.patch
mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

