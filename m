Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCB1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiKOWYE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiKOWXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:23:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D66C0E
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 592D761A4D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73F1C433D6;
        Tue, 15 Nov 2022 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551031;
        bh=yUD/atwRjCFcVwHaUmQA/pw16oB9pEqVL4YnqOBrvx8=;
        h=Date:To:From:Subject:From;
        b=VOJltlNxRB4B2H3jbg2a631x5nQaFRVA4W3CJCn3jF89lc3/UB73cOVHZyG5Lt1NJ
         RjvR6CFcWjBDvsJigHLMVvzwUIflUO5qT2Af7eHcV9Vby5q9JQJGnA0KUEt9VcavYz
         1HRUsdaGTzJddW7Z6/maPQvfpYj1/ly+5f4XCnhQ=
Date:   Tue, 15 Nov 2022 14:23:51 -0800
To:     mm-commits@vger.kernel.org, s.shtylyov@omp.ru, mpe@ellerman.id.au,
        lkp@intel.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch removed from -mm tree
Message-Id: <20221115222351.A73F1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
has been removed from the -mm tree.  Its filename was
     powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch

This patch was dropped because it was folded into powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
Date: Mon Oct 17 02:33:53 PM PDT 2022

fix gpr32_set_common()

Reported-by: kernel test robot <lkp@intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace/ptrace-view.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/ptrace/ptrace-view.c~powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix
+++ a/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -706,8 +706,9 @@ int gpr32_set_common(struct task_struct
 	ubuf = u;
 	pos *= sizeof(reg);
 	count *= sizeof(reg);
-	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
-					 (PT_TRAP + 1) * sizeof(reg), -1);
+	user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+				  (PT_TRAP + 1) * sizeof(reg), -1);
+	return 0;
 
 Efault:
 	user_read_access_end();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

