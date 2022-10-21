Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04E5C3A59D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJUSpd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJUSpb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E607173FCF
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:45:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6967D61F13
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C67C433C1;
        Fri, 21 Oct 2022 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666377927;
        bh=Rz7eMIhPVvhz3ZlNWM2edlNfG1urIJAcgJkXiTrHXrc=;
        h=Date:To:From:Subject:From;
        b=FlIST8Vye7qR4k9ovvIEEh9IOYFixnHhbWhDTNYDkJlYPPRGXGBR5Ug/m9Xxiurne
         0FvabaMJ4We126cM9Kai4eG5Ljej56e9p/ldhcvIIrltnXR2qbM6EYFxCKxHTSgdBH
         8wmuRTzvkLouBmqRrtEZEO0U0aTfC508O7/H465w=
Date:   Fri, 21 Oct 2022 11:45:27 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        shy828301@gmail.com, david@redhat.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch added to mm-unstable branch
Message-Id: <20221021184527.B6C67C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: Fix return value if all subpages of THPs are migrated successfully
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: Fix return value if all subpages of THPs are migrated successfully
Date: Fri, 21 Oct 2022 18:16:23 +0800

During THP migration, if THPs are not migrated but they are split and all
subpages are migrated successfully, migrate_pages() will still return the
number of THP pages that were not migrated.  This will confuse the callers
of migrate_pages().  For example, the longterm pinning will failed though
all pages are migrated successfully.

Thus we should return 0 to indicate that all pages are migrated in this
case.

Link: https://lkml.kernel.org/r/fca6bb0bd48a0292a0ace2fadd0f44579a060cbb.1666335603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/migrate.c~mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully
+++ a/mm/migrate.c
@@ -1582,6 +1582,13 @@ out:
 	 */
 	list_splice(&ret_pages, from);
 
+	/*
+	 * Return 0 in case all subpages of fail-to-migrate THPs are
+	 * migrated successfully.
+	 */
+	if (nr_thp_split && list_empty(from))
+		rc = 0;
+
 	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, nr_failed_pages);
 	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch
mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

