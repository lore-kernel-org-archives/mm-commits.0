Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F2DEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjFSXUj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjFSXU3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D661BB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BFB460F51
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F423BC433C0;
        Mon, 19 Jun 2023 23:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216827;
        bh=z7/NJBVbjcbSDM3uhIrfNQIT9ptD5BPiSt9u4XnMx20=;
        h=Date:To:From:Subject:From;
        b=QCZsCsATaEfkH9ktw6shkG8ZEbuiXN2glDdVr9CfGNKtpsNsAksFHAHTR3dN5Gm+5
         r4Dff19v9gflzSqrjj7216tq8Hwr7lFbCcqATA1aojIb40XuHLs3XCeoM3P2Fa1Ega
         Dh6fo56rDBiQWE3qF7QENZHZiItlxlsqQikAJR9Q=
Date:   Mon, 19 Jun 2023 16:20:26 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch removed from -mm tree
Message-Id: <20230619232026.F423BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix invocation of tests that are run via shell scripts
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix invocation of tests that are run via shell scripts
Date: Tue, 6 Jun 2023 00:16:30 -0700

We cannot depend upon git to reliably retain the executable bit on shell
scripts, or so I was told several years ago while working on this same
run_vmtests.sh script. And sure enough, things such as test_hmm.sh are
lately failing to run, due to lacking execute permissions.

Fix this by explicitly adding "bash" to each of the shell script
invocations. Leave fixing the overall approach to another day.

Link: https://lkml.kernel.org/r/20230606071637.267103-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -244,18 +244,18 @@ if [ $VADDR64 -ne 0 ]; then
 	if [ "$ARCH" == "$ARCH_ARM64" ]; then
 		echo 6 > /proc/sys/vm/nr_hugepages
 	fi
-	CATEGORY="hugevm" run_test ./va_high_addr_switch.sh
+	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
 	if [ "$ARCH" == "$ARCH_ARM64" ]; then
 		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
 	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
-CATEGORY="vmalloc" run_test ./test_vmalloc.sh smoke
+CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
 
 CATEGORY="mremap" run_test ./mremap_dontunmap
 
-CATEGORY="hmm" run_test ./test_hmm.sh smoke
+CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


