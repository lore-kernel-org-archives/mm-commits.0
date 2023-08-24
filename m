Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51865C727A7
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjHXXWy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244121AbjHXXWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F241DFB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F68612FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD6EC433C7;
        Thu, 24 Aug 2023 23:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919337;
        bh=uAsh8CACFeGGCczgcDPvRDWz7JAQV0Xkpn7gCoEB/V4=;
        h=Date:To:From:Subject:From;
        b=rxX6kyi7pMeZ90uc00KKq8rLCJrOVSd93eYROrJzg+JCbbLNcmjm3AH4NapuA2Q1Z
         4PJh/jsKLlUgewMwc9W4pPRRdO7Gk2Pu46csU8MJTmE6d9fHxuSKYPfJ1q2/jE5t8H
         VT++82RvyHvCkXw6hbGACm41xW9yQ/FPJyeBMHhs=
Date:   Thu, 24 Aug 2023 16:22:16 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-orphaned-kernel-doc-to-the-rst-files.patch removed from -mm tree
Message-Id: <20230824232216.EBD6EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add orphaned kernel-doc to the rst files.
has been removed from the -mm tree.  Its filename was
     mm-add-orphaned-kernel-doc-to-the-rst-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add orphaned kernel-doc to the rst files.
Date: Fri, 18 Aug 2023 21:06:30 +0100

There are many files in mm/ that contain kernel-doc which is not
currently published on kernel.org.  Some of it is easily categorisable,
but most of it is going into the miscellaneous documentation section to
be organised later.

Some files aren't ready to be included; they contain documentation with
build errors.  Or they're nommu.c which duplicates documentation from
"real" MMU systems.  Those files are noted with a # mark (although really
anything which isn't a recognised directive would do to prevent inclusion)

Link: https://lkml.kernel.org/r/20230818200630.2719595-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |   25 +++++++++++++++++++++++++
 Documentation/mm/highmem.rst      |    1 +
 Documentation/mm/zsmalloc.rst     |    5 +++++
 3 files changed, 31 insertions(+)

--- a/Documentation/core-api/mm-api.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/core-api/mm-api.rst
@@ -115,3 +115,28 @@ More Memory Management Functions
 .. kernel-doc:: include/linux/mmzone.h
 .. kernel-doc:: mm/util.c
    :functions: folio_mapping
+
+.. kernel-doc:: mm/rmap.c
+.. kernel-doc:: mm/migrate.c
+.. kernel-doc:: mm/mmap.c
+.. kernel-doc:: mm/kmemleak.c
+.. #kernel-doc:: mm/hmm.c (build warnings)
+.. kernel-doc:: mm/memremap.c
+.. kernel-doc:: mm/hugetlb.c
+.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/zpool.c
+.. kernel-doc:: mm/memcontrol.c
+.. #kernel-doc:: mm/memory-tiers.c (build warnings)
+.. kernel-doc:: mm/shmem.c
+.. kernel-doc:: mm/migrate_device.c
+.. #kernel-doc:: mm/nommu.c (duplicates kernel-doc from other files)
+.. kernel-doc:: mm/mapping_dirty_helpers.c
+.. #kernel-doc:: mm/memory-failure.c (build warnings)
+.. kernel-doc:: mm/percpu.c
+.. kernel-doc:: mm/maccess.c
+.. kernel-doc:: mm/vmscan.c
+.. kernel-doc:: mm/memory_hotplug.c
+.. kernel-doc:: mm/mmu_notifier.c
+.. kernel-doc:: mm/balloon_compaction.c
+.. kernel-doc:: mm/huge_memory.c
+.. kernel-doc:: mm/io-mapping.c
--- a/Documentation/mm/highmem.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/mm/highmem.rst
@@ -206,4 +206,5 @@ Functions
 =========
 
 .. kernel-doc:: include/linux/highmem.h
+.. kernel-doc:: mm/highmem.c
 .. kernel-doc:: include/linux/highmem-internal.h
--- a/Documentation/mm/zsmalloc.rst~mm-add-orphaned-kernel-doc-to-the-rst-files
+++ a/Documentation/mm/zsmalloc.rst
@@ -263,3 +263,8 @@ is heavy internal fragmentation and zspo
 objects and release zspages. In these cases, it is recommended to decrease
 the limit on the size of the zspage chains (as specified by the
 CONFIG_ZSMALLOC_CHAIN_SIZE option).
+
+Functions
+=========
+
+.. kernel-doc:: mm/zsmalloc.c
_

Patches currently in -mm which might be from willy@infradead.org are


