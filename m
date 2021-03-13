Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE06C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD0964FB2
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhCMFHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhCMFHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E839164F8E;
        Sat, 13 Mar 2021 05:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612036;
        bh=mYx7MMzzJBF4Ub8ji9m9ernyQMZahSWn3jAx5UDgxwM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cBrkFWvxRymQSju/BIsxCIa/gMAtgqmyomzBASmgM+d8HKkePZZ0ruaLanYOVArxN
         4AzEwszxDbUyS7eJov1+BQKHMEn5mXxp3iX+gb6YQbFPiu7q6x0o+5xm0eOAIktZR7
         KAmii/b4nUCEq4/msQayLSz5w5RRdiEqt6dwHcsc=
Date:   Fri, 12 Mar 2021 21:07:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com,
        jacob.jun.pan@intel.com, jean-philippe@linaro.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 05/29] mm/fork: clear PASID for new mm
Message-ID: <20210313050715.M6patTVza%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>
Subject: mm/fork: clear PASID for new mm

When a new mm is created, its PASID should be cleared, i.e.  the PASID is
initialized to its init state 0 on both ARM and X86.

This patch was part of the series introducing mm->pasid, but got lost
along the way [1].  It still makes sense to have it, because each address
space has a different PASID.  And the IOMMU code in
iommu_sva_alloc_pasid() expects the pasid field of a new mm struct to be
cleared.

[1] https://lore.kernel.org/linux-iommu/YDgh53AcQHT+T3L0@otcwcpicx3.sc.intel.com/

Link: https://lkml.kernel.org/r/20210302103837.2562625-1-jean-philippe@linaro.org
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 kernel/fork.c            |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/include/linux/mm_types.h~mm-fork-clear-pasid-for-new-mm
+++ a/include/linux/mm_types.h
@@ -23,6 +23,7 @@
 #endif
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
+#define INIT_PASID	0
 
 struct address_space;
 struct mem_cgroup;
--- a/kernel/fork.c~mm-fork-clear-pasid-for-new-mm
+++ a/kernel/fork.c
@@ -994,6 +994,13 @@ static void mm_init_owner(struct mm_stru
 #endif
 }
 
+static void mm_init_pasid(struct mm_struct *mm)
+{
+#ifdef CONFIG_IOMMU_SUPPORT
+	mm->pasid = INIT_PASID;
+#endif
+}
+
 static void mm_init_uprobes_state(struct mm_struct *mm)
 {
 #ifdef CONFIG_UPROBES
@@ -1024,6 +1031,7 @@ static struct mm_struct *mm_init(struct
 	mm_init_cpumask(mm);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mm_init_pasid(mm);
 	RCU_INIT_POINTER(mm->exe_file, NULL);
 	mmu_notifier_subscriptions_init(mm);
 	init_tlb_flush_pending(mm);
_
