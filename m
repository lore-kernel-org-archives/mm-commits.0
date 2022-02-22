Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8228C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiBVEOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:14:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiBVEOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:14:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995DD85667
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:14:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2287615AE
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C24BC340EB;
        Tue, 22 Feb 2022 04:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645503137;
        bh=r8fHly2OmxOYB5U9fFnUviP2GRI06IaqWSunKIfbd4k=;
        h=Date:To:From:Subject:From;
        b=D10wTa9xBpryhnYnTBZx7z4NA5lfvJKB7lxYcDZpYvmHglSZH6iYjHeWf6QK7+pZY
         qNEUBLg4TTggLjRl5aC+Q3d/nW7To3maPmzanlLwWhk/eQe8wjIj8Sa8MHQpZxwZLY
         3PVmrokvCMJFNaIFF8dj/zdWr8Z/wPT2CxD6YgY8=
Date:   Mon, 21 Feb 2022 20:12:16 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mingo@kernel.org,
        marcan@marcan.st, kirill.shutemov@linux.intel.com,
        jforbes@redhat.com, aquini@redhat.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch removed from -mm tree
Message-Id: <20220222041217.3C24BC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

The gcc 12 compiler reports a "'mem_section' will never be NULL" warning
on the following code:

    static inline struct mem_section *__nr_to_section(unsigned long nr)
    {
    #ifdef CONFIG_SPARSEMEM_EXTREME
        if (!mem_section)
                return NULL;
    #endif
        if (!mem_section[SECTION_NR_TO_ROOT(nr)])
                return NULL;
       :

It happens with both CONFIG_SPARSEMEM_EXTREME on and off.  The mem_section
definition is

    #ifdef CONFIG_SPARSEMEM_EXTREME
    extern struct mem_section **mem_section;
    #else
    extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
    #endif

In the CONFIG_SPARSEMEM_EXTREME case, mem_section obviously cannot be
NULL, but *mem_section can be if memory hasn't been allocated for the
dynamic mem_section[] array yet.  In the !CONFIG_SPARSEMEM_EXTREME case,
mem_section is a static 2-dimensional array and so the check
"!mem_section[SECTION_NR_TO_ROOT(nr)]" doesn't make sense.

Fix this warning by checking for "!*mem_section" instead of "!mem_section"
and moving the "!mem_section[SECTION_NR_TO_ROOT(nr)]" check up inside the
CONFIG_SPARSEMEM_EXTREME block.

[longman@redhat.com: v2]
  Link: https://lkml.kernel.org/r/20220202003550.698768-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20220201192924.672675-1-longman@redhat.com
Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: Justin Forbes <jforbes@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Forbes <jforbes@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hector Martin <marcan@marcan.st>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
+++ a/include/linux/mmzone.h
@@ -1390,11 +1390,9 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!*mem_section || !mem_section[SECTION_NR_TO_ROOT(nr)])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
_

Patches currently in -mm which might be from longman@redhat.com are

lib-vsprintf-avoid-redundant-work-with-0-size.patch
mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
mm-page_owner-print-memcg-information.patch
mm-page_owner-record-task-command-name.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

