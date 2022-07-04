Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3EBC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiGDAFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDAE6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:04:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B89F60EC
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36AC061298
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D3AC341C6;
        Mon,  4 Jul 2022 00:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656893096;
        bh=smhcneI3mPJAO81lNzUH8/zwBI93/qk6zRAnIGHmwsk=;
        h=Date:To:From:Subject:From;
        b=NbKEou8UWhBavlcIqnXCGAbmatFi61gLSK8BZ4+o3ftIX9BDFuThZpsLMU9bAXuOa
         hxIq1sZZkmTmTqiHlGGLj8Tma5c9+bPvI7NSButPFSC3Vr+C4925CoZYywdmcZ4rXU
         kVpI60xKppPmkZIRLcTstyBPCwR6/FYGajI0t6mo=
Date:   Sun, 03 Jul 2022 17:04:55 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-only-run-128tbswitch-with-5-level-paging-v6.patch removed from -mm tree
Message-Id: <20220704000456.84D3AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-only-run-128tbswitch-with-5-level-paging-v6
has been removed from the -mm tree.  Its filename was
     selftests-vm-only-run-128tbswitch-with-5-level-paging-v6.patch

This patch was dropped because it was folded into selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

------------------------------------------------------
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests-vm-only-run-128tbswitch-with-5-level-paging-v6
Date: Fri, 1 Jul 2022 18:30:30 +0200

fix formatting issues, rename "die" to "fail"

Link: https://lkml.kernel.org/r/20220701163030.415735-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: David Vernet <void@manifault.com>
Cc: Adam Sindelar <ats@fb.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/va_128TBswitch.sh |   52 ++++++++---------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/tools/testing/selftests/vm/va_128TBswitch.sh~selftests-vm-only-run-128tbswitch-with-5-level-paging-v6
+++ a/tools/testing/selftests/vm/va_128TBswitch.sh
@@ -13,41 +13,41 @@ exitcode=1
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-die()
+fail()
 {
-    echo "$1"
-    exit $exitcode
+	echo "$1"
+	exit $exitcode
 }
 
 check_supported_x86_64()
 {
-    local config="/proc/config.gz"
-    [[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
-    [[ -f "${config}" ]] || die "Cannot find kernel config in /proc or /boot"
-
-    # gzip -dcfq automatically handles both compressed and plaintext input.
-    # See man 1 gzip under '-f'.
-    local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
-
-    if [[ "${pg_table_levels}" -lt 5 ]]; then
-        echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
-        exit $ksft_skip
-    fi
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
 }
 
 check_test_requirements()
 {
-    # The test supports x86_64 and powerpc64. We currently have no useful
-    # eligibility check for powerpc64, and the test itself will reject other
-    # architectures.
-    case `uname -m` in
-        "x86_64")
-            check_supported_x86_64
-        ;;
-        *)
-            return 0
-        ;;
-    esac
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
 }
 
 check_test_requirements
_

Patches currently in -mm which might be from adam@wowsignal.io are

selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

