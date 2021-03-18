Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E300CC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA6364F04
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCRBOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhCRBOW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 21:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050EC64E02;
        Thu, 18 Mar 2021 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616030062;
        bh=vVzP/jLvpLRUozPJtONfLexkdatDGPrpMhfvZpYJDxE=;
        h=Date:From:To:Subject:From;
        b=Prfb0EbL+Xq4UycKIuJt4CyXBeXKN4riBOH+3v++WhNN/YaiHLyjOs0j07P7j+bli
         W6aAzqXhmpQPhQSPJWcLfTBwAVGfLTGfo5ZmTJLH3jMjFxo41Dypmz53YXDxthhpKA
         VB4ozrMHHA/FVfXt7y9S8eh3tetHtxBq4olOfb+E=
Date:   Wed, 17 Mar 2021 18:14:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn
Subject:  + selftests-remove-duplicate-include.patch added to -mm
 tree
Message-ID: <20210318011421.sYS3mDfMh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: remove duplicate include
has been added to the -mm tree.  Its filename is
     selftests-remove-duplicate-include.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-remove-duplicate-include.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-remove-duplicate-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch
sh-remove-duplicate-include-in-tlbh.patch
mm-process_vm_access-remove-duplicate-include.patch
selftests-remove-duplicate-include.patch

