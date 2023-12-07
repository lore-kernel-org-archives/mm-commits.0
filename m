Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E51C10DC3
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjLGWEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443998AbjLGWEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9652410D8
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325C4C433C8;
        Thu,  7 Dec 2023 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986678;
        bh=8/cZcpK3H4nKtpWJJOMz0kWXr3Lpx//Xvwi96lQaZhA=;
        h=Date:To:From:Subject:From;
        b=Cgc6ACv2EMcXUe7G4UGtc4XKWBSLz1geRv5klOTkz5+vF40kHeB9PArytmUgxC6xy
         OlP0TvbsgHXE1H2SI9d2BSHr9cxKuOUcPrWoh3cUslHGDjfsk7hgqExl4eug41hQPc
         /gtRD3OhW8AF1eH287FE8MU21wBQiKBTDmtVx6gs=
Date:   Thu, 07 Dec 2023 14:04:37 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-kugepaged-restore-thp-settings-at-exit.patch added to mm-unstable branch
Message-Id: <20231207220438.325C4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm/kugepaged: restore thp settings at exit
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-kugepaged-restore-thp-settings-at-exit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-kugepaged-restore-thp-settings-at-exit.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm/kugepaged: restore thp settings at exit
Date: Thu, 7 Dec 2023 16:12:06 +0000

Previously, the saved thp settings would be restored upon a signal or at
the natural end of the test suite.  But there are some tests that directly
call exit() upon failure.  In this case, the thp settings were not being
restored, which could then influence other tests.

Fix this by installing an atexit() handler to do the actual restore.  The
signal handler can now just call exit() and the atexit handler is invoked.

Link: https://lkml.kernel.org/r/20231207161211.2374093-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-kugepaged-restore-thp-settings-at-exit
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -374,18 +374,22 @@ static void pop_settings(void)
 	write_settings(current_settings());
 }
 
-static void restore_settings(int sig)
+static void restore_settings_atexit(void)
 {
 	if (skip_settings_restore)
-		goto out;
+		return;
 
 	printf("Restore THP and khugepaged settings...");
 	write_settings(&saved_settings);
 	success("OK");
-	if (sig)
-		exit(EXIT_FAILURE);
-out:
-	exit(exit_status);
+
+	skip_settings_restore = true;
+}
+
+static void restore_settings(int sig)
+{
+	/* exit() will invoke the restore_settings_atexit handler. */
+	exit(sig ? EXIT_FAILURE : exit_status);
 }
 
 static void save_settings(void)
@@ -415,6 +419,7 @@ static void save_settings(void)
 
 	success("OK");
 
+	atexit(restore_settings_atexit);
 	signal(SIGTERM, restore_settings);
 	signal(SIGINT, restore_settings);
 	signal(SIGHUP, restore_settings);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

