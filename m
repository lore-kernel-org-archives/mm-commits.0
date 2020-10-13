Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B56C35267
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EFD206D5
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633207;
	bh=0V1bOQm3v1uZP2SvgmR9PZXSnlGWtLxjzDWIc+gTdcM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=meLOJAEihHML6jct4PGZCHcPP8pKVNFThjLWUpqkyXP05YsbD8IY/gDDGjZs3ydda
	 6bALGgdKAGi5ff9EfWIfYoCKTTQ709w/VAe8vzbm0/1A/iK5DkBs3iueV2NBIq7ba5
	 iU6xVUDkAoLFOWUsISZ2MEJEYXuE7M780I+1gABc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgJMXx0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730105AbgJMXxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB32208B3;
        Tue, 13 Oct 2020 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633200;
        bh=0V1bOQm3v1uZP2SvgmR9PZXSnlGWtLxjzDWIc+gTdcM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rrmReNw0U/yq1g0Cv5v2DjAVgJk0YEQVKHXnrsfNAzx88GYislxKxLNRnGSwOL3ej
         QgoyVFdGFkT2ynMucjnRrciNPinR0EE4s1QbGHdv+ab0PKNSkhK/fteYH+GMv+WXjD
         EKkP9QQt5op9K2KvqlQp+OmY17YJBSE0GXlGjoho=
Date:   Tue, 13 Oct 2020 16:53:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 091/181] selftests/vm: fix incorrect gcc
 invocation in some cases
Message-ID: <20201013235319.xHClSggZs%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
