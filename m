Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD89C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 00:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiCDAjP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 19:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiCDAjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 19:39:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9803C7EB4
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 16:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6FCEB81DB8
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 00:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA0C004E1;
        Fri,  4 Mar 2022 00:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646354304;
        bh=drvh9fkQthB2FB1JGD/byoQmIjIbIL7TzhA2VkDQYQQ=;
        h=Date:To:From:Subject:From;
        b=2sXFihgO4/4vULoVbJ8pFmMECVro3I68PX1dzWX12DEFtalUMh/vSC66UxeSwbxAQ
         T84FdMV3OBENNpCt80T4OOoBVYvtPJDuyiZ6J7SZ88hJUvRmg7kNWYMdLzRz4Ocg8R
         5/YvcGKy+ajPIUSHl76cXBKtjSH4n1QXQtpUvdJE=
Date:   Thu, 03 Mar 2022 16:38:23 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-fix-clang-build-error-multiple-output-files.patch added to -mm tree
Message-Id: <20220304003824.8BEA0C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: fix clang build error multiple output files
has been added to the -mm tree.  Its filename is
     selftests-vm-fix-clang-build-error-multiple-output-files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-fix-clang-build-error-multiple-output-files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-fix-clang-build-error-multiple-output-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: vm: fix clang build error multiple output files

When building the vm selftests using clang, some errors are seen due to
having headers in the compilation command:

clang -Wall -I ../../../../usr/include  -no-pie    gup_test.c ../../../../mm/gup_test.h -lrt -lpthread -o .../tools/testing/selftests/vm/gup_test
clang: error: cannot specify -o when generating multiple output files
make[1]: *** [../lib.mk:146: .../tools/testing/selftests/vm/gup_test] Error 1

Rework to add the header files to LOCAL_HDRS before including ../lib.mk,
since the dependency is evaluated in '$(OUTPUT)/%:%.c $(LOCAL_HDRS)' in
file lib.mk.

Link: https://lkml.kernel.org/r/20220304000645.1888133-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-fix-clang-build-error-multiple-output-files
+++ a/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm selftests
 
+LOCAL_HDRS += $(selfdir)/vm/local_config.h $(top_srcdir)/mm/gup_test.h
+
 include local_config.mk
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
@@ -140,10 +142,6 @@ endif
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
-$(OUTPUT)/gup_test: ../../../../mm/gup_test.h
-
-$(OUTPUT)/hmm-tests: local_config.h
-
 # HMM_EXTRA_LIBS may get set in local_config.mk, or it may be left empty.
 $(OUTPUT)/hmm-tests: LDLIBS += $(HMM_EXTRA_LIBS)
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

selftests-vm-fix-clang-build-error-multiple-output-files.patch
memcg-add-per-memcg-total-kernel-memory-stat.patch

