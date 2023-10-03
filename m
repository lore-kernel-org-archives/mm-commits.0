Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7356EE7AD78
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjJCRPV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjJCRPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:15:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C547A6
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:15:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DFC433C8;
        Tue,  3 Oct 2023 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696353316;
        bh=f33mzEeat2IOWaUuaU8k9hQWQGws5zO2uI12ZsDPmEM=;
        h=Date:To:From:Subject:From;
        b=d8S4ELg0zDZSVLe1RpFz0S7+6kohr7JdLn1hyKt2/48LkWIk3+mYFHk2JcGAnwbsD
         rc7NFoB0b+VlWgLNdWD5+MFvRsAO2OqJTNlh1UBnUgZVwbxrfrEunHgmpfHQMZbtuw
         QFdybD5Cdv/o5/9sMB3LJpU796bbs1bKk03hiQCU=
Date:   Tue, 03 Oct 2023 10:15:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch added to mm-unstable branch
Message-Id: <20231003171515.D23DFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: explicitly define and check internal GUP flags, disallow FOLL_TOUCH
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: explicitly define and check internal GUP flags, disallow FOLL_TOUCH
Date: Tue, 3 Oct 2023 00:14:52 +0100

Rather than open-coding a list of internal GUP flags in
is_valid_gup_args(), define which ones are internal.

In addition, explicitly check to see if the user passed in FOLL_TOUCH
somehow, as this appears to have been accidentally excluded.

Link: https://lkml.kernel.org/r/971e013dfe20915612ea8b704e801d7aef9a66b6.1696288092.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c      |    5 ++---
 mm/internal.h |    3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch
+++ a/mm/gup.c
@@ -2227,12 +2227,11 @@ static bool is_valid_gup_args(struct pag
 	/*
 	 * These flags not allowed to be specified externally to the gup
 	 * interfaces:
-	 * - FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
+	 * - FOLL_TOUCH/FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
 	 * - FOLL_REMOTE is internal only and used on follow_page()
 	 * - FOLL_UNLOCKABLE is internal only and used if locked is !NULL
 	 */
-	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_TRIED | FOLL_UNLOCKABLE |
-				      FOLL_REMOTE | FOLL_FAST_ONLY)))
+	if (WARN_ON_ONCE(gup_flags & INTERNAL_GUP_FLAGS))
 		return false;
 
 	gup_flags |= to_set;
--- a/mm/internal.h~mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch
+++ a/mm/internal.h
@@ -1027,6 +1027,9 @@ enum {
 	FOLL_UNLOCKABLE = 1 << 21,
 };
 
+#define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
+			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE)
+
 /*
  * Indicates for which pages that are write-protected in the page table,
  * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

