Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746CFC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 30 Oct 2023 19:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjJ3TKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Oct 2023 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjJ3TKX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Oct 2023 15:10:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EABC6
        for <mm-commits@vger.kernel.org>; Mon, 30 Oct 2023 12:10:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B8CC433C7;
        Mon, 30 Oct 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698693020;
        bh=p8W7K8a8pcLAKkCMgGY90rjMNHbGhEwDmrsYnYNCvZc=;
        h=Date:To:From:Subject:From;
        b=qOIzEK+IhJ55WdymJtMaPN2WdosUWZjOWSWrIEqSKL+zaaPoqVXuQd7WN6nljocOX
         1h0HokwLl4ZMfxHMb1SG5SjSQP47PuNE3/yCbeAueF7HbsHoXdXcYEB9yZnuYBt2bO
         yC0khiMd9a+oCLw2F7XABaIg9F3HSCxK2nkzzAlA=
Date:   Mon, 30 Oct 2023 12:10:19 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        itaru.kitayama@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch added to mm-nonmm-unstable branch
Message-Id: <20231030191020.47B8CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/mm/run_vmtests.sh: lower the ptrace permissions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Subject: tools/testing/selftests/mm/run_vmtests.sh: lower the ptrace permissions
Date: Mon, 30 Oct 2023 17:54:45 +0900

On Ubuntu and probably other distros, ptrace permissions are tightend a
bit by default; i.e., /proc/sys/kernel/yama/ptrace_score is set to 1. 
This cases memfd_secret's ptrace attach test fails with a permission
error.  Set it to 0 piror to running the program.  

Link: https://lkml.kernel.org/r/20231030-selftest-v1-1-743df68bb996@linux.dev
Signed-off-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -309,6 +309,7 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
_

Patches currently in -mm which might be from itaru.kitayama@linux.dev are

lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch

