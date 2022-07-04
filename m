Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A75CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiGDBMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiGDBLR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC766401
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95FE8611FA
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA309C341C6;
        Mon,  4 Jul 2022 01:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897050;
        bh=95GQwrn2o70667BosWKcDUG+Bji87DAmtkvPDFdWLno=;
        h=Date:To:From:Subject:From;
        b=sFxXJAqfPcj+B+vRSZtKs4NZBCS/4Ujh/lTl/QqSfIidFK8yZLWQKQGh8lSy51y8x
         8CSKiFxxyfP9emFdQv2GxEhYqGbHo6IB0Ius26T1jCGAilVVZ8bIiNhA+Etv+m9rEI
         Mr7oJkOupR1wTi7jwatqeniu4Lzi0QnM7qwRx4DA=
Date:   Sun, 03 Jul 2022 18:10:49 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, adobriyan@gmail.com,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-smaps-add-pss_dirty.patch removed from -mm tree
Message-Id: <20220704011049.EA309C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/smaps: add Pss_Dirty
has been removed from the -mm tree.  Its filename was
     mm-smaps-add-pss_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: mm/smaps: add Pss_Dirty
Date: Mon, 20 Jun 2022 10:12:50 +0200

Pss is the sum of the sizes of clean and dirty private pages, and the
proportional sizes of clean and dirty shared pages:

 Private = Private_Dirty + Private_Clean
 Shared_Proportional = Shared_Dirty_Proportional + Shared_Clean_Proportional
 Pss = Private + Shared_Proportional

The Shared*Proportional fields are not present in smaps, so it is not
always possible to determine how much of the Pss is from dirty pages and
how much is from clean pages.  This information can be useful for
measuring memory usage for the purpose of optimisation, since clean pages
can usually be discarded by the kernel immediately while dirty pages
cannot.

The smaps routines in the kernel already have access to this data, so add
a Pss_Dirty to show it to userspace.  Pss_Clean is not added since it can
be calculated from Pss and Pss_Dirty.

Link: https://lkml.kernel.org/r/20220620081251.2928103-1-vincent.whitchurch@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/procfs-smaps_rollup |    1 +
 Documentation/filesystems/proc.rst            |    5 ++++-
 fs/proc/task_mmu.c                            |    3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/procfs-smaps_rollup~mm-smaps-add-pss_dirty
+++ a/Documentation/ABI/testing/procfs-smaps_rollup
@@ -22,6 +22,7 @@ Description:
 			MMUPageSize:           4 kB
 			Rss:		     884 kB
 			Pss:		     385 kB
+			Pss_Dirty:	      68 kB
 			Pss_Anon:	     301 kB
 			Pss_File:	      80 kB
 			Pss_Shmem:	       4 kB
--- a/Documentation/filesystems/proc.rst~mm-smaps-add-pss_dirty
+++ a/Documentation/filesystems/proc.rst
@@ -448,6 +448,7 @@ Memory Area, or VMA) there is a series o
     MMUPageSize:           4 kB
     Rss:                 892 kB
     Pss:                 374 kB
+    Pss_Dirty:             0 kB
     Shared_Clean:        892 kB
     Shared_Dirty:          0 kB
     Private_Clean:         0 kB
@@ -479,7 +480,9 @@ dirty shared and private pages in the ma
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
 So if a process has 1000 pages all to itself, and 1000 shared with one other
-process, its PSS will be 1500.
+process, its PSS will be 1500.  "Pss_Dirty" is the portion of PSS which
+consists of dirty pages.  ("Pss_Clean" is not included, but it can be
+calculated by subtracting "Pss_Dirty" from "Pss".)
 
 Note that even a page which is part of a MAP_SHARED mapping, but has only
 a single pte mapped, i.e.  is currently used by only one process, is accounted
--- a/fs/proc/task_mmu.c~mm-smaps-add-pss_dirty
+++ a/fs/proc/task_mmu.c
@@ -406,6 +406,7 @@ struct mem_size_stats {
 	u64 pss_anon;
 	u64 pss_file;
 	u64 pss_shmem;
+	u64 pss_dirty;
 	u64 pss_locked;
 	u64 swap_pss;
 };
@@ -427,6 +428,7 @@ static void smaps_page_accumulate(struct
 		mss->pss_locked += pss;
 
 	if (dirty || PageDirty(page)) {
+		mss->pss_dirty += pss;
 		if (private)
 			mss->private_dirty += size;
 		else
@@ -808,6 +810,7 @@ static void __show_smap(struct seq_file
 {
 	SEQ_PUT_DEC("Rss:            ", mss->resident);
 	SEQ_PUT_DEC(" kB\nPss:            ", mss->pss >> PSS_SHIFT);
+	SEQ_PUT_DEC(" kB\nPss_Dirty:      ", mss->pss_dirty >> PSS_SHIFT);
 	if (rollup_mode) {
 		/*
 		 * These are meaningful only for smaps_rollup, otherwise two of
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are


