Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3C8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 22:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiCKWsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Mar 2022 17:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiCKWr5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2022 17:47:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE662AFA86
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 14:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA58D61FC5
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 22:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C09C340E9;
        Fri, 11 Mar 2022 22:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647038146;
        bh=Gu+Y9K5AxCH9oHvd6TqREd1+FxaKUfeqE9uZccpIGdk=;
        h=Date:To:From:Subject:From;
        b=H654D0YfVC0uP/qoL0dxfMVr1SoVgHYe0Nbbc6JUPAij3aFCTkc3xOFxQpcq4fd+q
         zVV+LkkKr8WyKiUM+X8OYuYL+H1GUNwmYCrqriBQBLDUGc5LdiBiDGo3KD+BoHgQ0P
         65frmjWJD/SbWuxy/XB6Ff62rENZvz4Md7CwczlM=
Date:   Fri, 11 Mar 2022 14:35:45 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        dave.hansen@linux.intel.com, bp@suse.de, bot@kernelci.org,
        guillaume.tucker@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-x86-fix-how-check_ccsh-is-being-invoked.patch added to -mm tree
Message-Id: <20220311223546.32C09C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests, x86: fix how check_cc.sh is being invoked
has been added to the -mm tree.  Its filename is
     selftests-x86-fix-how-check_ccsh-is-being-invoked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-x86-fix-how-check_ccsh-is-being-invoked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-x86-fix-how-check_ccsh-is-being-invoked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from guillaume.tucker@collabora.com are

selftests-x86-fix-how-check_ccsh-is-being-invoked.patch

