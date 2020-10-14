Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8934C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C8A722261
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709263;
	bh=ks+nr5nDT2+P+0NXOFKEIzO+YrP1MV+p4qqlXU6UfYc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U2NosvirE8X+eJoKyegVuaulNLYc2kYT+5WxZRGHEKI5FBBPPZ8pK7eKG30VKHTQi
	 rjxTBtcXYTN3j0jviQXjwK9lnoNyLJzozfozTs9OXTrFogaFh9YSRCgtqcSO2qrppp
	 IzahDYvQdjHFPqbL1XR54I9MOllo83kRLIUF3WPA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgJNVBC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgJNVBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C025322248;
        Wed, 14 Oct 2020 21:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709237;
        bh=ks+nr5nDT2+P+0NXOFKEIzO+YrP1MV+p4qqlXU6UfYc=;
        h=Date:From:To:Subject:From;
        b=fJ7U+pd9V9JYN3yhNzEIEZO52FspsEbtqf8V4peHwVakx6/MQPPdrNpeYkM9JKnc3
         1oclztXQaMDDIYWOQjlueL5FJBZRRWIzh+aw+kYJozvJF/jRs0X8fg7q5aYzN1JY88
         ZHBHndGJGjap7XAybhMntGYczsRW8gdZ1CeDeT5w=
Date:   Wed, 14 Oct 2020 14:00:36 -0700
From:   akpm@linux-foundation.org
To:     jgg@ziepe.ca, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        shuah@kernel.org
Subject:  [merged]
 selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
 removed from -mm tree
Message-ID: <20201014210036.ARZq4Bkxy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix false build success on the second and later attempts
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: fix false build success on the second and later attempts

Patch series "selftests/vm: fix some minor aggravating factors in the Makefile".

This fixes a couple of minor aggravating factors that I ran across while
trying to do some changes in selftests/vm.  These are simple things, but
like most things with GNU Make, it's rarely obvious what's wrong until you
understand *the entire Makefile and all of its includes*.

So while there is, of course, joy in learning those details, I thought I'd
fix these little things, so as to allow others to skip out on the Joy if
they so choose.  :)

First of all, if you have an item (let's choose userfaultfd for an
example) that fails to build, you might do this:

$ make -j32

    # ...you observe a failed item in the threaded output

# OK, let's get a closer look

$ make
    # ...but now the build quietly "succeeds".

That's what Patch 0001 fixes.

Second, if you instead attempt this approach for your closer look (a casual
mistake, as it's not supported):

$ make userfaultfd

    # ...userfaultfd fails to link, due to incomplete LDLIBS

That's what Patch 0002 fixes.


This patch (of 2):

If one or more of these selftest fail to build, then after the first
failure, subsequent invocations of "make" will make it appear that there
are no build failures, after all.

That's because the failed build products remain, with up-to-date
timestamps, thus tricking Make (and you!) into believing that there's
nothing else to build.

Fix this by telling Make to delete targets that didn't completely
succeed.

Link: https://lkml.kernel.org/r/20200915012901.1655280-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20200915012901.1655280-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-false-build-success-on-the-second-and-later-attempts
+++ a/tools/testing/selftests/vm/Makefile
@@ -3,6 +3,11 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/')
 
+# Without this, failed build products remain, with up-to-date timestamps,
+# thus tricking Make (and you!) into believing that All Is Well, in subsequent
+# make invocations:
+.DELETE_ON_ERROR:
+
 CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
 LDLIBS = -lrt
 TEST_GEN_FILES = compaction_test
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

