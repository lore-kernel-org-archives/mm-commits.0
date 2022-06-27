Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BC3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 18:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiF0SwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiF0SwU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 14:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4087EB9
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 11:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A077615CD
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 18:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72065C3411D;
        Mon, 27 Jun 2022 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656355937;
        bh=JDqkenrCuz5PzsskY8/ZA8ZwPMvK0bCDpgmWHLZGQF0=;
        h=Date:To:From:Subject:From;
        b=JCuqVewF0BwRUSbuXMrn8uZ+XREUnOZ3/rnYF75JOfjLFiURQ916QyPwzlnDm57Ke
         bMVplHXTNpHZ7MgRfOxMYRCJ2Vg994DuvVTEnEoeNjemZvsUw+Vt4q9uFt1tTL8+XN
         DBFkKVKFXuS6hktxlywOklId6mU6aFLcIG+JH5oU=
Date:   Mon, 27 Jun 2022 11:52:16 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-only-run-128tbswitch-with-5-level-paging.patch added to mm-unstable branch
Message-Id: <20220627185217.72065C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: Only run 128TBswitch with 5-level paging
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

This patch will later appear in the mm-unstable branch at
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
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests/vm: Only run 128TBswitch with 5-level paging
Date: Mon, 27 Jun 2022 18:39:12 +0200

The test va_128TBswitch.c expects to be able to pass mmap an address hint
and length that cross the address 1<<47. This is not possible without
5-level page tables, so the test fails.

The test is already only run on 64-bit powerpc and x86 archs, but this
patch adds an additional check that skips the test if PG_TABLE_LEVELS < 5.
There is precedent for checking /proc/config.gz in selftests, e.g. in
selftests/firmware.

Running the tests produces the desired output:

sudo make -C tools/testing/selftests TARGETS=vm run_tests
---------------------------
running ./va_128TBswitch.sh
---------------------------
./va_128TBswitch.sh: PG_TABLE_LEVELS=4, must be >= 5 to run this test
[SKIP]
-------------------------------

Link: https://lkml.kernel.org/r/20220627163912.5581-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: Adam Sindelar <ats@fb.com>
Cc: David Vernet <void@manifault.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile          |    1 
 tools/testing/selftests/vm/run_vmtests.sh    |    2 
 tools/testing/selftests/vm/va_128TBswitch.sh |   39 +++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-only-run-128tbswitch-with-5-level-paging
+++ a/tools/testing/selftests/vm/Makefile
@@ -93,6 +93,7 @@ TEST_PROGS := run_vmtests.sh
 
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
+TEST_FILES += va_128TBswitch.sh
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -158,7 +158,7 @@ if [ $VADDR64 -ne 0 ]; then
 	run_test ./virtual_address_range
 
 	# virtual address 128TB switch test
-	run_test ./va_128TBswitch
+	run_test ./va_128TBswitch.sh
 fi # VADDR64
 
 # vmalloc stability smoke test
--- /dev/null
+++ a/tools/testing/selftests/vm/va_128TBswitch.sh
@@ -0,0 +1,39 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2022 Adam Sindelar (Meta) <adam@wowsignal.io>
+#
+# This is a test for mmap behavior with 5-level paging. This script wraps the
+# real test to check that the kernel is configured to support at least 5
+# pagetable levels.
+
+# 1 means the test failed
+exitcode=1
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+die()
+{
+    echo "$1"
+    exit $exitcode
+}
+
+check_test_requirements()
+{
+    local config="/proc/config.gz"
+    [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
+    [[ -f "${config}" ]] || die "Cannot find kernel config in /proc or /boot"
+
+    # gzip -dcfq automatically handles both compressed and plaintext input.
+    # See man 1 gzip under '-f'.
+    local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
+
+    if [[ "${pg_table_levels}" -lt 5 ]]; then
+        echo "$0: PG_TABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
+        exit $ksft_skip
+    fi
+}
+
+check_test_requirements
+./va_128TBswitch
_

Patches currently in -mm which might be from adam@wowsignal.io are

selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

