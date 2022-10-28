Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85E9ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 22:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJ1W4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 18:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiJ1Wz5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 18:55:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E740521344B
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 15:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F0FE62AB0
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 22:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A01C433C1;
        Fri, 28 Oct 2022 22:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666997751;
        bh=Lb14YMuWkMA0BcANO9CMdkvsvmpkl330E2eEUnDgt9s=;
        h=Date:To:From:Subject:From;
        b=dJmpEKSIXKc+QHihDPWTkvHE1XBiheivM0IwPlziNj1irk6gb5sOfDyxMsw5K0bHn
         mdnX3SHbhGI233S1sm2SQtdIAWDNDXQqCxjVs8SReZk9QU/8EWkx0AKRNmToYsj5Zl
         xlJc5fE1pN9ma5roS1rh9GBL8r6PRnBwyM/1BPy4=
Date:   Fri, 28 Oct 2022 15:55:50 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20221028225551.66A01C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch

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
Subject: maple_tree-reorganize-testing-to-restore-module-testing-fix-2
Date: Fri Oct 28 03:42:53 PM PDT 2022

fix it some more

Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-reorganize-testing-to-restore-module-testing-fix-2
+++ a/lib/maple_tree.c
@@ -6013,6 +6013,7 @@ void *mas_find(struct ma_state *mas, uns
 	/* Retries on dead nodes handled by mas_next_entry */
 	return mas_next_entry(mas, max);
 }
+EXPORT_SYMBOL_GPL(mas_find);
 
 /**
  * mas_find_rev: On the first call, find the first non-null entry at or below
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing-fix.patch
maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch
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

