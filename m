Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FD3C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbjHKXNg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbjHKXNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8280444A2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 223B3666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C19C433C8;
        Fri, 11 Aug 2023 23:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794939;
        bh=BzNU30WlMroF8wEFq8Oi5ypt4/7Ki3NpkpyyxcLHMIU=;
        h=Date:To:From:Subject:From;
        b=yhXTFm5gMeAU+0mhZeRXwLSWSlBHvNiugSjZA4MXGqeFTrQRGbrfKCY9cbnzBPSq8
         +ZbyyD2pmdwTbK9y64VqaEWCCbeDBsQyw0Mzg1U4wZEj2uMiVu+BlIpm6G4l9QR/hp
         9jZ7KMJHuDYqnrZxBeN1esyPOKzocDBvDy8qq97E=
Date:   Fri, 11 Aug 2023 16:02:19 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-make-migration-test-robust-to-failure.patch removed from -mm tree
Message-Id: <20230811230219.74C19C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: make migration test robust to failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-make-migration-test-robust-to-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: make migration test robust to failure
Date: Mon, 24 Jul 2023 09:25:20 +0100

The `migration` test currently has a number of robustness problems that
cause it to hang and leak resources.

Timeout: There are 3 tests, which each previously ran for 60 seconds. 
However, the timeout in mm/settings for a single test binary was set to 45
seconds.  So when run using run_kselftest.sh, the top level timeout would
trigger before the test binary was finished.  Solve this by meeting in the
middle; each of the 3 tests now runs for 20 seconds (for a total of 60),
and the top level timeout is set to 90 seconds.

Leaking child processes: the `shared_anon` test fork()s some children but
then an ASSERT() fires before the test kills those children.  The assert
causes immediate exit of the parent and leaking of the children. 
Furthermore, if run using the run_kselftest.sh wrapper, the wrapper would
get stuck waiting for those children to exit, which never happens.  Solve
this by setting the "parent death signal" to SIGHUP in the child, so that
the child is killed automatically if the parent dies.

With these changes, the test binary now runs to completion on arm64, with
2 tests passing and the `shared_anon` test failing.

Link: https://lkml.kernel.org/r/20230724082522.1202616-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   12 +++++++++---
 tools/testing/selftests/mm/settings    |    2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-make-migration-test-robust-to-failure
+++ a/tools/testing/selftests/mm/migration.c
@@ -10,12 +10,13 @@
 #include <numa.h>
 #include <numaif.h>
 #include <sys/mman.h>
+#include <sys/prctl.h>
 #include <sys/types.h>
 #include <signal.h>
 #include <time.h>
 
 #define TWOMEG (2<<20)
-#define RUNTIME (60)
+#define RUNTIME (20)
 
 #define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 
@@ -155,10 +156,15 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 	memset(ptr, 0xde, TWOMEG);
 	for (i = 0; i < self->nthreads - 1; i++) {
 		pid = fork();
-		if (!pid)
+		if (!pid) {
+			prctl(PR_SET_PDEATHSIG, SIGHUP);
+			/* Parent may have died before prctl so check now. */
+			if (getppid() == 1)
+				kill(getpid(), SIGHUP);
 			access_mem(ptr);
-		else
+		} else {
 			self->pids[i] = pid;
+		}
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
--- a/tools/testing/selftests/mm/settings~selftests-mm-make-migration-test-robust-to-failure
+++ a/tools/testing/selftests/mm/settings
@@ -1 +1 @@
-timeout=45
+timeout=90
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


