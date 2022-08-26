Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B20ECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 02:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiHZCCF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 22:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244603AbiHZCCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 22:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BECCAC71
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 19:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518C561E0E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 02:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F18C433C1;
        Fri, 26 Aug 2022 02:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661479321;
        bh=YN/ebvbGP/w0PFevMLvpSlvTcmQ0bM4dIpy4XaBEh90=;
        h=Date:To:From:Subject:From;
        b=Tbbs6UnJJaVerzsBcLDZL+NIlfe05tOM3SXUf4BeCF6H1is/jd3wpeZb+q/3UoYlc
         7LgLIqNzkxajv/PhzNUAoG0tPzy2nJCan+ohW0jbP1wLs9YvYTp6W6V5QmtsCUYEqP
         vxA/7FZtBgvXZk9shwPvRv24mNkag9We3sZVU0YA=
Date:   Thu, 25 Aug 2022 19:02:01 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, liushixin2@huawei.com, ddstreet@ieee.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch added to mm-unstable branch
Message-Id: <20220826020201.A4F18C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch

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
Subject: mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
Date: Thu Aug 25 06:59:19 PM PDT 2022

s/init_zswap/zswap_init/

Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix
+++ a/mm/zswap.c
@@ -1556,7 +1556,7 @@ cache_fail:
 	return -ENOMEM;
 }
 
-static int __init init_zswap(void)
+static int __init zswap_init(void)
 {
 	/* skip init if zswap is disabled when system startup */
 	if (!zswap_enabled)
@@ -1565,7 +1565,7 @@ static int __init init_zswap(void)
 }
 
 /* must be late so crypto has time to come up */
-late_initcall(init_zswap);
+late_initcall(zswap_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Seth Jennings <sjennings@variantweb.net>");
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
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

