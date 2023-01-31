Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8FCC38142
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 23:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjAaXUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 18:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjAaXUy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 18:20:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38B344A7
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 15:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9665FB81F75
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 23:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D01C433EF;
        Tue, 31 Jan 2023 23:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675207250;
        bh=ReyABrEdVXSMBZayeZn7GqxfxZzuOtFhYhsqS3lVIVg=;
        h=Date:To:From:Subject:From;
        b=2GTKBUqhvknTyVaTR+aQ+rknkgmo+XygLVfRsZ0d/CdGJ2ZsuhQrEGoSb7hWTw0K0
         69IOHXvqhSceE0lFq/vgCf1F0cRu6ptsdAE6tXcfV18/c/1tSbDqksljosoBgqyRii
         Q4xofjGl41m/AaV+dJJGyN2i+W9rbMAciVj1wdz8=
Date:   Tue, 31 Jan 2023 15:20:49 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230131232050.37D01C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-annotate-racy-slab_index-accesses-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-annotate-racy-slab_index-accesses-fix
Date: Tue Jan 31 01:10:50 PM PST 2023

enhance comment, per Marco

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-annotate-racy-slab_index-accesses-fix
+++ a/lib/stackdepot.c
@@ -271,7 +271,8 @@ depot_alloc_stack(unsigned long *entries
 
 		/*
 		 * Move on to the next slab.
-		 * WRITE_ONCE annotates a race with stack_depot_fetch.
+		 * WRITE_ONCE pairs with potential concurrent read in
+		 * stack_depot_fetch().
 		 */
 		WRITE_ONCE(slab_index, slab_index + 1);
 		slab_offset = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

