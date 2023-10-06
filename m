Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D049AE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjJFVs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjJFVsZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A6CBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6678C433D9;
        Fri,  6 Oct 2023 21:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628902;
        bh=ZEH1uSjvVb7H7/HkXgOgjR9DJWQc7LrQfVIoRntP2JA=;
        h=Date:To:From:Subject:From;
        b=YG7ZSDHimlN04c76CIppIuof0t/OZsoG8v7fzKRD1CPnaubw5uLhM7q7RABSJf/VY
         1fR7G49P3DnYJF2/2Iz4NBsMj06zKaOFu8qj5dwVpRiRUYyd6ZeW7PZbqiYXTczrXU
         HahHk13TovuEqTGNqDsaOcAm66MCSsNJ3jBOuZIU=
Date:   Fri, 06 Oct 2023 14:48:19 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, carl@uvos.xyz, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-support-fork-exec-for-prctl.patch removed from -mm tree
Message-Id: <20231006214821.A6678C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: support fork/exec for prctl
has been removed from the -mm tree.  Its filename was
     mm-ksm-support-fork-exec-for-prctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: support fork/exec for prctl
Date: Fri, 22 Sep 2023 14:11:40 -0700

Patch series "mm/ksm: add fork-exec support for prctl", v4.

A process can enable KSM with the prctl system call.  When the process is
forked the KSM flag is inherited by the child process.  However if the
process is executing an exec system call directly after the fork, the KSM
setting is cleared.  This patch series addresses this problem.

1) Change the mask in coredump.h for execing a new process
2) Add a new test case in ksm_functional_tests


This patch (of 2):

Today we have two ways to enable KSM:

1) madvise system call
   This allows to enable KSM for a memory region for a long time.

2) prctl system call
   This is a recent addition to enable KSM for the complete process.
   In addition when a process is forked, the KSM setting is inherited.

This change only affects the second case.

One of the use cases for (2) was to support the ability to enable
KSM for cgroups. This allows systemd to enable KSM for the seed
process. By enabling it in the seed process all child processes inherit
the setting.

This works correctly when the process is forked. However it doesn't
support fork/exec workflow.

From the previous cover letter:

....
Use case 3:
With the madvise call sharing opportunities are only enabled for the
current process: it is a workload-local decision. A considerable number
of sharing opportunities may exist across multiple workloads or jobs
(if they are part of the same security domain). Only a higler level
entity like a job scheduler or container can know for certain if its
running one or more instances of a job. That job scheduler however
doesn't have the necessary internal workload knowledge to make targeted
madvise calls.
....

In addition it can also be a bit surprising that fork keeps the KSM
setting and fork/exec does not.

Link: https://lkml.kernel.org/r/20230922211141.320789-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20230922211141.320789-2-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process")
Reviewed-by: David Hildenbrand <david@redhat.com>
Reported-by: Carl Klemm <carl@uvos.xyz>
Tested-by: Carl Klemm <carl@uvos.xyz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/coredump.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/sched/coredump.h~mm-ksm-support-fork-exec-for-prctl
+++ a/include/linux/sched/coredump.h
@@ -71,6 +71,7 @@ static inline int get_dumpable(struct mm
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 #define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
@@ -85,13 +86,15 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_MDWE		28
 #define MMF_HAS_MDWE_MASK	(1 << MMF_HAS_MDWE)
 
-#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
-				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK)
+#define MMF_HAS_MDWE_NO_INHERIT	29
 
-#define MMF_VM_MERGE_ANY	29
-#define MMF_HAS_MDWE_NO_INHERIT	30
+#define MMF_VM_MERGE_ANY	30
+#define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
+				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
+				 MMF_VM_MERGE_ANY_MASK)
 
 static inline unsigned long mmf_init_flags(unsigned long flags)
 {
_

Patches currently in -mm which might be from shr@devkernel.io are


