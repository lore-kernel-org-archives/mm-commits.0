Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E91C4332B
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF1664F2B
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCBXfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361124AbhCBX3h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:29:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A396186A;
        Tue,  2 Mar 2021 23:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614727737;
        bh=3O/2MZy8VLpTrKvhfXAs6nWI+5BK15MHe/G5OXNiW3I=;
        h=Date:From:To:Subject:From;
        b=uMY1RPiD2ABlf8DjtqnFlNX2mkJ3kDbso0VLgaALWRdVoPvf3slkPoAs0QLuRtCQv
         y1CN8UunTEG1XBYna8hyqAGE6XZ1lILX/lMyLpFEYlE6edLp1ZejuSzOETJaY0mX7x
         VYMoPtmVmAiWYIx9J0ckGdvEslHs6kj72nuP/FUs=
Date:   Tue, 02 Mar 2021 15:28:56 -0800
From:   akpm@linux-foundation.org
To:     fenghua.yu@intel.com, jacob.jun.pan@intel.com,
        jean-philippe@linaro.org, mm-commits@vger.kernel.org,
        tony.luck@intel.com
Subject:  + mm-fork-clear-pasid-for-new-mm.patch added to -mm tree
Message-ID: <20210302232856.mD-u6EDsC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fork: clear PASID for new mm
has been added to the -mm tree.  Its filename is
     mm-fork-clear-pasid-for-new-mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fork-clear-pasid-for-new-mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fork-clear-pasid-for-new-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fenghua Yu <fenghua.yu@intel.com>
Subject: mm/fork: clear PASID for new mm

When a new mm is created, its PASID should be cleared, i.e.  the PASID is
initialized to its init state 0 on both ARM and X86.

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

Patches currently in -mm which might be from fenghua.yu@intel.com are

mm-fork-clear-pasid-for-new-mm.patch

