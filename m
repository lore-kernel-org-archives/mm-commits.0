Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B4FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D30961108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhKKCtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F16261247;
        Thu, 11 Nov 2021 02:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598796;
        bh=HOP22+VeLqeQkoz+/+P7cuHszwgIDZtIeVfpVYYeGM0=;
        h=Date:From:To:Subject:From;
        b=XcGij0SrK8hf6lrwOSxTKMM9aQFxsb95VRM2W6Wm6lKx/5paog0Vpb8R6DxOEwtEL
         F8hLwN8rSWQYGr1fEZTP7uQp1sISqYBBFK6m0dN/yKZhy23Gpj7QWzqyMh/D3Mo0gn
         3fDb9fiWA0tR1REB6SgzyXaYWwX0M+h9e7OydOQA=
Date:   Wed, 10 Nov 2021 18:46:36 -0800
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        o451686892@gmail.com, ying.huang@intel.com
Subject:  [merged]
 mm-migrate-de-duplicate-migrate_reason-strings.patch removed from -mm tree
Message-ID: <20211111024636.9px3aQbxn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: de-duplicate migrate_reason strings
has been removed from the -mm tree.  Its filename was
     mm-migrate-de-duplicate-migrate_reason-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/migrate: de-duplicate migrate_reason strings

In order to remove the need to manually keep three different files in
synch, provide a common definition of the mapping between enum
migrate_reason, and the associated strings for each enum item.

1. Use the tracing system's mapping of enums to strings, by redefining
   and reusing the MIGRATE_REASON and supporting macros, and using that to
   populate the string array in mm/debug.c.

2. Move enum migrate_reason to migrate_mode.h.  This is not strictly
   necessary for this patch, but migrate mode and migrate reason go
   together, so this will slightly clarify things.

Link: https://lkml.kernel.org/r/20210922041755.141817-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Weizhao Ouyang <o451686892@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h      |   19 +------------------
 include/linux/migrate_mode.h |   13 +++++++++++++
 mm/debug.c                   |   20 +++++++++++---------
 3 files changed, 25 insertions(+), 27 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-de-duplicate-migrate_reason-strings
+++ a/include/linux/migrate.h
@@ -19,24 +19,7 @@ struct migration_target_control;
  */
 #define MIGRATEPAGE_SUCCESS		0
 
-/*
- * Keep sync with:
- * - macro MIGRATE_REASON in include/trace/events/migrate.h
- * - migrate_reason_names[MR_TYPES] in mm/debug.c
- */
-enum migrate_reason {
-	MR_COMPACTION,
-	MR_MEMORY_FAILURE,
-	MR_MEMORY_HOTPLUG,
-	MR_SYSCALL,		/* also applies to cpusets */
-	MR_MEMPOLICY_MBIND,
-	MR_NUMA_MISPLACED,
-	MR_CONTIG_RANGE,
-	MR_LONGTERM_PIN,
-	MR_DEMOTION,
-	MR_TYPES
-};
-
+/* Defined in mm/debug.c: */
 extern const char *migrate_reason_names[MR_TYPES];
 
 #ifdef CONFIG_MIGRATION
--- a/include/linux/migrate_mode.h~mm-migrate-de-duplicate-migrate_reason-strings
+++ a/include/linux/migrate_mode.h
@@ -19,4 +19,17 @@ enum migrate_mode {
 	MIGRATE_SYNC_NO_COPY,
 };
 
+enum migrate_reason {
+	MR_COMPACTION,
+	MR_MEMORY_FAILURE,
+	MR_MEMORY_HOTPLUG,
+	MR_SYSCALL,		/* also applies to cpusets */
+	MR_MEMPOLICY_MBIND,
+	MR_NUMA_MISPLACED,
+	MR_CONTIG_RANGE,
+	MR_LONGTERM_PIN,
+	MR_DEMOTION,
+	MR_TYPES
+};
+
 #endif		/* MIGRATE_MODE_H_INCLUDED */
--- a/mm/debug.c~mm-migrate-de-duplicate-migrate_reason-strings
+++ a/mm/debug.c
@@ -16,17 +16,19 @@
 #include <linux/ctype.h>
 
 #include "internal.h"
+#include <trace/events/migrate.h>
+
+/*
+ * Define EM() and EMe() so that MIGRATE_REASON from trace/events/migrate.h can
+ * be used to populate migrate_reason_names[].
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)	b,
+#define EMe(a, b)	b
 
 const char *migrate_reason_names[MR_TYPES] = {
-	"compaction",
-	"memory_failure",
-	"memory_hotplug",
-	"syscall_or_cpuset",
-	"mempolicy_mbind",
-	"numa_misplaced",
-	"contig_range",
-	"longterm_pin",
-	"demotion",
+	MIGRATE_REASON
 };
 
 const struct trace_print_flags pageflag_names[] = {
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


