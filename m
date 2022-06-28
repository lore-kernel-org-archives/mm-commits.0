Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE56DC43334
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 18:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiF1Sfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 14:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiF1Sfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 14:35:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1608F1F63D
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 11:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A7BAB81F12
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 18:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F993C3411D;
        Tue, 28 Jun 2022 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656441334;
        bh=pZcqbYCPb7RIOLH+M8I/f8D3Dj6Sa7gXZ4MvfPiiqmo=;
        h=Date:To:From:Subject:From;
        b=Q/4faR3ayqLYr5lEhd61lO71+28ASp3PTwUIjQY4B70xPjByEMgs8gh9HgBDYvdN7
         1zECZEhjNbiQt96dsNuJUtRXDlOdm+Kk2oSs6UldLx7369abYXbn7Daa67ThOx1CiL
         52X8zTE+bcSFPddUdT0YUU/GyVia4cBmik3om1kE=
Date:   Tue, 28 Jun 2022 11:35:33 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch added to mm-unstable branch
Message-Id: <20220628183534.4F993C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-only-run-128tbswitch-with-5-level-paging-v4
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch

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
Subject: selftests-vm-only-run-128tbswitch-with-5-level-paging-v4
Date: Tue, 28 Jun 2022 18:36:54 +0200

restrict the check to x86_64

Link: https://lkml.kernel.org/r/20220628163654.337600-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: Adam Sindelar <ats@fb.com>
Cc: David Vernet <void@manifault.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/va_128TBswitch.sh |   19 +++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/va_128TBswitch.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging-v4
+++ a/tools/testing/selftests/vm/va_128TBswitch.sh
@@ -19,7 +19,7 @@ die()
     exit $exitcode
 }
 
-check_test_requirements()
+check_supported_x86_64()
 {
     local config="/proc/config.gz"
     [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
@@ -30,10 +30,25 @@ check_test_requirements()
     local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
 
     if [[ "${pg_table_levels}" -lt 5 ]]; then
-        echo "$0: PG_TABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
+        echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
         exit $ksft_skip
     fi
 }
 
+check_test_requirements()
+{
+    # The test supports x86_64 and powerpc64. We currently have no useful
+    # eligibility check for powerpc64, and the test itself will reject other
+    # architectures.
+    case `uname -m` in
+        "x86_64")
+            check_supported_x86_64
+        ;;
+        *)
+            return 0
+        ;;
+    esac
+}
+
 check_test_requirements
 ./va_128TBswitch
_

Patches currently in -mm which might be from adam@wowsignal.io are

selftests-vm-only-run-128tbswitch-with-5-level-paging.patch
selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch

