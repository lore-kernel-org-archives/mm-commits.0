Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D04CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiGDBNM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiGDBMI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CCC6333
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25511B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E0CC341C6;
        Mon,  4 Jul 2022 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897065;
        bh=R7QxNvGsiB35LXZwWrCwVNw7nKMPm86sq5PEe6RfNxA=;
        h=Date:To:From:Subject:From;
        b=i5PeyCuzRFpGnFG3v7RXZq/Pmo9+YvLZM3/hvkIHwF/w8DuWvufKQkp4LjcD82G+u
         uUvo+CqACgECRfitfJNrTmnRPO5zAQ8cBJZnmHiL21UvP6dNaTZrDe+9+9o/cK+1Vw
         DP2K+TPOUta5TdyAS9g1HDKJTfif+mNJsBLJVRHM=
Date:   Sun, 03 Jul 2022 18:11:05 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-only-run-128tbswitch-with-5-level-paging.patch removed from -mm tree
Message-Id: <20220704011105.C7E0CC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: only run 128TBswitch with 5-level paging
has been removed from the -mm tree.  Its filename was
     selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests/vm: only run 128TBswitch with 5-level paging
Date: Mon, 27 Jun 2022 18:39:12 +0200

The test va_128TBswitch.c expects to be able to pass mmap an address hint
and length that cross the address 1<<47.  On x86_64, this is not possible
without 5-level page tables, so the test fails.

The test is already only run on 64-bit powerpc and x86_64 archs, but this
patch adds an additional check on x86_64 that skips the test if
PG_TABLE_LEVELS < 5.  There is precedent for checking /proc/config.gz in
selftests, e.g.  in selftests/firmware.

Running the tests produces the desired output:

sudo make -C tools/testing/selftests TARGETS=vm run_tests
---------------------------
running ./va_128TBswitch.sh
---------------------------
./va_128TBswitch.sh: PG_TABLE_LEVELS=4, must be >= 5 to run this test
[SKIP]
-------------------------------

[adam@wowsignal.io: restrict the check to x86_64]
  Link: https://lkml.kernel.org/r/20220628163654.337600-1-adam@wowsignal.io
[adam@wowsignal.io: fix formatting issues, rename "die" to "fail"]
  Link: https://lkml.kernel.org/r/20220701163030.415735-1-adam@wowsignal.io
Link: https://lkml.kernel.org/r/20220627163912.5581-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: Adam Sindelar <ats@fb.com>
Cc: David Vernet <void@manifault.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile          |    1 
 tools/testing/selftests/vm/run_vmtests.sh    |    2 
 tools/testing/selftests/vm/va_128TBswitch.sh |   54 +++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

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
@@ -151,7 +151,7 @@ if [ $VADDR64 -ne 0 ]; then
 	run_test ./virtual_address_range
 
 	# virtual address 128TB switch test
-	run_test ./va_128TBswitch
+	run_test ./va_128TBswitch.sh
 fi # VADDR64
 
 # vmalloc stability smoke test
--- /dev/null
+++ a/tools/testing/selftests/vm/va_128TBswitch.sh
@@ -0,0 +1,54 @@
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
+fail()
+{
+	echo "$1"
+	exit $exitcode
+}
+
+check_supported_x86_64()
+{
+	local config="/proc/config.gz"
+	[[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
+	[[ -f "${config}" ]] || fail "Cannot find kernel config in /proc or /boot"
+
+	# gzip -dcfq automatically handles both compressed and plaintext input.
+	# See man 1 gzip under '-f'.
+	local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
+
+	if [[ "${pg_table_levels}" -lt 5 ]]; then
+		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
+		exit $ksft_skip
+	fi
+}
+
+check_test_requirements()
+{
+	# The test supports x86_64 and powerpc64. We currently have no useful
+	# eligibility check for powerpc64, and the test itself will reject other
+	# architectures.
+	case `uname -m` in
+		"x86_64")
+			check_supported_x86_64
+		;;
+		*)
+			return 0
+		;;
+	esac
+}
+
+check_test_requirements
+./va_128TBswitch
_

Patches currently in -mm which might be from adam@wowsignal.io are


