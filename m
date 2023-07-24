Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF8C00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjGXQje (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjGXQj0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:39:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AAFE4E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 854C06127C
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA791C433CC;
        Mon, 24 Jul 2023 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216762;
        bh=YbyRUbczWirhpAqTZz+waV6SFB0a55/r4hVwIL/Zczc=;
        h=Date:To:From:Subject:From;
        b=hrVFx9a3V0Uh1Qq9dxalP5NIszMTN2JJAx9rYJZEg+cFJYVnQH89L3xX02UgcRKMb
         oUbBeBfkEuPSrMFgVWOMR1F3Y/mqMlJKf4UUkQjHeknmJocwWOOBMP0IPDnFnhtgrx
         6QYygSI2cdKsE+lhcsjr5Ga6yxwm+Lx5QNqJSizE=
Date:   Mon, 24 Jul 2023 09:39:21 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch added to mm-unstable branch
Message-Id: <20230724163921.DA791C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: va_high_addr_switch should skip unsupported arm64 configs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch

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
Subject: selftests/mm: va_high_addr_switch should skip unsupported arm64 configs
Date: Mon, 24 Jul 2023 09:25:19 +0100

va_high_addr_switch has a mechanism to determine if the tests should be
run or skipped (supported_arch()).  This currently returns unconditionally
true for arm64.  However, va_high_addr_switch also requires a large
virtual address space for the tests to run, otherwise they spuriously
fail.

Since arm64 can only support VA > 48 bits when the page size is 64K, let's
decide whether we should skip the test suite based on the page size.  This
reduces noise when running on 4K and 16K kernels.

Link: https://lkml.kernel.org/r/20230724082522.1202616-6-ryan.roberts@arm.com
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

 tools/testing/selftests/mm/va_high_addr_switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -292,7 +292,7 @@ static int supported_arch(void)
 #elif defined(__x86_64__)
 	return 1;
 #elif defined(__aarch64__)
-	return 1;
+	return getpagesize() == PAGE_SIZE;
 #else
 	return 0;
 #endif
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

