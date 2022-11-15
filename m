Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814DDC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKOWLV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238280AbiKOWLQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D2B30F4A
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC62B81B61
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411B6C433D6;
        Tue, 15 Nov 2022 22:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668550263;
        bh=ZOlQ3bXP7xS+dbbL/j72mE9O2fdvVva/CrQR8wb6LOI=;
        h=Date:To:From:Subject:From;
        b=bVpQ/lOzbOIOl1bqL5OVWCuFJtcmEOGet75syzAptnSDO6S7+UeoWYjLEERT4mIiX
         vO8GDz+fXEesluSEHnVJfK39A5mJsTlbVgPC0bNoE1mYVHM39RtUYBrm6f7HrTK23c
         r/8Cx1Cieu96ltIS+uitFhsxRi3GFmVP2ilDeZX8=
Date:   Tue, 15 Nov 2022 14:11:02 -0800
To:     mm-commits@vger.kernel.org, s.shtylyov@omp.ru, mpe@ellerman.id.au,
        lkp@intel.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch removed from -mm tree
Message-Id: <20221115221103.411B6C433D6@smtp.kernel.org>
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
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

