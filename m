Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25C9C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbjHKXFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbjHKXEL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CDA4498
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE7665772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528DFC433C8;
        Fri, 11 Aug 2023 23:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794936;
        bh=j31w9sZKMoZgeHSqBHLj2XxM6Diy9QKC+j9By7nzvCs=;
        h=Date:To:From:Subject:From;
        b=nkHrsoIw9ixxuTW9b4y8D1fNTjh7Fo0hHdIp1pLdlPx1NtGVPB5KUoWy2ahxnuUj9
         XiaA3vDZ/z7KC5d3iME4oxq9PLvl05yOgXAyuuxyX7w8iDqvUW86RahUFAxnsNJaeq
         6ReeO7aACPcTVhVzEbUMNrMLmb9SKd0oEt7wNS7U=
Date:   Fri, 11 Aug 2023 16:02:15 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-enable-mrelease_test-for-arm64.patch removed from -mm tree
Message-Id: <20230811230216.528DFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: enable mrelease_test for arm64
has been removed from the -mm tree.  Its filename was
     selftests-mm-enable-mrelease_test-for-arm64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


