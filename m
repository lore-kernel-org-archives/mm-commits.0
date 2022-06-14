Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BD0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jun 2022 18:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiFNSBQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Jun 2022 14:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiFNSBP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2022 14:01:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360BC2A273
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 11:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B3F6175D
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 18:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C7C3411B;
        Tue, 14 Jun 2022 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655229673;
        bh=asjedtuFgjhkBpp9oLNmA1ktINxDKfzUETqpUGLT+1s=;
        h=Date:To:From:Subject:From;
        b=Rpq1IT6ObGn0UU+UErAbLHVWHs+EWhxRK3hv50r1WIOZdZ/rVOIcjRfjrcKIZQeJ9
         2myNE67jktjn9bTDQjyG6cuvibODsAh+F+sYQYHJiRvlxmE0MLNp3qyThz+rCWCNik
         9qKVqTyuSv8xYtFQDf4Ky6TE4ru+u1HBVbhx4aS0=
Date:   Tue, 14 Jun 2022 11:01:12 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, edliaw@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-infinite-loop-in-faulting_process.patch added to mm-unstable branch
Message-Id: <20220614180113.1A8C7C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: infinite loop in faulting_process
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-selftests-infinite-loop-in-faulting_process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-selftests-infinite-loop-in-faulting_process.patch

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
From: Edward Liaw <edliaw@google.com>
Subject: userfaultfd: selftests: infinite loop in faulting_process
Date: Mon, 13 Jun 2022 23:33:21 +0000

On Android this test is getting stuck in an infinite loop due to
indeterminate behavior:

The local variables steps and signalled were being reset to 1 and 0
respectively after every jump back to sigsetjmp by siglongjmp in the
signal handler.  The test was incrementing them and expecting them to
retain their incremented values.  The documentation for siglongjmp says:

All accessible objects have values as of the time sigsetjmp() was called,
except that the values of objects of automatic storage duration which are
local to the function containing the invocation of the corresponding
sigsetjmp() which do not have volatile-qualified type and which are
changed between the sigsetjmp() invocation and siglongjmp() call are
indeterminate.

Tagging steps and signalled with volatile enabled the test to pass.

Link: https://lkml.kernel.org/r/20220613233321.431282-1-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-infinite-loop-in-faulting_process
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -963,7 +963,7 @@ static int faulting_process(int signal_t
 	unsigned long split_nr_pages;
 	unsigned long lastnr;
 	struct sigaction act;
-	unsigned long signalled = 0;
+	volatile unsigned long signalled = 0;
 
 	split_nr_pages = (nr_pages + 1) / 2;
 
@@ -978,7 +978,7 @@ static int faulting_process(int signal_t
 	}
 
 	for (nr = 0; nr < split_nr_pages; nr++) {
-		int steps = 1;
+		volatile int steps = 1;
 		unsigned long offset = nr * page_size;
 
 		if (signal_test) {
_

Patches currently in -mm which might be from edliaw@google.com are

userfaultfd-selftests-infinite-loop-in-faulting_process.patch

