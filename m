Return-Path: <SRS0=eNRM=DK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C2CC4363C
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 01:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3828F206FA
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 01:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601686856;
	bh=x3gAE/nOYInd+iPttFaupiNFpGv9PNTRZ3qKZCTo0jk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZbL1r1vJP443VX4YJYXf+I6B06Gpg1aZuFREHcJIkhRUL0qqSrq3De6NZiocMbQPk
	 +IEDH1Vw6amYLJ2pOqTaV3UHoh9C26MuPN4mpLhOUAJM/idwkq3PJLWp/Q7IR1zRbe
	 FUaJSC6RlYSZkVX6G1b876m6qafeNkbiP0aASZWU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCBAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJCBAz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 21:00:55 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9988206F8;
        Sat,  3 Oct 2020 01:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601686855;
        bh=x3gAE/nOYInd+iPttFaupiNFpGv9PNTRZ3qKZCTo0jk=;
        h=Date:From:To:Subject:From;
        b=cBFrILz7tEWvN2ZiHBnP7zuzaqqLrGBwE4x0yzQCtuyyNejmmmYoAPbW8BuXIocZQ
         P9147XK11uKx3tgQ4VHZftNLuU2A8/ecr4+81O+RAW4HO9NO7R38PJAAxm7IWfWI3o
         k5opps8z2LC6cFHstuJ2wfr8obP0dOzo2zx9YNDM=
Date:   Fri, 02 Oct 2020 18:00:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com
Subject:  +
 selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch added to
 -mm tree
Message-ID: <20201003010054.M-moQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix an improper dependency upon executable script permissions
has been added to the -mm tree.  Its filename is
     selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: fix an improper dependency upon executable script permissions

commit 30fb9454ab23 ("selftests/vm: hmm-tests: remove the libhugetlbfs
dependency") created the new check_config.sh file without the execute bit
set.  This is a problem because that same commit caused the Makefile to
invoke it "./check_config.sh", so now "make" is failing in that directory.

Scripts are not supposed to depend on the executable bit being set,
because patch(1) doesn't set it, and using patch to install a kernel is
supported.  Therefore, this fix involves two parts:

1) Invoke the new script via /bin/sh, to fix the problem, and

2) As an nice touch, make check_config.sh executable as well.

Link: https://lkml.kernel.org/r/20201003002142.32671-2-jhubbard@nvidia.com
Fixes: commit 30fb9454ab23 ("selftests/vm: hmm-tests: remove the libhugetlbfs dependency")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix
+++ a/tools/testing/selftests/vm/Makefile
@@ -138,7 +138,7 @@ $(OUTPUT)/hmm-tests: local_config.h
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
 
 local_config.mk local_config.h: check_config.sh
-	./check_config.sh $(CC)
+	/bin/sh ./check_config.sh $(CC)
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages==-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
selftests-vm-8x-compaction_test-speedup.patch
mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch

