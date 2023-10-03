Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84ADDE7AD7A
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 17:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjJCRPW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjJCRPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 13:15:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04C5AF
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 10:15:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320B2C433C7;
        Tue,  3 Oct 2023 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696353318;
        bh=CB3GQUpdpFHAfDOFzmb9Hr7nqCHSAIc7F4WVMnsJV0s=;
        h=Date:To:From:Subject:From;
        b=S8pNKnNIC39/L6AI4bWGQn9Vt3OWvVZUqTlZ4CFZNDlR8ju6yD8u+dPtKFecz/pHU
         Bxb0irC+otZfg3MZS6Y/FLCdmt4Lhw1g539MXKip2SIEhJ7lI/frckTfZfSXH7Me9l
         45+DBSh/Z6URhwHNikym0ozxP2AJa+yM/b24Bcig=
Date:   Tue, 03 Oct 2023 10:15:17 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch added to mm-unstable branch
Message-Id: <20231003171518.320B2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: make failure to pin an error if FOLL_NOWAIT not specified
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch

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
Subject: mm/gup: make failure to pin an error if FOLL_NOWAIT not specified
Date: Tue, 3 Oct 2023 00:14:53 +0100

There really should be no circumstances under which a non-FOLL_NOWAIT GUP
operation fails to return any pages, so make this an error and warn on it.

To catch the trivial case, simply exit early if nr_pages == 0.

This brings __get_user_pages_locked() in line with the behaviour of its
nommu variant.

Link: https://lkml.kernel.org/r/2a42d96dd1e37163f90a0019a541163dafb7e4c3.1696288092.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/gup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/gup.c~mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified
+++ a/mm/gup.c
@@ -1471,6 +1471,9 @@ static __always_inline long __get_user_p
 	long ret, pages_done;
 	bool must_unlock = false;
 
+	if (!nr_pages)
+		return 0;
+
 	/*
 	 * The internal caller expects GUP to manage the lock internally and the
 	 * lock must be released when this returns.
@@ -1595,6 +1598,14 @@ retry:
 		mmap_read_unlock(mm);
 		*locked = 0;
 	}
+
+	/*
+	 * Failing to pin anything implies something has gone wrong (except when
+	 * FOLL_NOWAIT is specified).
+	 */
+	if (WARN_ON_ONCE(pages_done == 0 && !(flags & FOLL_NOWAIT)))
+		return -EFAULT;
+
 	return pages_done;
 }
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch

