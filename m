Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98242C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiCVVng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiCVVnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4CE5F24C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AB0261179
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4157C340F4;
        Tue, 22 Mar 2022 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985304;
        bh=yTJNuKPkDxUvMYoCRQwhtdWlDRoWERSjgS/Q5ChvmME=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=nCMDUFmY6nRZYVQInBxbm9qNWx8N3CjAANQ4+QCmCsvZnlNmx8mbbudvD+u2lnq0R
         7OLTkKRLal+u8sWS8bEyef0K45+u0bradk6HapnQ4iMzQavVI7xYn7oE3z6AVN+YYr
         pR2IRSJJd8L2hciBMRdO1SdTzrW/kDmXrwXpZP6c=
Date:   Tue, 22 Mar 2022 14:41:44 -0700
To:     shuah@kernel.org, groeck@google.com, dave.hansen@linux.intel.com,
        bp@suse.de, bot@kernelci.org, guillaume.tucker@collabora.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 063/227] selftests, x86: fix how check_cc.sh is being invoked
Message-Id: <20220322214144.C4157C340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Guillaume Tucker <guillaume.tucker@collabora.com>
Subject: selftests, x86: fix how check_cc.sh is being invoked

The $(CC) variable used in Makefiles could contain several arguments such
as "ccache gcc".  These need to be passed as a single string to
check_cc.sh, otherwise only the first argument will be used as the
compiler command.  Without quotes, the $(CC) variable is passed as
distinct arguments which causes the script to fail to build trivial
programs.

Fix this by adding quotes around $(CC) when calling check_cc.sh to pass
the whole string as a single argument to the script even if it has several
words such as "ccache gcc".

Link: https://lkml.kernel.org/r/d0d460d7be0107a69e3c52477761a6fe694c1840.1646991629.git.guillaume.tucker@collabora.com
Fixes: e9886ace222e ("selftests, x86: Rework x86 target architecture detection")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Tested-by: "kernelci.org bot" <bot@kernelci.org>
Reviewed-by: Guenter Roeck <groeck@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile  |    6 +++---
 tools/testing/selftests/x86/Makefile |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-x86-fix-how-check_ccsh-is-being-invoked
+++ a/tools/testing/selftests/vm/Makefile
@@ -51,9 +51,9 @@ TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 
 ifeq ($(MACHINE),x86_64)
-CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
-CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
-CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
+CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
+CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
+CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
 TARGETS := protection_keys
 BINARIES_32 := $(TARGETS:%=%_32)
--- a/tools/testing/selftests/x86/Makefile~selftests-x86-fix-how-check_ccsh-is-being-invoked
+++ a/tools/testing/selftests/x86/Makefile
@@ -6,9 +6,9 @@ include ../lib.mk
 .PHONY: all all_32 all_64 warn_32bit_failure clean
 
 UNAME_M := $(shell uname -m)
-CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) trivial_32bit_program.c -m32)
-CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
-CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
+CAN_BUILD_I386 := $(shell ./check_cc.sh "$(CC)" trivial_32bit_program.c -m32)
+CAN_BUILD_X86_64 := $(shell ./check_cc.sh "$(CC)" trivial_64bit_program.c)
+CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh "$(CC)" trivial_program.c -no-pie)
 
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
_
