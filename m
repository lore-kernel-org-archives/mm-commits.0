Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E89AC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiGDAE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDAE5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFE860EC
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1638161298
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69150C341C6;
        Mon,  4 Jul 2022 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656893095;
        bh=NGlLSj7cSzNaefBHvvw1yOmi3Xp1EFIT0CPDYytzk1E=;
        h=Date:To:From:Subject:From;
        b=kILtlua2kkb5PcDBj5YeNytLYn5OUDg9Pf5xbJDxlPXrd/sjHtjVW+NjMb3cjxlrd
         bYzPdiKMkmSw3R4kBF3FZn/0GA0I5qDIQxhO6vadGxwOctMGzbjgbXs36anXaHYtlG
         BOBZG/e7z79W4QzbSeKzvA95aJNn+GhT+Xp1YuYk=
Date:   Sun, 03 Jul 2022 17:04:54 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, ats@fb.com,
        aneesh.kumar@linux.vnet.ibm.com, adam@wowsignal.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch removed from -mm tree
Message-Id: <20220704000455.69150C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-only-run-128tbswitch-with-5-level-paging-v4
has been removed from the -mm tree.  Its filename was
     selftests-vm-only-run-128tbswitch-with-5-level-paging-v4.patch

This patch was dropped because it was folded into selftests-vm-only-run-128tbswitch-with-5-level-paging.patch

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
selftests-vm-only-run-128tbswitch-with-5-level-paging-v6.patch

