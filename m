Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC9CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 23:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbiCPXQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiCPXQb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 19:16:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A7425D8
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 16:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BCBFB81C55
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 23:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D5CC340EC;
        Wed, 16 Mar 2022 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647472513;
        bh=KKfKFCFFI9do0CYmJ+65JyVaazlU6mir1V03pLXZitA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=xZ6oJuFhUrwmb5aru3J7Nv9+gGoVAn4U+0OHQFAmhFdqH7qHF6oqR4uTwLyLtd/fJ
         +aUabMBqN0JqB8DQ8Q+Z1Fef4FKxUZfCM3FewBKhDf5MH81s6Wntzm0606SHJAXGed
         0TDAje3dpcXFVMdsapueKNrXguoXLfqZdo+nolI8=
Date:   Wed, 16 Mar 2022 16:15:12 -0700
To:     shuah@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        yosryahmed@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220316161433.5c2e137a69eaee50d2249a27@linux-foundation.org>
Subject: [patch 4/4] selftests: vm: fix clang build error multiple output files
Message-Id: <20220316231513.12D5CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
