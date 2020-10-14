Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4A1C35257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32ED62224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709317;
	bh=SZerBBwFP+LTUXYiXTlpRt0FAb1mR4uTQh5iHEEtA5Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KolFdSPkyZLKD3g/31cnebfGdyud8bO9/aX16f4/LlaAv0wMLUpH15EvPAwE3XGkZ
	 MAkbiGiXLb7/3r+Q5yFyFWic6/Wo4Pc6iu2nbRinc2ESS0VrzJ5oldzaOXNqvo+WKy
	 Xi/f3wSpTbmLtQoXdvG36kyQhbiC8W0pOQTlYV1c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgJNVBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgJNVBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EEED2224D;
        Wed, 14 Oct 2020 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709239;
        bh=SZerBBwFP+LTUXYiXTlpRt0FAb1mR4uTQh5iHEEtA5Q=;
        h=Date:From:To:Subject:From;
        b=kQ0btEn1jMnQCH4fU3vWO6r3Yz7p3+QrNZGb2WBd6GUh5j2KGlSVeGkZH9xuoqSR/
         t6Nq6fIJ8tCMdRrcUke9kCLudJGUEP7wkZ6GxeRmTDaYkUFhXh5LVCxpsZA0Vx5K5i
         69yPmMo8lbzpxZyfCidOBHpPEbwRkdrmrWp2kAYQ=
Date:   Wed, 14 Oct 2020 14:00:39 -0700
From:   akpm@linux-foundation.org
To:     jgg@ziepe.ca, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        shuah@kernel.org
Subject:  [merged]
 selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch removed from
 -mm tree
Message-ID: <20201014210039.yQ2feg2rf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix incorrect gcc invocation in some cases
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: fix incorrect gcc invocation in some cases

Avoid accidental wrong builds, due to built-in rules working just a little
bit too well--but not quite as well as required for our situation here.

In other words, "make userfaultfd" (for example) is supposed to fail to
build at all, because this Makefile only supports either "make" (all), or
"make /full/path".  However, the built-in rules, if not suppressed, will
pick up CFLAGS and the initial LDLIBS (but not the target-specific LDLIBS,
because those are only set for the full path target!).  This causes it to
get pretty far into building things despite using incorrect values such as
an *occasionally* incomplete LDLIBS value.

Link: https://lkml.kernel.org/r/20200915012901.1655280-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-incorrect-gcc-invocation-in-some-cases
+++ a/tools/testing/selftests/vm/Makefile
@@ -8,6 +8,18 @@ MACHINE ?= $(shell echo $(uname_M) | sed
 # make invocations:
 .DELETE_ON_ERROR:
 
+# Avoid accidental wrong builds, due to built-in rules working just a little
+# bit too well--but not quite as well as required for our situation here.
+#
+# In other words, "make userfaultfd" is supposed to fail to build at all,
+# because this Makefile only supports either "make" (all), or "make /full/path".
+# However,  the built-in rules, if not suppressed, will pick up CFLAGS and the
+# initial LDLIBS (but not the target-specific LDLIBS, because those are only
+# set for the full path target!). This causes it to get pretty far into building
+# things despite using incorrect values such as an *occasionally* incomplete
+# LDLIBS.
+MAKEFLAGS += --no-builtin-rules
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

