Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B38C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiEJEVe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbiEJEUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691742AC6F8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 277056176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6C5C385C2;
        Tue, 10 May 2022 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156107;
        bh=KAzTdFJZx+X/VyeEPXg2a2zXBIDMBKzQTGKE76ARg1Q=;
        h=Date:To:From:Subject:From;
        b=v/T7LtMISwvkcpHmLIPKJdk0DHTDWWa3w1fTx0cMyD63RUjP+zzSQlP10IHxxc5kh
         B8ZDYsQ5CUmgsQX7Z9UX13wDaTW1Cz92HzC46jNGtEGbOqQwrzbwF/z5zjep04DZMb
         CHM1bugY1kK4RSFuoi5EbBeDmBLe7s4upxmGuKnM=
Date:   Mon, 09 May 2022 21:15:06 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, npache@redhat.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-clarify-common-error-when-running-gup_test.patch removed from -mm tree
Message-Id: <20220510041507.7C6C5C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: clarify common error when running gup_test
has been removed from the -mm tree.  Its filename was
     selftests-clarify-common-error-when-running-gup_test.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests: clarify common error when running gup_test

The gup_test binary will fail showing only the output of perror("open") in
the case that /sys/kernel/debug/gup_test is not found. This will almost
always be due to CONFIG_GUP_TEST not being set, which enables
compilation of a kernel that provides this file.

Add a short error message to clarify this failure and point the user to
the solution.

Link: https://lkml.kernel.org/r/20220502224942.995427-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/gup_test.c~selftests-clarify-common-error-when-running-gup_test
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -21,6 +21,8 @@
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 
+#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
+
 static unsigned long cmd = GUP_FAST_BENCHMARK;
 static int gup_fd, repeats = 1;
 static unsigned long size = 128 * MB;
_

Patches currently in -mm which might be from jsavitz@redhat.com are


