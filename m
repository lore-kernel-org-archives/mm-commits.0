Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A9DC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E23B221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633200;
	bh=lCkb3PvR2jjW6DW/odhG09xb7s3/aFYH4Vj5nZNaPFY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GJpFK5l9SWelZgLriyL6jCZEWYTok9rw1VUFQeurHYHZ9uY7I6qGF3P/ON0kN4m/7
	 TeiaVyOK3tH5YS5vJ0uw++ZokAWewzqExQOZFCiORP1YucxYzHB19nAnPJwFP7eS5t
	 bDrfzF1ozE5aSqX1ksTJKSfXE8x66B3zqP64fbFU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgJMXxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730095AbgJMXxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF44206D5;
        Tue, 13 Oct 2020 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633197;
        bh=lCkb3PvR2jjW6DW/odhG09xb7s3/aFYH4Vj5nZNaPFY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UeaXDDsHOTx+eygtx2HyyEj4PZuxsJEGPwRMdYSuLZ1GfGAVBI01EEVjIivN669rY
         EfFV1TTQEHciS6RBDR308KN2S7nrYiDIk2cPGoTJ06TSSCveU9t3Sx4LOqCRUsv8Qi
         y2OVPyXezjqFs8hGutStcV/vygMOq308XqyrPt7o=
Date:   Tue, 13 Oct 2020 16:53:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 090/181] selftests/vm: fix false build success on
 the second and later attempts
Message-ID: <20201013235316.DFq97JmOZ%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
