Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F0AC00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjGXQjW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjGXQjU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AD01B8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E310661280
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC9C433C9;
        Mon, 24 Jul 2023 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216758;
        bh=3HhoO4KjbLK7udTQ8gXglwX4EDmJ1rC/AZpLWg7HDvE=;
        h=Date:To:From:Subject:From;
        b=bWIAMogL+Fo3OJ0MmmhJYVKFItyh6zwULyBCTkmb8onKzSLSo8ku+70voCv5ChpO9
         Ft5g5h+QfZlXdoLV5sk5RLMjAXrWjL8Td0ueZpCMzg7n+yKEJ+ugTUBz03AxZ4LxFY
         pAfFefAbdXoH1s/lXzN7VTZj+Gbaqk32RQXwoNfk=
Date:   Mon, 24 Jul 2023 09:39:17 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-enable-mrelease_test-for-arm64.patch added to mm-unstable branch
Message-Id: <20230724163918.44FC9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: enable mrelease_test for arm64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-enable-mrelease_test-for-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-enable-mrelease_test-for-arm64.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: enable mrelease_test for arm64
Date: Mon, 24 Jul 2023 09:25:17 +0100

mrelease_test defaults to defining __NR_pidfd_open and
__NR_process_mrelease syscall numbers to -1, if they are not defined
anywhere else, and the suite would then be marked as skipped as a result.

arm64 (at least the stock debian toolchain that I'm using) requires
including <sys/syscall.h> to pull in the defines for these syscalls.  So
let's add this header.  With this in place, the test is passing on arm64.

Link: https://lkml.kernel.org/r/20230724082522.1202616-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mrelease_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-enable-mrelease_test-for-arm64
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -7,6 +7,7 @@
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <sys/syscall.h>
 #include <sys/wait.h>
 #include <unistd.h>
 #include <asm-generic/unistd.h>
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch
selftests-line-buffer-test-programs-stdout.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch

