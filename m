Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D42CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjJRVg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF79F187
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C927C07615;
        Wed, 18 Oct 2023 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664923;
        bh=qIDB9Ijm8NrI6T6CCzZQx4RKsbOfCpnqAqUFADXBfXk=;
        h=Date:To:From:Subject:From;
        b=KAhOdSCPdmAfaph45RkrmQ+FhCF0dQNcn9sE6h+998b39iMn96a/08XI05rVjOG0S
         JA74foqhxqIDlyIaMm+lU5O+SaJ+XCsSQ5lp87Na3HG2L7s/NwqlRobggdaLg9dWnN
         trhjIdLttf1ikBl4PixNm36rMXHaEtVDQlVMx2mg=
Date:   Wed, 18 Oct 2023 14:35:22 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        richardcochran@gmail.com, peterz@infradead.org, oleg@redhat.com,
        namhyung@kernel.org, mingo@redhat.com, mark.rutland@arm.com,
        jolsa@kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        irogers@google.com, david@redhat.com, catalin.marinas@arm.com,
        arnd@arndb.de, alexander.shishkin@linux.intel.com,
        adrian.hunter@intel.com, acme@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch removed from -mm tree
Message-Id: <20231018213523.1C927C07615@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: make failure to pin an error if FOLL_NOWAIT not specified
has been removed from the -mm tree.  Its filename was
     mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


