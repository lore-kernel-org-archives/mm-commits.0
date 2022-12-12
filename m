Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFEAC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiLLCSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiLLCQi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6539DFDC
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F98260EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63DC433EF;
        Mon, 12 Dec 2022 02:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811302;
        bh=B3z0FjmY+LqB0MYfnLPd5ANNUuArIOHFoLhtDDI8OXM=;
        h=Date:To:From:Subject:From;
        b=SrXdCGHUW5Y5ElEJxE9GB3n/DHu30LyffLFA+umTyN4JrE9IxXl0mMqZiR4xSM20X
         zI5HJWp/N1j5zINO/FjEySwWXxz82Y827OasV/8V804EZ1tH6uLcqIzIQ6WvOvrOUM
         LAN3mLisjWQYmyJ5H23ozen+tdniwSHOj3JAtvjU=
Date:   Sun, 11 Dec 2022 18:15:02 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-cow-fix-compile-warning-on-32bit.patch removed from -mm tree
Message-Id: <20221212021502.CF63DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: cow: fix compile warning on 32bit
has been removed from the -mm tree.  Its filename was
     selftests-vm-cow-fix-compile-warning-on-32bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: cow: fix compile warning on 32bit
Date: Mon, 5 Dec 2022 20:37:15 +0100

The compiler complains about the conversion of a pointer to an int of
different width.

Link: https://lkml.kernel.org/r/20221205193716.276024-4-david@redhat.com
Fixes: 6f1405efc61b ("selftests/vm: anon_cow: add R/O longterm tests via gup_test")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/cow.c~selftests-vm-cow-fix-compile-warning-on-32bit
+++ a/tools/testing/selftests/vm/cow.c
@@ -650,7 +650,7 @@ static void do_test_ro_pin(char *mem, si
 	}
 
 	/* Take a R/O pin. This should trigger unsharing. */
-	args.addr = (__u64)mem;
+	args.addr = (__u64)(uintptr_t)mem;
 	args.size = size;
 	args.flags = fast ? PIN_LONGTERM_TEST_FLAG_USE_FAST : 0;
 	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
@@ -669,7 +669,7 @@ static void do_test_ro_pin(char *mem, si
 	 * Read back the content via the pin to the temporary buffer and
 	 * test if we observed the modification.
 	 */
-	tmp_val = (__u64)tmp;
+	tmp_val = (__u64)(uintptr_t)tmp;
 	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_READ, &tmp_val);
 	if (ret)
 		ksft_test_result_fail("PIN_LONGTERM_TEST_READ failed\n");
_

Patches currently in -mm which might be from david@redhat.com are


