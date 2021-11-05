Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29354C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D7960EDF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhKEUos (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhKEUor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A442B61058;
        Fri,  5 Nov 2021 20:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144927;
        bh=nYdau/qBbFk7p6piO1+LGvw11sptEtBQiL3aI5eQy4g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Vn/hPOMatXoc6Yvnv+JvQYCtC8+EvFIl5wN47Vudmh3nrcTwiY5smK6oAc1IV3kis
         8MgvKKCXniCDIOO1WykwX+XJBSs54TrDIZdozDClPgBH6tBGfbycaaXwUcxBuWES7l
         7TaFNz5C9DlYsgqLqmmltEPinMRNyN7o6lGkM0yQ=
Date:   Fri, 05 Nov 2021 13:42:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        shuah@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 143/262] userfaultfd/selftests: don't rely on GNU
 extensions for random numbers
Message-ID: <20211105204207.leuiYoT1g%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: don't rely on GNU extensions for random numbers

Patch series "Small userfaultfd selftest fixups", v2.


This patch (of 3):

Two arguments for doing this:

First, and maybe most importantly, the resulting code is significantly
shorter / simpler.

Then, we avoid using GNU libc extensions.  Why does this matter?  It makes
testing userfaultfd with the selftest easier e.g.  on distros which use
something other than glibc (e.g., Alpine, which uses musl); basically, it
makes the test more portable.

Link: https://lkml.kernel.org/r/20210930212309.4001967-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
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
 
@@ -518,22 +519,10 @@ static void continue_range(int ufd, __u6
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
@@ -541,15 +530,8 @@ static void *locking_thread(void *arg)
 
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
