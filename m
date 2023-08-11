Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB6CC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjHKXNc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbjHKXNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B806449E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C3D867B04
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EFBC433C8;
        Fri, 11 Aug 2023 23:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794938;
        bh=8WPocM+AGPhnb8wLspnK1g67FA1jDJeafv54BLQA0rM=;
        h=Date:To:From:Subject:From;
        b=JggGWSDj4pMYt1vp7hzrPOoC0U/PxJPTJgI5Ydn3cDnl1jTFfW1rUYUgV3J9jj/Gw
         Ll9EHP/0Z8tYPVTVtrXJLWSI3Z/Hw+JsD8s9iap99B/tz/SfpaamcZ9BxF+7MzlcuR
         xAIrRgfgspH4Bde6HRTJ/L0KWhbUgyPAhWrhrPlY=
Date:   Fri, 11 Aug 2023 16:02:17 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch removed from -mm tree
Message-Id: <20230811230218.64EFBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: va_high_addr_switch should skip unsupported arm64 configs
has been removed from the -mm tree.  Its filename was
     selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


