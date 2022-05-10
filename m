Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AAFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbiEJEWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D52AED8F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F8AFB81B07
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A81C385CD;
        Tue, 10 May 2022 04:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156132;
        bh=DS1ICMUcmioQfEhGq7bTRb/OkIogJXozMuUssc3I2pw=;
        h=Date:To:From:Subject:From;
        b=eB/+1+XvcPiL7h41hYDQAMppJfpca16glfppx8y/OdPJMsDk57oCHUQ+83iLDZBO+
         kM/5dgK7dkSb3JJ96Tcjgn83kMfW1dlP3nLWIyBRlb63Uy8zB1uD18hp5UpoKQOa8n
         H3KWlFQIKjl27sRpEI++dgkLXC0SVG4/4FSfi1ME=
Date:   Mon, 09 May 2022 21:15:32 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch removed from -mm tree
Message-Id: <20220510041532.C5A81C385CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/{ABI,admin-guide}/damon: document 'avail_operations' sysfs file
has been removed from the -mm tree.  Its filename was
     docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/{ABI,admin-guide}/damon: document 'avail_operations' sysfs file

This commit updates the DAMON ABI and usage documents for the new sysfs
file, 'avail_operations'.

Link: https://lkml.kernel.org/r/20220426203843.45238-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   10 +++++++
 Documentation/admin-guide/mm/damon/usage.rst    |   18 +++++++++-----
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abiadmin-guide-damon-document-avail_operations-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -40,6 +40,12 @@ Description:	Writing a number 'N' to thi
 		directories for controlling each DAMON context named '0' to
 		'N-1' under the contexts/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/avail_operations
+Date:		Apr 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the available monitoring operations
+		sets on the currently running kernel.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/operations
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
@@ -47,7 +53,9 @@ Description:	Writing a keyword for a mon
 		virtual address spaces monitoring, and 'paddr' for the physical
 		address space monitoring) to this file makes the context to use
 		the operations set.  Reading the file returns the keyword for
-		the operations set the context is set to use.
+		the operations set the context is set to use.  Note that only
+		the operations sets that listed in 'avail_operations' file are
+		valid inputs.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-abiadmin-guide-damon-document-avail_operations-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -68,7 +68,7 @@ comma (","). ::
     │ kdamonds/nr_kdamonds
     │ │ 0/state,pid
     │ │ │ contexts/nr_contexts
-    │ │ │ │ 0/operations
+    │ │ │ │ 0/avail_operations,operations
     │ │ │ │ │ monitoring_attrs/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ nr_regions/min,max
@@ -143,17 +143,23 @@ be written to the file.
 contexts/<N>/
 -------------
 
-In each context directory, one file (``operations``) and three directories
-(``monitoring_attrs``, ``targets``, and ``schemes``) exist.
+In each context directory, two files (``avail_operations`` and ``operations``)
+and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
+exist.
 
 DAMON supports multiple types of monitoring operations, including those for
-virtual address space and the physical address space.  You can set and get what
-type of monitoring operations DAMON will use for the context by writing one of
-below keywords to, and reading from the file.
+virtual address space and the physical address space.  You can get the list of
+available monitoring operations set on the currently running kernel by reading
+``avail_operations`` file.  Based on the kernel configuration, the file will
+list some or all of below keywords.
 
  - vaddr: Monitor virtual address spaces of specific processes
  - paddr: Monitor the physical address space of the system
 
+You can set and get what type of monitoring operations DAMON will use for the
+context by writing one of the keywords listed in ``avail_operations`` file and
+reading from the ``operations`` file.
+
 contexts/<N>/monitoring_attrs/
 ------------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are


