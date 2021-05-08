Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946F7C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6241A61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWzW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86B886142D;
        Sat,  8 May 2021 22:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514459;
        bh=LUTxpS/L2qBTSRJt8bgyjoks1ksRqEd9FqYORm7wc9g=;
        h=Date:From:To:Subject:From;
        b=Xwcrmf1dT0tiG8vXTo0JvPazKbAHiXJvvcFnv+we+KDoTiNayrYvgQ+UJxTRmsk9T
         Qp5L0mMYvUh+zfg6ta/cF7NFZsm8oLYJ9rf3MGydz7zAuswiniCEzrxBT6DrasPUhY
         LWFOhb2T7Mlbe3B6XQ6NU9JYLM1SuXNk1DCRfUus=
Date:   Sat, 08 May 2021 15:54:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn
Subject:  [merged] selftests-remove-duplicate-include.patch removed
 from -mm tree
Message-ID: <20210508225419.HXOdq9Eds%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: remove duplicate include
has been removed from the -mm tree.  Its filename was
     selftests-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: selftests: remove duplicate include

'assert.h' included in 'sparsebit.c' is duplicated.
It is also included in the 161th line.
'string.h' included in 'mincore_selftest.c' is duplicated.
It is also included in the 15th line.
'sched.h' included in 'tlbie_test.c' is duplicated.
It is also included in the 33th line.

Link: https://lkml.kernel.org/r/20210316073336.426255-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kvm/lib/sparsebit.c        |    1 -
 tools/testing/selftests/mincore/mincore_selftest.c |    1 -
 tools/testing/selftests/powerpc/mm/tlbie_test.c    |    1 -
 3 files changed, 3 deletions(-)

--- a/tools/testing/selftests/kvm/lib/sparsebit.c~selftests-remove-duplicate-include
+++ a/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -1890,7 +1890,6 @@ void sparsebit_validate_internal(struct
  */
 
 #include <stdlib.h>
-#include <assert.h>
 
 struct range {
 	sparsebit_idx_t first, last;
--- a/tools/testing/selftests/mincore/mincore_selftest.c~selftests-remove-duplicate-include
+++ a/tools/testing/selftests/mincore/mincore_selftest.c
@@ -14,7 +14,6 @@
 #include <sys/mman.h>
 #include <string.h>
 #include <fcntl.h>
-#include <string.h>
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
--- a/tools/testing/selftests/powerpc/mm/tlbie_test.c~selftests-remove-duplicate-include
+++ a/tools/testing/selftests/powerpc/mm/tlbie_test.c
@@ -33,7 +33,6 @@
 #include <sched.h>
 #include <time.h>
 #include <stdarg.h>
-#include <sched.h>
 #include <pthread.h>
 #include <signal.h>
 #include <sys/prctl.h>
_

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are


