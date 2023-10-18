Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124D3CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbjJRVgv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CCF185
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11736C116A5;
        Wed, 18 Oct 2023 21:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664922;
        bh=CzARdzih6KNU+hRkZmTo7HHq+bCNPAs+uxxAe1kbNCU=;
        h=Date:To:From:Subject:From;
        b=NW9TiGRlGCZkBN1XYxWXMeDa0FWaqF1LMNPhfWkD4+8DFD2q1bREHhVcr9vItB6Hb
         cseDIhuew3sE114lU1ZuMKTkO0bhPXHJ5Lr3QNH1JGCcRFAlXVQvq4CBeCC04HuqvC
         5BGeje/J7b5Odx0m4fSrsmLdd+l/OhPJii58bMuI=
Date:   Wed, 18 Oct 2023 14:35:21 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch removed from -mm tree
Message-Id: <20231018213522.11736C116A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: explicitly define and check internal GUP flags, disallow FOLL_TOUCH
has been removed from the -mm tree.  Its filename was
     mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
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
@@ -1017,6 +1017,9 @@ enum {
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


