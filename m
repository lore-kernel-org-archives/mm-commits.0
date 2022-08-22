Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4ADC00140
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 03:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiHVDB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Aug 2022 23:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiHVDB6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Aug 2022 23:01:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BADC18371
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 20:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7EFE60B06
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 03:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C39C433C1;
        Mon, 22 Aug 2022 03:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661137316;
        bh=WPYoA3BPGvv/4pjnUVQLomwbggEE6wRZN6LIH4KyliU=;
        h=Date:To:From:Subject:From;
        b=ZTuvZyaNDT6kyjIKHyk7HmkRRwthio48yqFM1ZsCOt8HBVg0jZ47/VUGWy/zMFz9k
         4gjKcRlLH1FpLBMfIn3jWKYPa7wBhuKfB77C8KH4mg7dj23CSCDACfIeCsroNm4KBU
         8/pEaM6zMJrE49Ken8HsM1DFclttlhR5/QB0UJak=
Date:   Sun, 21 Aug 2022 20:01:55 -0700
To:     mm-commits@vger.kernel.org, syoshida@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch added to mm-unstable branch
Message-Id: <20220822030156.25C39C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch

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
Subject: mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
Date: Sun Aug 21 08:00:31 PM PDT 2022

fix code layout, per John

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
+++ a/mm/gup.c
@@ -2075,11 +2075,13 @@ static long __gup_longterm_locked(struct
 					       NULL, gup_flags);
 	flags = memalloc_pin_save();
 	do {
-		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-							  NULL, gup_flags);
+		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
+							  pages, vmas, NULL,
+							  gup_flags);
 		if (nr_pinned_pages <= 0)
 			break;
-		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages, gup_flags);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
+						     gup_flags);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

