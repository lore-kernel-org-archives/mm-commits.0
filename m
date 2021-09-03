Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3132C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAFD6112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhICU7Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349821AbhICU7Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A70B6112E;
        Fri,  3 Sep 2021 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702695;
        bh=luekK7MZuazX+CifJDSxOHyea+47jMDdaOnFqHK38ag=;
        h=Date:From:To:Subject:From;
        b=fehg976gurYKCBO4jzKGQ020bs0uMUzIDVCEJVDNWcKHvvYGSRDxK7WpLYW3W5bN1
         5L/Qdr0SKV1L/EjXR00BaDTSRm7CA2RgDq19PCTQlXSbs/kq8wA0Dmi2ogio79U8Y7
         qEqGDGHjtKJ/nVvDvf9iH+E9q0UU5hITwVCdsf4w=
Date:   Fri, 03 Sep 2021 13:58:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, po-hsu.lin@canonical.com,
        shuah@kernel.org
Subject:  [merged]
 selftests-vm-use-kselftest-skip-code-for-skipped-tests.patch removed from
 -mm tree
Message-ID: <20210903205815.Qf4jv_aY5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: use kselftest skip code for skipped tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-kselftest-skip-code-for-skipped-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: selftests/vm: use kselftest skip code for skipped tests

There are several test cases in the vm directory are still using exit 0
when they need to be skipped.  Use the kselftest framework to skip code
instead so it can help us to distinguish the return status.

Criterion to filter out what should be fixed in vm directory:
  grep -r "exit 0" -B1 | grep -i skip

This change might cause some false-positives if people are running these
test scripts directly and only checking their return codes, which will
change from 0 to 4.  However I think the impact should be small as most of
our scripts here are already using this skip code.  And there will be no
such issue if running them with the kselftest framework.

Link: https://lkml.kernel.org/r/20210823073433.37653-1-po-hsu.lin@canonical.com
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  |    5 ++++-
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh~selftests-vm-use-kselftest-skip-code-for-skipped-tests
+++ a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -1,11 +1,14 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 set -e
 
 if [[ $(id -u) -ne 0 ]]; then
   echo "This test must be run as root. Skipping..."
-  exit 0
+  exit $ksft_skip
 fi
 
 fault_limit_file=limit_in_bytes
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh~selftests-vm-use-kselftest-skip-code-for-skipped-tests
+++ a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -1,11 +1,14 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 set -e
 
 if [[ $(id -u) -ne 0 ]]; then
   echo "This test must be run as root. Skipping..."
-  exit 0
+  exit $ksft_skip
 fi
 
 usage_file=usage_in_bytes
_

Patches currently in -mm which might be from po-hsu.lin@canonical.com are


