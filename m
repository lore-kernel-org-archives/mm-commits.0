Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAE2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 04:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356972AbiBDEtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243103AbiBDEts (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 23:49:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BD0C061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 20:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0152161B48
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 04:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A87C004E1;
        Fri,  4 Feb 2022 04:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950187;
        bh=lF8DoC9XFDibW5PMa0160z5XrJHiPaP5hlSQbu4HXcI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=N138r+8d3Csc3ShDsM/Y5qqS/cabwqiw1L2Fm8aehaasa/g/x+KcI1chDXnIs4aIa
         7TCBlun3CXU64Q1vYk6oOL5TlferdC4EMEDpR2+s7SShQwoEwZvpurqiFl0ZkGAM0O
         Lnz8I6MK18yP8do9i2LwtaxGLkthZUNIOKalI4Nc=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:45 -0800
Date:   Thu, 03 Feb 2022 20:49:45 -0800
To:     shuah@kernel.org, chi.minghao@zte.com.cn,
        skhan@linuxfoundation.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 10/10] kselftest/vm: revert "tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner"
Message-Id: <20220204044946.31A87C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
