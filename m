Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5612C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiKJAEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiKJAEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:04:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B2415A22
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10391B80959
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A89C43470;
        Thu, 10 Nov 2022 00:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668038678;
        bh=LTeb1rgu+YPr+012+cjF8k0QvgHZJVX6LSpighuPRgk=;
        h=Date:To:From:Subject:From;
        b=EXNOeaUy45ttCdVmrSKyFvTiNRr9Nx+g/a3qltdAE3dP6EgjFXf3JW8in2CbW+h6g
         5iuNnHI1QTXmv3perO/kZItecPfjidYnE+h605zpcaSAkpFotPaeVABqR4DmHRRa2M
         OsLpiOuJhM4C/ZXEQV1rNX/4fXqdaTQcFBcPwgoc=
Date:   Wed, 09 Nov 2022 16:04:37 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, adobriyan@gmail.com,
        punit.agrawal@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch added to mm-nonmm-unstable branch
Message-Id: <20221110000438.90A89C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: proc: mark proc-pid-vm as x86_64 only
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@bytedance.com>
Subject: selftests: proc: mark proc-pid-vm as x86_64 only
Date: Wed, 9 Nov 2022 22:11:04 +0000

The proc-pid-vm test does not have support for architectures other than
x86_64.  Mark it as such in the Makefile and in the process remove the
special casing in the test itself.

Link: https://lkml.kernel.org/r/20221109221104.1797802-2-punit.agrawal@bytedance.com
Signed-off-by: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/Makefile      |    2 +-
 tools/testing/selftests/proc/proc-pid-vm.c |    9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/tools/testing/selftests/proc/Makefile~selftests-proc-mark-proc-pid-vm-as-x86_64-only
+++ a/tools/testing/selftests/proc/Makefile
@@ -11,7 +11,6 @@ TEST_GEN_PROGS += fd-001-lookup
 TEST_GEN_PROGS += fd-002-posix-eq
 TEST_GEN_PROGS += fd-003-kthread
 TEST_GEN_PROGS += proc-loadavg-001
-TEST_GEN_PROGS += proc-pid-vm
 TEST_GEN_PROGS += proc-self-map-files-001
 TEST_GEN_PROGS += proc-self-map-files-002
 TEST_GEN_PROGS += proc-self-syscall
@@ -29,6 +28,7 @@ TEST_GEN_PROGS += proc-multiple-procfs
 TEST_GEN_PROGS += proc-fsconfig-hidepid
 
 TEST_GEN_PROGS_x86_64 += proc-empty-vm
+TEST_GEN_PROGS_x86_64 += proc-pid-vm
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
 
--- a/tools/testing/selftests/proc/proc-pid-vm.c~selftests-proc-mark-proc-pid-vm-as-x86_64-only
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -105,7 +105,6 @@ struct elf64_phdr {
 	uint64_t p_align;
 };
 
-#ifdef __x86_64__
 #define PAGE_SIZE 4096
 #define VADDR (1UL << 32)
 #define MAPS_OFFSET 73
@@ -209,7 +208,6 @@ static int make_exe(const uint8_t *paylo
 
 	return fd1;
 }
-#endif
 
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
@@ -225,7 +223,6 @@ static const char str_vsyscall_1[] =
 static const char str_vsyscall_2[] =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
-#ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
 {
 	_exit(g_vsyscall);
@@ -493,9 +490,3 @@ int main(void)
 
 	return 0;
 }
-#else
-int main(void)
-{
-	return 4;
-}
-#endif
_

Patches currently in -mm which might be from punit.agrawal@bytedance.com are

selftests-proc-fix-proc-empty-vm-build-error-on-non-x86_64.patch
selftests-proc-mark-proc-pid-vm-as-x86_64-only.patch

