Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DC7EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 18:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjGBSBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGBSBg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 14:01:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46E91
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 11:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ECD460C77
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 18:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8899DC433C7;
        Sun,  2 Jul 2023 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688320894;
        bh=Q2nV0pZzdexZe0GKpp75qKNb6bDX+aSdfVFmRVnoGcw=;
        h=Date:To:From:Subject:From;
        b=X8/WUhbRTfXtiRZ52xKrc2CI5HWgDkh7kxowBuEf/H3GOy4vIhNLQsvmE87QKSAm7
         T5WKRCqsOdluTnyzvHs2NCobvmXpcExfewSDtQcIsdfublXISkpWh0KCCt+HXfu+HP
         bzOockaV+TsBKTxDzQsO8GhJcT7cpvitcQp4gOQY=
Date:   Sun, 02 Jul 2023 11:01:33 -0700
To:     mm-commits@vger.kernel.org, bjorn@kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-support-proc-empty-vm-test-on-i386.patch added to mm-nonmm-unstable branch
Message-Id: <20230702180134.8899DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: support proc-empty-vm test on i386
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-support-proc-empty-vm-test-on-i386.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-support-proc-empty-vm-test-on-i386.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: support proc-empty-vm test on i386
Date: Fri, 30 Jun 2023 21:34:33 +0300

Unmap everything starting from 4GB length until it unmaps, otherwise test
has to detect which virtual memory split kernel is using.

Link: https://lkml.kernel.org/r/20230630183434.17434-1-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-support-proc-empty-vm-test-on-i386
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -37,6 +37,10 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#ifdef __amd64__
+#define TEST_VSYSCALL
+#endif
+
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
  * 1: vsyscall VMA is --xp		vsyscall=xonly
@@ -119,6 +123,7 @@ static void sigaction_SIGSEGV(int _, sig
 	_exit(EXIT_FAILURE);
 }
 
+#ifdef TEST_VSYSCALL
 static void sigaction_SIGSEGV_vsyscall(int _, siginfo_t *__, void *___)
 {
 	_exit(g_vsyscall);
@@ -170,6 +175,7 @@ static void vsyscall(void)
 		exit(1);
 	}
 }
+#endif
 
 static int test_proc_pid_maps(pid_t pid)
 {
@@ -299,7 +305,9 @@ int main(void)
 {
 	int rv = EXIT_SUCCESS;
 
+#ifdef TEST_VSYSCALL
 	vsyscall();
+#endif
 
 	switch (g_vsyscall) {
 	case 0:
@@ -346,6 +354,14 @@ int main(void)
 
 #ifdef __amd64__
 		munmap(NULL, ((size_t)1 << 47) - 4096);
+#elif defined __i386__
+		{
+			size_t len;
+
+			for (len = -4096;; len -= 4096) {
+				munmap(NULL, len);
+			}
+		}
 #else
 #error "implement 'unmap everything'"
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-support-proc-empty-vm-test-on-i386.patch
proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch

