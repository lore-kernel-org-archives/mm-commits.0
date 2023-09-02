Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229F4C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjIBXcv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBXcu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:32:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02BF11A
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B50960C08
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65D3C433C7;
        Sat,  2 Sep 2023 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693697566;
        bh=FA8Ru2hcUOtwBB/opMOlITPsmrYw/E7UaTfROWJwbLU=;
        h=Date:To:From:Subject:From;
        b=S1NttUe58m5ZRtkb7+6eZ5BMSjzRpPhQ+Ljrvnkhp56XVmO7LWogfmaq8JD2v79G/
         476EAEGKp+KVOX2mJaWhINd295v4gQKm0TKo6rZFhDtUdDr7YyJvnpZ74RWLg0PwIw
         /ScMIdY4ziVj5ejjNR2gR2UMJpXa/BJVS7l0uZPY=
Date:   Sat, 02 Sep 2023 16:32:45 -0700
To:     mm-commits@vger.kernel.org, dingxiang@cmss.chinamobile.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_longterm-fix-a-resource-leak.patch added to mm-unstable branch
Message-Id: <20230902233246.C65D3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: gup_longterm: fix a resource leak
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gup_longterm-fix-a-resource-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_longterm-fix-a-resource-leak.patch

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
From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: selftests/mm: gup_longterm: fix a resource leak
Date: Thu, 31 Aug 2023 17:31:44 +0800

The opened file should be closed in run_with_tmpfile(), otherwise resource
leak will occur

Link: https://lkml.kernel.org/r/20230831093144.7520-1-dingxiang@cmss.chinamobile.com
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-fix-a-resource-leak
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -265,10 +265,11 @@ static void run_with_tmpfile(test_fn fn,
 	fd = fileno(file);
 	if (fd < 0) {
 		ksft_test_result_fail("fileno() failed\n");
-		return;
+		goto close;
 	}
 
 	fn(fd, pagesize);
+close:
 	fclose(file);
 }
 
_

Patches currently in -mm which might be from dingxiang@cmss.chinamobile.com are

selftests-mm-gup_longterm-fix-a-resource-leak.patch

