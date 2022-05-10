Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C715DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiEJEWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69B103
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 156A8B81B0F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE63C385A6;
        Tue, 10 May 2022 04:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156135;
        bh=LklaCAZWfz+Yc877DB9Ie+hmyhejsSTcwyozRV70VwY=;
        h=Date:To:From:Subject:From;
        b=1nmDbBIAsanHfL/FVT8LSYN6Y6XP/IwZ+HQ7hlkvcDiny+dWKpty6Rh6Kn0A3YoJD
         qs5z0aVbxt1ThdB1N6BwTotadpTtqD0yAEOcTVnI9zf1N7SLBkoeCNX6rrHIwEnWoh
         D2HkEt+pfyJ+EuDnI9qnKsc8LIynbeHG7L+0GphI=
Date:   Mon, 09 May 2022 21:15:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch removed from -mm tree
Message-Id: <20220510041535.AEE63C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/{ABI,admin-guide}/damon: update for fixed virtual address ranges monitoring
has been removed from the -mm tree.  Its filename was
     docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/{ABI,admin-guide}/damon: update for fixed virtual address ranges monitoring

This commit documents the user space support of the newly added monitoring
operations set for fixed virtual address ranges monitoring, namely
'fvaddr', on the ABI and usage documents for DAMON.

Link: https://lkml.kernel.org/r/20220426231750.48822-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   14 ++++++++------
 Documentation/admin-guide/mm/damon/usage.rst    |   14 +++++++++++---
 2 files changed, 19 insertions(+), 9 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -50,12 +50,14 @@ What:		/sys/kernel/mm/damon/admin/kdamon
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a keyword for a monitoring operations set ('vaddr' for
-		virtual address spaces monitoring, and 'paddr' for the physical
-		address space monitoring) to this file makes the context to use
-		the operations set.  Reading the file returns the keyword for
-		the operations set the context is set to use.  Note that only
-		the operations sets that listed in 'avail_operations' file are
-		valid inputs.
+		virtual address spaces monitoring, 'fvaddr' for fixed virtual
+		address ranges monitoring, and 'paddr' for the physical address
+		space monitoring) to this file makes the context to use the
+		operations set.  Reading the file returns the keyword for the
+		operations set the context is set to use.
+
+		Note that only the operations sets that listed in
+		'avail_operations' file are valid inputs.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -154,8 +154,13 @@ available monitoring operations set on t
 list some or all of below keywords.
 
  - vaddr: Monitor virtual address spaces of specific processes
+ - fvaddr: Monitor fixed virtual address ranges
  - paddr: Monitor the physical address space of the system
 
+Please refer to :ref:`regions sysfs directory <sysfs_regions>` for detailed
+differences between the operations sets in terms of the monitoring target
+regions.
+
 You can set and get what type of monitoring operations DAMON will use for the
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
@@ -198,6 +203,8 @@ If you wrote ``vaddr`` to the ``contexts
 be a process.  You can specify the process to DAMON by writing the pid of the
 process to the ``pid_target`` file.
 
+.. _sysfs_regions:
+
 targets/<N>/regions
 -------------------
 
@@ -208,9 +215,10 @@ can be covered.  However, users could wa
 to specific address ranges.
 
 In contrast, DAMON do not automatically sets and updates the monitoring target
-regions when ``paddr`` monitoring operations set is being used (``paddr`` is
-written to the ``contexts/<N>/operations``).  Therefore, users should set the
-monitoring target regions by themselves in the case.
+regions when ``fvaddr`` or ``paddr`` monitoring operations sets are being used
+(``fvaddr`` or ``paddr`` have written to the ``contexts/<N>/operations``).
+Therefore, users should set the monitoring target regions by themselves in the
+cases.
 
 For such cases, users can explicitly set the initial monitoring target regions
 as they want, by writing proper values to the files under this directory.
_

Patches currently in -mm which might be from sj@kernel.org are


