Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187FAC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B6321655
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600221314;
	bh=tSsUgOegjlpBQyNGsFyq9D8V38Fjgbm7kzkH+ZNtx1w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c0liQJZIXhGDvnXItc1sEzCv9dVa9/2l1MuOHgpgL0I1Jx9ociEY/Xkzd+K5pCusg
	 KV3VkMPSeKime+ZnftFBx3EqumZ2h4Gd5PBkXKpYppUyw1iENL3dhUtOL3jAJxjTiL
	 HO6QopK2wWjeH5bjf1Nlc/kpdKbViOA63pmhGaNI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIPBzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgIPBzO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:55:14 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54D802078D;
        Wed, 16 Sep 2020 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600221311;
        bh=tSsUgOegjlpBQyNGsFyq9D8V38Fjgbm7kzkH+ZNtx1w=;
        h=Date:From:To:Subject:From;
        b=Y0D/5uY4v4AdE0WQ4MToadZdo+oCdKooyyRIjhvc0gIu4AZJ92zIrIyeQXf6trUXB
         HHSojfygPMlshaeWRF8J8O68ALGsoolYYoMhbr4/a/tfttTZZyiH6GK73Z9SXt1Syk
         gKusxaE0o/1FSZJule+sksdFq0FBu6OISARcPlsQ=
Date:   Tue, 15 Sep 2020 18:55:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jgg@ziepe.ca,
        jhubbard@nvidia.com
Subject:  +
 selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
 added to -mm tree
Message-ID: <20200916015510.pnhpW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix false build success on the second and later attempts
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch

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

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

