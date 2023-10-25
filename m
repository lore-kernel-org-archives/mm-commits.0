Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD40C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 20:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjJYULh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJYULg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 16:11:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4550181
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 13:11:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F12C433C7;
        Wed, 25 Oct 2023 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698264694;
        bh=WE57SUNBmmkUFGyVyjhSYK7sDNOTo/Db55weU+C1g/o=;
        h=Date:To:From:Subject:From;
        b=nfGNJPeVr+unMId9h+g8DVoP5XO7KbIq0I+SU9VbPEG4rFerTOIqK5LkBw760Rrbh
         zsf5p3r2nVPuG9cQlTc+tyxFKHz1J7MXF1f1AQGHL4z8TgN9DX9KmFeNtgVeakiL4+
         sYnfmEkRpbxFYSgIw15OK4Rt9bdawWJIgwGI1hyw=
Date:   Wed, 25 Oct 2023 13:11:32 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, hughd@google.com,
        adobriyan@gmail.com, swarupkotikalapudi@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-protectionkey-check-in-smpas-test.patch added to mm-nonmm-unstable branch
Message-Id: <20231025201134.71F12C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests:proc ProtectionKey check in smpas test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-protectionkey-check-in-smpas-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-protectionkey-check-in-smpas-test.patch

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
From: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Subject: selftests:proc ProtectionKey check in smpas test
Date: Thu, 26 Oct 2023 01:06:27 +0530

Check ProtectionKey field in /proc/*/smaps output, if system supports
page-based memory permissions.

Link: https://lkml.kernel.org/r/20231025193627.316508-1-swarupkotikalapudi@gmail.com
Signed-off-by: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   38 ++++++++++-------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-protectionkey-check-in-smpas-test
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -37,6 +37,7 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include "../kselftest.h"
 
 #ifdef __amd64__
 #define TEST_VSYSCALL
@@ -83,10 +84,7 @@ static const char proc_pid_smaps_vsyscal
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
 "THPeligible:           0\n"
-/*
- * "ProtectionKey:" field is conditional. It is possible to check it as well,
- * but I don't have such machine.
- */
+"ProtectionKey:         0\n"
 ;
 
 static const char proc_pid_smaps_vsyscall_2[] =
@@ -113,10 +111,7 @@ static const char proc_pid_smaps_vsyscal
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
 "THPeligible:           0\n"
-/*
- * "ProtectionKey:" field is conditional. It is possible to check it as well,
- * but I'm too tired.
- */
+"ProtectionKey:         0\n"
 ;
 
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
@@ -241,13 +236,26 @@ static int test_proc_pid_smaps(pid_t pid
 	} else {
 		ssize_t rv = read(fd, buf, sizeof(buf));
 		close(fd);
-		if (g_vsyscall == 0) {
-			assert(rv == 0);
-		} else {
-			size_t len = strlen(g_proc_pid_maps_vsyscall);
-			/* TODO "ProtectionKey:" */
-			assert(rv > len);
-			assert(memcmp(buf, g_proc_pid_maps_vsyscall, len) == 0);
+		assert(rv >= 0);
+		assert(rv <= sizeof(buf));
+		if (g_vsyscall != 0) {
+			int pkey = pkey_alloc(0, 0);
+
+			if (pkey < 0) {
+				size_t len = strlen(g_proc_pid_maps_vsyscall);
+
+				assert(rv > len);
+				assert(memcmp(buf, g_proc_pid_maps_vsyscall, len) == 0);
+			} else {
+				pkey_free(pkey);
+				static const char * const S[] = {
+					"ProtectionKey:         0\n"
+				};
+				int i;
+
+				for (i = 0; i < ARRAY_SIZE(S); i++)
+					assert(memmem(buf, rv, S[i], strlen(S[i])));
+			}
 		}
 		return EXIT_SUCCESS;
 	}
_

Patches currently in -mm which might be from swarupkotikalapudi@gmail.com are

selftests-proc-protectionkey-check-in-smpas-test.patch

