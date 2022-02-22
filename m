Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9657CC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiBVEOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:14:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiBVEOf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:14:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9970585668
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:14:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D222C6157F
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25807C340E8;
        Tue, 22 Feb 2022 04:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645503107;
        bh=3TgIsGLMgSZf1KMLj9T6VybNbdFRXlZhmpgFosGetok=;
        h=Date:To:From:Subject:From;
        b=zmiI4R1gRkwVDUPg22fdp45LxWscstEKXCxZZGibIb48mfcKLrWHhbs7/YCwWe/v0
         tlk1rqDVWxQTc+0ppLeLHfCYxS6/JzfQWXYXtY++mkA4jq3WzdNsOOnDmK0t5Ubxy/
         d90z3O0WqG6LWCZt4uce/I+/lCVZ3InTLozDH85I=
Date:   Mon, 21 Feb 2022 20:11:46 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mingo@kernel.org,
        marcan@marcan.st, kirill.shutemov@linux.intel.com,
        jforbes@redhat.com, aquini@redhat.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch removed from -mm tree
Message-Id: <20220222041147.25807C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2.patch

This patch was dropped because it was folded into mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2

Link: https://lkml.kernel.org/r/20220202003550.698768-1-longman@redhat.com
Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Reported-by: Justin Forbes <jforbes@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hector Martin <marcan@marcan.st>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning-v2
+++ a/include/linux/mmzone.h
@@ -1390,11 +1390,9 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!*mem_section)
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
mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

