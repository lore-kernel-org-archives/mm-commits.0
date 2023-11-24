Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DF5C61DF4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 18:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjKXSgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 13:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjKXSgQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 13:36:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F2CE
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 10:36:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E3DC433C9;
        Fri, 24 Nov 2023 18:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700850982;
        bh=jBCfg3qyt5JQjIFZQS5XInXO5Oxgli9JPVh2Jdq/lLc=;
        h=Date:To:From:Subject:From;
        b=FTYBjNH6rGGDd60KhN7e69n9RHSitqGHIQFFfY1iphv3LtHG2PJUpxbYVC1zufS06
         TK1FZ7JRNkaaH+H7QwIWDsqb+VVH5k6t0BPFwhnn1UCodrAEZzT/m4U14ZzthgX6og
         D9PiIviy6VP+t/mRtvWX5YruSAtOUmlcUAJSg/U0=
Date:   Fri, 24 Nov 2023 10:36:21 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rdunlap@infradead.org, mike.kravetz@oracle.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-kconfig-make-hugetlbfs-a-menuconfig.patch added to mm-unstable branch
Message-Id: <20231124183622.38E3DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/Kconfig: make hugetlbfs a menuconfig
has been added to the -mm mm-unstable branch.  Its filename is
     fs-kconfig-make-hugetlbfs-a-menuconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-kconfig-make-hugetlbfs-a-menuconfig.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: fs/Kconfig: make hugetlbfs a menuconfig
Date: Fri, 24 Nov 2023 10:19:02 -0500

Hugetlb vmemmap default option (HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON)
is a sub-option to hugetlbfs, but it shows in the same level as hugetlbfs
itself, under "Pesudo filesystems".

Make the vmemmap option a sub-option to hugetlbfs, by changing hugetlbfs
into a menuconfig.  When moving it, fix a typo 'v' spot by Randy.

Link: https://lkml.kernel.org/r/20231124151902.1075697-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/Kconfig~fs-kconfig-make-hugetlbfs-a-menuconfig
+++ a/fs/Kconfig
@@ -254,7 +254,7 @@ config TMPFS_QUOTA
 config ARCH_SUPPORTS_HUGETLBFS
 	def_bool n
 
-config HUGETLBFS
+menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
@@ -266,22 +266,24 @@ config HUGETLBFS
 
 	  If unsure, say N.
 
-config HUGETLB_PAGE
-	def_bool HUGETLBFS
-
-config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
-	depends on SPARSEMEM_VMEMMAP
-
+if HUGETLBFS
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
 	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
 	default n
 	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  The HugeTLB VmemmapvOptimization (HVO) defaults to off. Say Y here to
+	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+endif # HUGETLBFS
+
+config HUGETLB_PAGE
+	def_bool HUGETLBFS
+
+config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	def_bool HUGETLB_PAGE
+	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+	depends on SPARSEMEM_VMEMMAP
 
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch
fs-kconfig-make-hugetlbfs-a-menuconfig.patch

