Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD27ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJ1V7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJ1V7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1E624CC8B
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04F9CB82CF2
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D8C433C1;
        Fri, 28 Oct 2022 21:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666994339;
        bh=dyE3MLoVK+0rPRirXnGqcO0Elyt/S6pIH5bjAS21f6I=;
        h=Date:To:From:Subject:From;
        b=Oa+1OEIfqhnYq2yb7Sgi/dg+rG6mssvmLoXWovZEotzRQXqfmP5KWCsIfeNwE5Aes
         0NfM+Gsnn3SsMQGWpodmzFUNAtxmie98VfGwhxOYmJ6mdHQnQBTFhxiMZ5sGrUSqxr
         l30MbSt/JLMqOj8ixFE1Pi8bCaGsLI20XlndWMek=
Date:   Fri, 28 Oct 2022 14:58:58 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reorganize-testing-to-restore-module-testing-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221028215859.942D8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-reorganize-testing-to-restore-module-testing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reorganize-testing-to-restore-module-testing-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix
Date: Fri Oct 28 02:54:27 PM PDT 2022

fix module export

ERROR: modpost: "mas_find_rev" [lib/test_maple_tree.ko] undefined!

Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-reorganize-testing-to-restore-module-testing-fix
+++ a/lib/maple_tree.c
@@ -6059,7 +6059,7 @@ void *mas_find_rev(struct ma_state *mas,
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_prev_entry(mas, min);
 }
-EXPORT_SYMBOL_GPL(mas_find);
+EXPORT_SYMBOL_GPL(mas_find_rev);
 
 /**
  * mas_erase() - Find the range in which index resides and erase the entire
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing-fix.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

