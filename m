Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE23C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Mar 2022 22:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiCQW5o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Mar 2022 18:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiCQW5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2022 18:57:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD832B4A71
        for <mm-commits@vger.kernel.org>; Thu, 17 Mar 2022 15:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1125560C02
        for <mm-commits@vger.kernel.org>; Thu, 17 Mar 2022 22:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6593AC340EC;
        Thu, 17 Mar 2022 22:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647557780;
        bh=Iy/TJ/xVaS3InHeXEhUWjsEQ7PYcXsmN5dO38Sv1HrI=;
        h=Date:To:From:Subject:From;
        b=aIuOkkEv0ClKLTHBvAjtdKuh7EADxz9HUYxL3YfHsxE2cdX3HD72otL65dZNgxx60
         eH08LsLLgUG63iSuHY5Oi84JGD5FRiJ1l3hQ95iJxbgWLOR9n4ZKch65aQjvdg+Y98
         WjDjGuONsbN9asqo2SxV+UYVXdeCmlHoW4vkXO98=
Date:   Thu, 17 Mar 2022 15:56:19 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-vm-fix-clang-build-error-multiple-output-files.patch removed from -mm tree
Message-Id: <20220317225620.6593AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: fix clang build error multiple output files
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-clang-build-error-multiple-output-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

memcg-add-per-memcg-total-kernel-memory-stat.patch

