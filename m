Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0916C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKIBmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiKIBkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D976868A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 520BB617E8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4526C433C1;
        Wed,  9 Nov 2022 01:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957984;
        bh=UF9sBMDg3A1LLE3cb+IVvYyH1mmSwc6YlK22Lo1BYHE=;
        h=Date:To:From:Subject:From;
        b=pMHRvY5trX8vk7xutFiJIC2M2/xUKQ7BBtHCz8rCa/hjrgktjFIgbcNBR7n5Y6QcG
         P+LNLjaiUlORW9I7BQ3X3HLYnj436BA3A+9iTHAbXbLS0tcil87V+lWA9mjlC2FWUu
         Qf1cBhDSZY7nWfmXeAaO7dioQWX7I4cTH22S96L4=
Date:   Tue, 08 Nov 2022 17:39:44 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-move-sysfs_lock-to-common-module.patch removed from -mm tree
Message-Id: <20221109013944.A4526C433C1@smtp.kernel.org>
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
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

