Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165A2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiEJA2U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiEJA2U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:28:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4542449907
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A1B9CE13E6
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98315C385C6;
        Tue, 10 May 2022 00:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652142260;
        bh=HRSSkGHnu6qCSn7x+eEyZhDgQRcxpd1qAcnddrTOsLg=;
        h=Date:To:From:Subject:From;
        b=Kta/dDfCLVcJ+neG86O2R2eM/Jm2cYUeHDmm/8tuGb+l2+Oftow5SPgu+vPOZQ1Ef
         a19UzOmLSjaqGfy2xTvxv1vP0bEe2bOZV7AodlhFhrZSuZywFdVZdy+mXLEMNu6D1F
         70clJm/WJHzh7hDJYPPQtcYD7vO+RPDBXOCln42A=
Date:   Mon, 09 May 2022 17:24:19 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, npache@redhat.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-clarify-common-error-when-running-gup_test.patch added to mm-unstable branch
Message-Id: <20220510002420.98315C385C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: clarify common error when running gup_test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-clarify-common-error-when-running-gup_test.patch

This patch should soon appear in the mm-unstable branch at
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
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests: clarify common error when running gup_test

The gup_test binary will fail showing only the output of perror("open") in
the case that /sys/kernel/debug/gup_test is not found. This will almost
always be due to CONFIG_GUP_TEST not being set, which enables
compilation of a kernel that provides this file.

Add a short error message to clarify this failure and point the user to
the solution.

Link: https://lkml.kernel.org/r/20220502224942.995427-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/gup_test.c~selftests-clarify-common-error-when-running-gup_test
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -21,6 +21,8 @@
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 
+#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
+
 static unsigned long cmd = GUP_FAST_BENCHMARK;
 static int gup_fd, repeats = 1;
 static unsigned long size = 128 * MB;
_

Patches currently in -mm which might be from jsavitz@redhat.com are

selftests-vm-makefile-rename-targets-to-vmtargets.patch
selftests-clarify-common-error-when-running-gup_test.patch

