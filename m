Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B6DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC6CA611CE
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhIURlx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhIURlw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 13:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B5361178;
        Tue, 21 Sep 2021 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632246023;
        bh=i8bbzMvTZ/+uV82+q+Y+XABIg277VnncFKI91tPx3WI=;
        h=Date:From:To:Subject:From;
        b=eX8pBTmX/reOZH40YPToTIVhVW6GDDHdudxQZAuDLEhrXsSxv2p2VJR+uwKJjqsw0
         AwL5PDmuOVxBCnRhrMBHqnuxajqbWGmNn6R2Dps/m+Zd6hQZ5Y73wczsQ6JbRYZA2V
         nsqshcHt2n8hM+msOySRQrpgPZUgNEq2a9saM48M=
Date:   Tue, 21 Sep 2021 10:40:23 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  +
 userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch
 added to -mm tree
Message-ID: <20210921174023.2rx3leGYZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: don't rely on GNU extensions for random numbers
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: don't rely on GNU extensions for random numbers

Two arguments for doing this:

First, and maybe most importantly, the resulting code is significantly
shorter / simpler.

Then, we avoid using GNU libc extensions.  Why does this matter?  It makes
testing userfaultfd with the selftest easier e.g.  on distros which use
something other than glibc (e.g., Alpine, which uses musl); basically, it
makes the test more portable.

Link: https://lkml.kernel.org/r/20210921163323.944352-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   26 +++------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -57,6 +57,7 @@
 #include <assert.h>
 #include <inttypes.h>
 #include <stdint.h>
+#include <sys/random.h>
 
 #include "../kselftest.h"
 
@@ -528,22 +529,10 @@ static void continue_range(int ufd, __u6
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
-	struct random_data rand;
 	unsigned long page_nr = *(&(page_nr)); /* uninitialized warning */
-	int32_t rand_nr;
 	unsigned long long count;
-	char randstate[64];
-	unsigned int seed;
 
-	if (bounces & BOUNCE_RANDOM) {
-		seed = (unsigned int) time(NULL) - bounces;
-		if (!(bounces & BOUNCE_RACINGFAULTS))
-			seed += cpu;
-		bzero(&rand, sizeof(rand));
-		bzero(&randstate, sizeof(randstate));
-		if (initstate_r(seed, randstate, sizeof(randstate), &rand))
-			err("initstate_r failed");
-	} else {
+	if (!(bounces & BOUNCE_RANDOM)) {
 		page_nr = -bounces;
 		if (!(bounces & BOUNCE_RACINGFAULTS))
 			page_nr += cpu * nr_pages_per_cpu;
@@ -551,15 +540,8 @@ static void *locking_thread(void *arg)
 
 	while (!finished) {
 		if (bounces & BOUNCE_RANDOM) {
-			if (random_r(&rand, &rand_nr))
-				err("random_r failed");
-			page_nr = rand_nr;
-			if (sizeof(page_nr) > sizeof(rand_nr)) {
-				if (random_r(&rand, &rand_nr))
-					err("random_r failed");
-				page_nr |= (((unsigned long) rand_nr) << 16) <<
-					   16;
-			}
+			if (getrandom(&page_nr, sizeof(page_nr), 0) != sizeof(page_nr))
+				err("getrandom failed");
 		} else
 			page_nr += 1;
 		page_nr %= nr_pages;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-selftests-fix-feature-support-detection.patch
userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch
userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch

