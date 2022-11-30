Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF734C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiK3XCW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiK3XCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E417A8E592
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 976DDB81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A9BC433C1;
        Wed, 30 Nov 2022 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849321;
        bh=byotvq3Q8Zaa3VQo2Bu28Ehy3mdpMfEYKKOvBDBGrGo=;
        h=Date:To:From:Subject:From;
        b=cqmPl4A3vmeW73nJGqUFE349esxelg7LT9kpfYjg0j634RyTkLAaP7ithTyBR+sT0
         bQK8F1w1PHN/ido+mK1KTNo2vi/NQgaaT4aWO6SKU2Wn45Hs79s8NDabjTGYFeJLhj
         M8IvvdsONqMMP+yAfG4U8FidwtIe9UG0Rq7URr9Y=
Date:   Wed, 30 Nov 2022 15:02:00 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-move-sysfs_lock-to-common-module.patch removed from -mm tree
Message-Id: <20221130230201.47A9BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: move sysfs_lock to common module
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-move-sysfs_lock-to-common-module.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: move sysfs_lock to common module
Date: Wed, 26 Oct 2022 22:59:38 +0000

DAMON sysfs interface is implemented in a single file, sysfs.c, which has
about 2,800 lines of code.  As the interface is hierarchical and some of
the code can be reused by different hierarchies, it would make more sense
to split out the implementation into common parts and different parts in
multiple files.  As the beginning of the work, create files for common
code and move the global mutex for directories modifications protection
into the new file.

Link: https://lkml.kernel.org/r/20221026225943.100429-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Makefile       |    2 +-
 mm/damon/sysfs-common.c |   11 +++++++++++
 mm/damon/sysfs-common.h |   11 +++++++++++
 mm/damon/sysfs.c        |    4 +---
 4 files changed, 24 insertions(+), 4 deletions(-)

--- a/mm/damon/Makefile~mm-damon-sysfs-move-sysfs_lock-to-common-module
+++ a/mm/damon/Makefile
@@ -3,7 +3,7 @@
 obj-y				:= core.o
 obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
 obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
-obj-$(CONFIG_DAMON_SYSFS)	+= sysfs.o
+obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= lru_sort.o
--- a/mm/damon/sysfs.c~mm-damon-sysfs-move-sysfs_lock-to-common-module
+++ a/mm/damon/sysfs.c
@@ -5,13 +5,11 @@
  * Copyright (c) 2022 SeongJae Park <sj@kernel.org>
  */
 
-#include <linux/damon.h>
-#include <linux/kobject.h>
 #include <linux/pid.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-static DEFINE_MUTEX(damon_sysfs_lock);
+#include "sysfs-common.h"
 
 /*
  * unsigned long range directory
--- /dev/null
+++ a/mm/damon/sysfs-common.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Primitives for DAMON Sysfs Interface
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include "sysfs-common.h"
+
+DEFINE_MUTEX(damon_sysfs_lock);
+
--- /dev/null
+++ a/mm/damon/sysfs-common.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common Primitives for DAMON Sysfs Interface
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/damon.h>
+#include <linux/kobject.h>
+
+extern struct mutex damon_sysfs_lock;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

