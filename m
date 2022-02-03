Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DC5C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 23:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355943AbiBCXOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 18:14:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42924 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355941AbiBCXN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 18:13:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08E46B835ED
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 23:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBA6C340E8;
        Thu,  3 Feb 2022 23:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643930037;
        bh=HblRQRe5N8x5VafldAkJCnrvoHXbCcWQNW1hQUrQuZc=;
        h=Date:To:From:Subject:From;
        b=aftcGT6BOH1GrAfKKfyh3H038nJSVAtveU+4VrbOgiGcm3bi+/je8/a/EPOH8+q42
         u7sITe0FA7kqmvDjFFlu3EFgudCRP4BYb74q2BtGHJhcWEGPY+JSBRJSFvdJ3FsONi
         KpUhDYx2xa5KOJ7I0ZoUftA7XC+BtWv88sVelo+M=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 15:13:56 -0800
Date:   Thu, 03 Feb 2022 15:13:56 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        chi.minghao@zte.com.cn, skhan@linuxfoundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner.patch added to -mm tree
Message-Id: <20220203231356.AEBA6C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest/vm: revert "tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner"
has been added to the -mm tree.  Its filename is
     kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: kselftest/vm: revert "tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner"

With this change, userfaultfd fails to build with undefined reference
swap() error:

userfaultfd.c: In function `userfaultfd_stress':
userfaultfd.c:1530:17: warning: implicit declaration of function `swap'; did you mean `swab'? [-Wimplicit-function-declaration]
 1530 |                 swap(area_src, area_dst);
      |                 ^~~~
      |                 swab
/usr/bin/ld: /tmp/ccDGOAdV.o: in function `userfaultfd_stress':
userfaultfd.c:(.text+0x549e): undefined reference to `swap'
/usr/bin/ld: userfaultfd.c:(.text+0x54bc): undefined reference to `swap'
collect2: error: ld returned 1 exit status

Revert the commit to fix the problem.

Link: https://lkml.kernel.org/r/20220202003340.87195-1-skhan@linuxfoundation.org
Fixes: 2c769ed7137a ("tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner")
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Minghao Chi <chi.minghao@zte.com.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1417,6 +1417,7 @@ static void userfaultfd_pagemap_test(uns
 static int userfaultfd_stress(void)
 {
 	void *area;
+	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
@@ -1527,9 +1528,13 @@ static int userfaultfd_stress(void)
 					    count_verify[nr], nr);
 
 		/* prepare next bounce */
-		swap(area_src, area_dst);
-
-		swap(area_src_alias, area_dst_alias);
+		tmp_area = area_src;
+		area_src = area_dst;
+		area_dst = tmp_area;
+
+		tmp_area = area_src_alias;
+		area_src_alias = area_dst_alias;
+		area_dst_alias = tmp_area;
 
 		uffd_stats_report(uffd_stats, nr_cpus);
 	}
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are

kselftest-vm-revert-tools-testing-selftests-vm-userfaultfdc-use-swap-to-make-code-cleaner.patch
docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch

