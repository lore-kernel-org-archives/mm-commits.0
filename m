Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E604AC636CC
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 18:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjAaS52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 13:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjAaS5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 13:57:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72559251
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 10:57:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528D2B81E57
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 18:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACC5C433EF;
        Tue, 31 Jan 2023 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675191431;
        bh=JgtK/G2G1jbiuwsRNRuXy2JCx4XJ94JTJNH1Z/KJoaI=;
        h=Date:To:From:Subject:From;
        b=R9/7ATc8JMQ3UpGWs5O6x1e1DJCxTtWZUWnT7L+0CwzjQE1K1lyss6QdKe97lcMGf
         BVHoNnbuDKVqoBay7JuBF9wCfx4Pc+G5uCLyYOeIVd49KkR/5mIehgXURSVD6vcXA1
         DVxqhG7hmGbiUwmBI9yXJKYAErQpEKfxSIYB4jwM=
Date:   Tue, 31 Jan 2023 10:57:10 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, glider@google.com, eugenis@google.com,
        elver@google.com, andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230131185710.EACC5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch

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
Subject: lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
Date: Mon Jan 30 05:43:08 PM PST 2023

fix it for "mm: use stack_depot_early_init for kmemleak"

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
+++ a/mm/kmemleak.c
@@ -105,6 +105,9 @@
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
 
+/* akpm: stupid temporary hack */
+#define stack_depot_want_early_init stack_depot_request_early_init
+
 /*
  * Kmemleak configuration and common defines.
  */
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
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch

