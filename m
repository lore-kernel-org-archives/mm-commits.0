Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44406C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2373161362
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhKEUqP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUqM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D27D61357;
        Fri,  5 Nov 2021 20:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145012;
        bh=JwWtMJ9zkt/tlGDYqm+z8K1z+UxPVs0nEijRXcLv8OY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EHuuL7SM22tqfvAX7GnrF99bn1QtdLIoYK/X1yYxzNt35/pyScQshqpV8pcJyjxyc
         DzLNzGTOwJakuJIJ9HbhAhnPGfemcfE9+KGw0xsp7l+Nzd22OuVjZgwYG6tYOJLOVS
         GxEADXf/XFkmJsl4V+OQwCOmhwgGP4GBy0lj1PJ8=
Date:   Fri, 05 Nov 2021 13:43:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, o451686892@gmail.com,
        torvalds@linux-foundation.org, ying.huang@intel.com
Subject:  [patch 170/262] mm/migrate: de-duplicate migrate_reason
 strings
Message-ID: <20211105204332.dOk2Us1-H%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
