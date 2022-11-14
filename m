Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3F6C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Nov 2022 22:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiKNWS7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiKNWSp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 17:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5A664E3
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 14:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6B061242
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 22:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68634C433C1;
        Mon, 14 Nov 2022 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668464323;
        bh=Wu5smZ6rfZ6NlLVkaMgZxwACuGO/6IYDNh15DfnNe8U=;
        h=Date:To:From:Subject:From;
        b=QL0Qnpbf2kPNk352PEbp5BoyEeyIV/vi9Zb0B7aJZqfTIFzLQOpDF3fS0N15nGKIf
         ZPIMCZcOfAuDMFLGT6sFvlCWVO1/OLeNu9OcXQOhErD9z3xDUJ3Hmer0sbArIp4cJQ
         rlc1skuDq0BQ2+GTFEnE4EojXsOyPVQnYoeVcJM8=
Date:   Mon, 14 Nov 2022 14:18:42 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221114221843.68634C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix.patch

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
Subject: mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix
Date: Mon Nov 14 02:18:00 PM PST 2022

fix comment

Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix
+++ a/mm/damon/sysfs.c
@@ -2339,7 +2339,7 @@ static int damon_sysfs_upd_schemes_stats
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_stats *sysfs_stats;
 
-		/* user could removed the scheme sysfs dir */
+		/* user could have removed the scheme sysfs dir */
 		if (schemes_idx >= sysfs_schemes->nr)
 			break;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-sysfs-schemes-skip-stats-update-if-the-scheme-directory-is-removed-fix.patch
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
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

