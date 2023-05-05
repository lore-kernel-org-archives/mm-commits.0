Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8C9C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjEETJG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjEETJF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:09:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F3F1E9A3
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0684D612ED
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A36DC433EF;
        Fri,  5 May 2023 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683313743;
        bh=0Sbg6N/3PleQctm3G/P3imjfAiGqDIptfhBqn0V+oxU=;
        h=Date:To:From:Subject:From;
        b=dxGbYHWBcUa34d9WWIszyydz7Qg3JRsAgmOOlqJSP3V0lYK9kjv6rjNm+gr8qf/NR
         H0HRci2CnZ2QmU35PHh1Wax9IUbsjvIpqB9F1/8crxWUbYWBUwwfsm8lbgKR9pu076
         ASbkMZ1/CsZXm7LFWwpolBACO48Q+Mt64Z+kDBtA=
Date:   Fri, 05 May 2023 12:09:02 -0700
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-add-selftests-for-cachestat-fix.patch added to mm-unstable branch
Message-Id: <20230505190903.5A36DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: fix spelling mistake "trucate" -> "truncate"
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-add-selftests-for-cachestat-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-add-selftests-for-cachestat-fix.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests: fix spelling mistake "trucate" -> "truncate"
Date: Fri, 5 May 2023 12:08:55 +0100

There is a spelling mistake in a message. Fix it.

Link: https://lkml.kernel.org/r/20230505110855.2493457-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-add-selftests-for-cachestat-fix
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -191,7 +191,7 @@ bool test_cachestat_shmem(void)
 	}
 
 	if (ftruncate(fd, filesize)) {
-		ksft_print_msg("Unable to trucate shmem file.\n");
+		ksft_print_msg("Unable to truncate shmem file.\n");
 		ret = false;
 		goto close_fd;
 	}
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-add-selftests-for-cachestat-fix.patch
scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

