Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A83C04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjHLWFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjHLWFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60220171C
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE93C62098
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401A4C433C7;
        Sat, 12 Aug 2023 22:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877912;
        bh=v6P99xgxc2bnNqt0pGFerHgaTGIlIQEFZcZRVV9xOes=;
        h=Date:To:From:Subject:From;
        b=g2W8j3NO+FzCrueHDq9TWuFK9v8gzWQnQ3GYilkOdMHs8eEsSQYWVLWGoYzweWl0c
         O6swohrxEnBrxgbu1lLUikhIu0wvHGdZfuvFmW87dcovAFM+Ue9ttotQdtp9x4rV+L
         mJgJU91pI3BotC+Kl5tfEKExl/tvXZjWwv6qB8kw=
Date:   Sat, 12 Aug 2023 15:05:11 -0700
To:     mm-commits@vger.kernel.org, bjorn@kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-support-proc-empty-vm-test-on-i386.patch removed from -mm tree
Message-Id: <20230812220512.401A4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: support proc-empty-vm test on i386
has been removed from the -mm tree.  Its filename was
     proc-support-proc-empty-vm-test-on-i386.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

adfs-delete-unused-union-adfs_dirtail-definition.patch

