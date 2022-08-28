Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA280C0502A
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 00:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiH1ALA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 20:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH1AK7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 20:10:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4555F13F84
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 17:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9EC6B807EB
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 00:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0D8C433C1;
        Sun, 28 Aug 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661645455;
        bh=hZzbWR3oquxasPiOcGx7S2hQcmNuPSlHouLECjwdRlU=;
        h=Date:To:From:Subject:From;
        b=QDQB6IU4i9R9PEiC/+OjkbWQ4q+J+u1a1juMOKH3pQOw2j68kM+qoBGk71U21In20
         7s922GibWhjYsXhHnWiLFK5pfYJL22La3I5TsmCyM9iPI8lCORWuwCNjFbKIIC3SM5
         kgaH4im6RnLrMvfRSCHyNAqUNCVW8/8n+K14onFQ=
Date:   Sat, 27 Aug 2022 17:10:54 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch added to mm-unstable branch
Message-Id: <20220828001055.7C0D8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2
Date: Sat Aug 27 05:06:06 PM PDT 2022

fix arch/sparc/kernel/setup_32.c

Reported-by: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/setup_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/setup_32.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2
+++ a/arch/sparc/kernel/setup_32.c
@@ -83,7 +83,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas(0, NULL);
+	show_free_areas(0, NULL, GFP_HIGHUSER_MOVABLE);
 	if (!is_idle_task(current)) {
 		local_irq_enable();
 		ksys_sync();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

