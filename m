Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732DAC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjHKXGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbjHKXEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D6044A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C20967ADA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B9DC433C7;
        Fri, 11 Aug 2023 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794940;
        bh=/Pd+NeDzP1UtSUxOtTf2vuYY5WPx7XuFVdjKT/SfljI=;
        h=Date:To:From:Subject:From;
        b=TwNnYeVvLBtFj+ZLH5NvlV4GHcN4YWTFRNMf+Mp+DJMXEg+eM70Wiux0eOTb5lzdk
         6tsfY2gDfQUqPuHRgWdyAxonvzQ549I+4wo5ala9ZP6GcxTja5382QFnW/voriiIy8
         upCDlYy3klEP1Wzkc9A5Ut48ychc3wxOWT8avfQU=
Date:   Fri, 11 Aug 2023 16:02:20 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-optionally-pass-duration-to-transhuge-stress.patch removed from -mm tree
Message-Id: <20230811230220.91B9DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: optionally pass duration to transhuge-stress
has been removed from the -mm tree.  Its filename was
     selftests-mm-optionally-pass-duration-to-transhuge-stress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: optionally pass duration to transhuge-stress
Date: Mon, 24 Jul 2023 09:25:21 +0100

Until now, transhuge-stress runs until its explicitly killed, so when
invoked by run_kselftest.sh, it would run until the test timeout, then it
would be killed and the test would be marked as failed.

Add a new, optional command line parameter that allows the user to specify
the duration in seconds that the program should run.  The program exits
after this duration with a success (0) exit code.  If the argument is
omitted the old behacvior remains.

On it's own, this doesn't quite solve our problem because run_kselftest.sh
does not allow passing parameters to the program under test.  But we will
shortly move this to run_vmtests.sh, which does allow parameter passing.

Link: https://lkml.kernel.org/r/20230724082522.1202616-8-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/transhuge-stress.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-optionally-pass-duration-to-transhuge-stress
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -25,13 +25,14 @@ int main(int argc, char **argv)
 {
 	size_t ram, len;
 	void *ptr, *p;
-	struct timespec a, b;
+	struct timespec start, a, b;
 	int i = 0;
 	char *name = NULL;
 	double s;
 	uint8_t *map;
 	size_t map_len;
 	int pagemap_fd;
+	int duration = 0;
 
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
@@ -42,9 +43,11 @@ int main(int argc, char **argv)
 
 	while (++i < argc) {
 		if (!strcmp(argv[i], "-h"))
-			errx(1, "usage: %s [size in MiB]", argv[0]);
+			errx(1, "usage: %s [-f <filename>] [-d <duration>] [size in MiB]", argv[0]);
 		else if (!strcmp(argv[i], "-f"))
 			name = argv[++i];
+		else if (!strcmp(argv[i], "-d"))
+			duration = atoi(argv[++i]);
 		else
 			len = atoll(argv[i]) << 20;
 	}
@@ -78,6 +81,8 @@ int main(int argc, char **argv)
 	if (!map)
 		errx(2, "map malloc");
 
+	clock_gettime(CLOCK_MONOTONIC, &start);
+
 	while (1) {
 		int nr_succeed = 0, nr_failed = 0, nr_pages = 0;
 
@@ -118,5 +123,8 @@ int main(int argc, char **argv)
 		      "%4d succeed, %4d failed, %4d different pages",
 		      s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
 		      nr_succeed, nr_failed, nr_pages);
+
+		if (duration > 0 && b.tv_sec - start.tv_sec >= duration)
+			return 0;
 	}
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


