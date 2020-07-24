Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E359AC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4B720792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595563668;
	bh=AUp1VjkQTU1RGgpHHpEtYTIDX+DsqUbDk2lxYrq/gP0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z3zJp6jewRbE+nii+bcnBDvhxH3L3jbh30wwCHh4s9fVrzL9s3xEUuPfWaXO9eYeo
	 LM8ilD5pGHmICr4ZYjpLbkDBtxraZH0YUMVSMPeVmMUMqEuBjg67grDQ06sRAIT/Ee
	 ZzOEj00S904s5F9R99SXrEfnKxhtKXnwmH9AwgjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgGXEHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgGXEHs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:07:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C5820709;
        Fri, 24 Jul 2020 04:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563667;
        bh=AUp1VjkQTU1RGgpHHpEtYTIDX+DsqUbDk2lxYrq/gP0=;
        h=Date:From:To:Subject:From;
        b=a87t0RhOOy0icVJgM6IpqNIsvSCd5fHMs5H4lEIrVRRSO5GZ2oG6Zv82IW5Vstr7H
         88wIPtk8dTCHFeHaNFGnGaUxWkunluomnR8ruoensS/nlp4hxIjxFUNWuTCu3fkHhG
         XyzEh9tOc4UDDfxx0v8PBaAhpAdl3SUJ5KQGxP3E=
Date:   Thu, 23 Jul 2020 21:07:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com,
        jonathan.cameron@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  [folded-merged]
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
 removed from -mm tree
Message-ID: <20200724040747.Hs5XDdKIQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch

This patch was dropped because it was folded into mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix

fix CONFIG_CMA=n warning

mm/hugetlb.c:48:20: warning: hugetlb_cma defined but not used [-Wunused-variable]

Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix
+++ a/mm/hugetlb.c
@@ -45,7 +45,9 @@ int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+#ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+#endif
 static unsigned long hugetlb_cma_size __initdata;
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch
io-mapping-indicate-mapping-failure-fix.patch
mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
revert-revert-mm-vmalloc-modify-struct-vmap_area-to-reduce-its-size.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

