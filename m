Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218CECE7A95
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjIYPpP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjIYPpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:45:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1BABC
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:45:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1FFC433C8;
        Mon, 25 Sep 2023 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695656701;
        bh=WRuKFlBpf6puPBJEoVd75UemFceKjxkOX5/xum8DM2w=;
        h=Date:To:From:Subject:From;
        b=Bu3uTNe7QJ2m6UXdr+wpR3/QCzYmz56hkLoi+qgbuTP4cVJOGadfvHI42zCMhAEsa
         3epR9GbV6jL3UvFnCpU3/atMn0H3LwBGwjRK+h4C2czreB+micOCcdqaJj4eOho4tx
         EkRdCRiA5yYrVpSUIdo2zMSRdcsGyb+vEH1Bk52w=
Date:   Mon, 25 Sep 2023 08:45:00 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, carl@uvos.xyz, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-support-fork-exec-for-prctl.patch added to mm-unstable branch
Message-Id: <20230925154501.4B1FFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: support fork/exec for prctl
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-support-fork-exec-for-prctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-support-fork-exec-for-prctl.patch

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

 include/linux/sched/coredump.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/sched/coredump.h~mm-ksm-support-fork-exec-for-prctl
+++ a/include/linux/sched/coredump.h
@@ -87,12 +87,16 @@ static inline int get_dumpable(struct mm
 
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
-				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK)
-
 #define MMF_VM_MERGE_ANY	29
 #define MMF_HAS_MDWE_NO_INHERIT	30
 
+#define MMF_VM_MERGE_ANY	31
+#define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
+				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
+				 MMF_VM_MERGE_ANY_MASK)
+
 static inline unsigned long mmf_init_flags(unsigned long flags)
 {
 	if (flags & (1UL << MMF_HAS_MDWE_NO_INHERIT))
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch
mm-ksm-support-fork-exec-for-prctl.patch
mm-ksm-test-case-for-prctl-fork-exec-workflow.patch

