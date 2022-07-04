Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3538C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiGDBKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiGDBKJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A0B632F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9155C61303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3955C341C7;
        Mon,  4 Jul 2022 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897004;
        bh=/QA94FCE+M1BF8iG3bLNEUeCVGCM3viSjyNbo8/hpKg=;
        h=Date:To:From:Subject:From;
        b=jXtIrpiMfcpj9/tMZGU8tDrGyIwdBGafsMpGaj6I6A90ssyhei9X5HWQscV7OOJAX
         5ab/zL4Hf27lS63MwAOPslzgot917swsA2K+YP5aMRjtf5f25/97jP7B+wc/IfsZ4m
         AP1ML0TveEJFo4IDbTkHxen3b4z/YQHrcXBPC0S8=
Date:   Sun, 03 Jul 2022 18:10:03 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, edliaw@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-selftests-infinite-loop-in-faulting_process.patch removed from -mm tree
Message-Id: <20220704011003.E3955C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: selftests: infinite loop in faulting_process
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-infinite-loop-in-faulting_process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-infinite-loop-in-faulting_process
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -931,7 +931,7 @@ static int faulting_process(int signal_t
 	unsigned long split_nr_pages;
 	unsigned long lastnr;
 	struct sigaction act;
-	unsigned long signalled = 0;
+	volatile unsigned long signalled = 0;
 
 	split_nr_pages = (nr_pages + 1) / 2;
 
@@ -946,7 +946,7 @@ static int faulting_process(int signal_t
 	}
 
 	for (nr = 0; nr < split_nr_pages; nr++) {
-		int steps = 1;
+		volatile int steps = 1;
 		unsigned long offset = nr * page_size;
 
 		if (signal_test) {
_

Patches currently in -mm which might be from edliaw@google.com are


