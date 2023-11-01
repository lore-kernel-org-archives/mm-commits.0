Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A965DC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347379AbjKATrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347364AbjKATrd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D70119
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41CEC433CB;
        Wed,  1 Nov 2023 19:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868047;
        bh=UivU7a3SMk5I4T5CDIE5cOzQLkHD0Zx/7NFcnBTTg2s=;
        h=Date:To:From:Subject:From;
        b=tg0oOk/CMA5nObH1ciRgA4pgVjALcDNTx2GrSmh7xjTKBOv5sq4bdUj1pfuH1YnXq
         gO6sbCQ2Ym2yAuxXSUgNrfUm24IvRns0giPFbB/q/LrdYg880O0eq16rNl1Q7kAZE3
         OOw5q3mOdxXQYo/s9QUSxPigaSnYAy6dYdfmx5c0=
Date:   Wed, 01 Nov 2023 12:47:27 -0700
To:     mm-commits@vger.kernel.org, swarupkotikalapudi@mail.com,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-fix-proc-empty-vm-test-with-vsyscall.patch removed from -mm tree
Message-Id: <20231101194727.C41CEC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: fix proc-empty-vm test with vsyscall
has been removed from the -mm tree.  Its filename was
     proc-fix-proc-empty-vm-test-with-vsyscall.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix proc-empty-vm test with vsyscall
Date: Fri, 27 Oct 2023 17:21:03 +0300

* fix embarassing /proc/*/smaps test bug due to a typo in variable name
  it tested only the first line of the output if vsyscall is enabled:

  	ffffffffff600000-ffffffffff601000 r-xp ...

  so test passed but tested only VMA location and permissions.

* add "KSM" entry, unnoticed because (1)

* swap "r-xp" and "--xp" vsyscall test strings,
  also unnoticed because (1)

Link: https://lkml.kernel.org/r/76f42cce-b1ab-45ec-b6b2-4c64f0dccb90@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Swarup Laxman Kotikalapudi<swarupkotikalapudi@mail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-fix-proc-empty-vm-test-with-vsyscall
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -60,7 +60,7 @@ static const char proc_pid_maps_vsyscall
 static const char proc_pid_smaps_vsyscall_0[] = "";
 
 static const char proc_pid_smaps_vsyscall_1[] =
-"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n"
+"ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n"
 "Size:                  4 kB\n"
 "KernelPageSize:        4 kB\n"
 "MMUPageSize:           4 kB\n"
@@ -73,6 +73,7 @@ static const char proc_pid_smaps_vsyscal
 "Private_Dirty:         0 kB\n"
 "Referenced:            0 kB\n"
 "Anonymous:             0 kB\n"
+"KSM:                   0 kB\n"
 "LazyFree:              0 kB\n"
 "AnonHugePages:         0 kB\n"
 "ShmemPmdMapped:        0 kB\n"
@@ -90,7 +91,7 @@ static const char proc_pid_smaps_vsyscal
 ;
 
 static const char proc_pid_smaps_vsyscall_2[] =
-"ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n"
+"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n"
 "Size:                  4 kB\n"
 "KernelPageSize:        4 kB\n"
 "MMUPageSize:           4 kB\n"
@@ -103,6 +104,7 @@ static const char proc_pid_smaps_vsyscal
 "Private_Dirty:         0 kB\n"
 "Referenced:            0 kB\n"
 "Anonymous:             0 kB\n"
+"KSM:                   0 kB\n"
 "LazyFree:              0 kB\n"
 "AnonHugePages:         0 kB\n"
 "ShmemPmdMapped:        0 kB\n"
@@ -244,10 +246,10 @@ static int test_proc_pid_smaps(pid_t pid
 		if (g_vsyscall == 0) {
 			assert(rv == 0);
 		} else {
-			size_t len = strlen(g_proc_pid_maps_vsyscall);
+			size_t len = strlen(g_proc_pid_smaps_vsyscall);
 			/* TODO "ProtectionKey:" */
 			assert(rv > len);
-			assert(memcmp(buf, g_proc_pid_maps_vsyscall, len) == 0);
+			assert(memcmp(buf, g_proc_pid_smaps_vsyscall, len) == 0);
 		}
 		return EXIT_SUCCESS;
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are


