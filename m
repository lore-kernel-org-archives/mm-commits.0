Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE48C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA33613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhEGBGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhEGBGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEFB461289;
        Fri,  7 May 2021 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349534;
        bh=Emt1b3Nj+nzCleg3aBPjQJ14lmwVSAcKb3MyAvTg/Zg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U5mgCMjDDPAIar+KwWuXyn4Z7EQnrtcAUfNRpYoIQdPX9v2hZztWv/wWRDClwG0Xh
         u+Y4aGofbhawGy2CEKkg4HFZTr21uiZJWGiWeIihRvt/BAUZgqathofvYpYh2s88gv
         cTFa6yi7Nm0RRQ6fKBN05+9REa7yH/zyLHuK8PoM=
Date:   Thu, 06 May 2021 18:05:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        torvalds@linux-foundation.org, zhang.yunkai@zte.com.cn
Subject:  [patch 67/91] selftests: remove duplicate include
Message-ID: <20210507010533.nNBWSQpDA%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
