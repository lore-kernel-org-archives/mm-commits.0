Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81FEC433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775FA2078D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600221321;
	bh=f6kYVDW4E05xGj46qoL7kwQt3XA6l3+HAWQ743mLrVM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Tw7apF3nNesJHvyeB6DvRWFwz5xVXBaqc82JeQ1kl6yn3S8esAurmdCHgTYjlLRJ+
	 6hrAowgvMPUUr1WlkXZCeN1RTt0vMPv3Ov2U7Oc59GrXYQJExqOvhmU/ISl+ayMfYr
	 bcRuMh5sMt3KG5lvWUuJAtczkMnyHr4WN2Pqolt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgIPBzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgIPBzO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:55:14 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEE820936;
        Wed, 16 Sep 2020 01:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600221314;
        bh=f6kYVDW4E05xGj46qoL7kwQt3XA6l3+HAWQ743mLrVM=;
        h=Date:From:To:Subject:From;
        b=QZGOzZofqyoLj4/GAG+DhW0t90pJPZRVic8kYjGi3iK8Ct8Cbso6RuANNAM+x6b1y
         zhdmZbtpCRZ1fCuFvy6mDtgkmsFcR6b6U246MIvhxEwcZz/IWO5CH/28hejOJiInSx
         +ny/yY9bTqmXq3PW9BBBEbtIMp5GbseNKURZeUYo=
Date:   Tue, 15 Sep 2020 18:55:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jgg@ziepe.ca,
        jhubbard@nvidia.com
Subject:  +
 selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch added to -mm
 tree
Message-ID: <20200916015513.nQJUI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix incorrect gcc invocation in some cases
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

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

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

