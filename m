Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2416C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKJDXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJDXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0652B180
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE1B2B81F40
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DE5C433C1;
        Thu, 10 Nov 2022 03:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050590;
        bh=uAdMxXu7N37MoqvKloYJCfwDTpvBjNhx0nRgUgZq/TU=;
        h=Date:To:From:Subject:From;
        b=2I2ic+lOo16Z5xKR6KTKP39dyKlcuaWIkODgBkilC21HaY2zzpIww6foFdLRmEpmq
         yjn5X1vO9MoWKnhxfnuZv4kJooRWYbrHRjqaQPIYvM8BkEG3ba+Pnk6/DEhs8zSYXF
         TzmBD51xky+UEwauElW2SdL+yBUPZE15kgraAwWU=
Date:   Wed, 09 Nov 2022 19:23:09 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, adobriyan@gmail.com,
        punit.agrawal@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch removed from -mm tree
Message-Id: <20221110032310.69DE5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: proc: fix proc-empty-vm build error on non x86_64
has been removed from the -mm tree.  Its filename was
     selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@bytedance.com>
Subject: selftests: proc: fix proc-empty-vm build error on non x86_64
Date: Wed, 9 Nov 2022 22:11:03 +0000

The proc-empty-vm test is implemented for x86_64 and fails to build for
other architectures.  Rather then emitting a compiler error it would be
preferable to only build the test on supported architectures.

Mark proc-empty-vm as a test for x86_64 and customise the Makefile to
build it only when building for this target architecture.

Link: https://lkml.kernel.org/r/20221109221104.1797802-1-punit.agrawal@bytedance.com
Fixes: 5bc73bb3451b ("proc: test how it holds up with mapping'less process")
Signed-off-by: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/Makefile |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/proc/Makefile~selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64
+++ a/tools/testing/selftests/proc/Makefile
@@ -1,14 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+# When ARCH not overridden for crosscompiling, lookup machine
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += -D_GNU_SOURCE
 LDFLAGS += -pthread
 
-TEST_GEN_PROGS :=
 TEST_GEN_PROGS += fd-001-lookup
 TEST_GEN_PROGS += fd-002-posix-eq
 TEST_GEN_PROGS += fd-003-kthread
 TEST_GEN_PROGS += proc-loadavg-001
-TEST_GEN_PROGS += proc-empty-vm
 TEST_GEN_PROGS += proc-pid-vm
 TEST_GEN_PROGS += proc-self-map-files-001
 TEST_GEN_PROGS += proc-self-map-files-002
@@ -26,4 +28,8 @@ TEST_GEN_PROGS += thread-self
 TEST_GEN_PROGS += proc-multiple-procfs
 TEST_GEN_PROGS += proc-fsconfig-hidepid
 
+TEST_GEN_PROGS_x86_64 += proc-empty-vm
+
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
+
 include ../lib.mk
_

Patches currently in -mm which might be from punit.agrawal@bytedance.com are

selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch

