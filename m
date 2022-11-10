Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9172C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiKJAEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiKJAEo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:04:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E45167C1
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:04:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F31D61D18
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892F8C4347C;
        Thu, 10 Nov 2022 00:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668038676;
        bh=TmkQW86W+ewFgEODIw8EZ6Un0N0jC2AVKecAjI7xAg8=;
        h=Date:To:From:Subject:From;
        b=Um0JdLV3dDOTdtQYlEVIjEPI4Vb2xCAIyMO0pu7e005DklaMs945HFaYri1GIehY/
         V7vQFjRkgKN/lIJcIxutAL8Wf4KBC4kSUUJ3LhdJFaUI4BY0Q91Oy7UBaiq68Fg92k
         HIbHnAA9CnBMv8K9vA/CvvATX79X6sbHlSljyH84=
Date:   Wed, 09 Nov 2022 16:04:35 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, adobriyan@gmail.com,
        punit.agrawal@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch added to mm-nonmm-unstable branch
Message-Id: <20221110000436.892F8C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: proc: fix proc-empty-vm build error on non x86_64
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch
selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch

