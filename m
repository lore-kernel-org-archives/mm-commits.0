Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4D8C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347381AbjKATrk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347385AbjKATrh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B255C9F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50310C433CB;
        Wed,  1 Nov 2023 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868053;
        bh=pVWYJ4AWpDrvF4xm6K4BY3zlkZDG17ly1/LgwyputqE=;
        h=Date:To:From:Subject:From;
        b=uLGkJV53qAdBBLkgP2YBSgRV4QUKcRzx7KiROckXV4IZpgrqLLtIof0+pm7w/Jv8a
         0igDLcOq7Mw05AGIH2r6C8CZw/W7fB7lnGcu9DqHGrmT/b3BUnayHHMH+Ej4XHVM/I
         mURnDSskf+W41URJBhfcqtLf+SkinZAiM2W9faWw=
Date:   Wed, 01 Nov 2023 12:47:32 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        itaru.kitayama@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch removed from -mm tree
Message-Id: <20231101194733.50310C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/testing/selftests/mm/run_vmtests.sh: lower the ptrace permissions
has been removed from the -mm tree.  Its filename was
     lower-the-ptrace-permissions-so-that-the-memfd_secrect-test-program-runs-without-an-issue.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -303,6 +303,7 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
_

Patches currently in -mm which might be from itaru.kitayama@linux.dev are


