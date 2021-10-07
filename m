Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E0AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05AA061139
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbhJGSzm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 14:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233866AbhJGSzl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 14:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96134610CC;
        Thu,  7 Oct 2021 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633632827;
        bh=81mvEjkfgrXEQlv0d+TLp5kXCOVlamMQE5GmIu0W/kg=;
        h=Date:From:To:Subject:From;
        b=eI/TnT4tU8opnJpylUTqn+cMT0SVuXYpwYc9NgjTi3itZHyEfUDUiPvgbqVnZp5OU
         Kbl3POR8t2DtfK5sqSM/joWb3baWUQTsBBO54dUnq0ulg/kqf7xpctzvR+62celDLw
         dGa33mNq2oKcv9Pf6XndecYO8r5HaKSSIBZBQr5o=
Date:   Thu, 07 Oct 2021 11:53:47 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  + proc-test-that-proc-task-doesnt-contain-0.patch added
 to -mm tree
Message-ID: <20211007185347.QxssDV0uz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: test that /proc/*/task doesn't contain "0"
has been added to the -mm tree.  Its filename is
     proc-test-that-proc-task-doesnt-contain-0.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-test-that-proc-task-doesnt-contain-0.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-test-that-proc-task-doesnt-contain-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: test that /proc/*/task doesn't contain "0"

Link: https://lkml.kernel.org/r/YV88AnVzHxPafQ9o@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore  |    1 
 tools/testing/selftests/proc/Makefile    |    2 
 tools/testing/selftests/proc/proc-tid0.c |   81 +++++++++++++++++++++
 3 files changed, 84 insertions(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-test-that-proc-task-doesnt-contain-0
+++ a/tools/testing/selftests/proc/.gitignore
@@ -11,6 +11,7 @@
 /proc-self-syscall
 /proc-self-wchan
 /proc-subset-pid
+/proc-tid0
 /proc-uptime-001
 /proc-uptime-002
 /read
--- a/tools/testing/selftests/proc/Makefile~proc-test-that-proc-task-doesnt-contain-0
+++ a/tools/testing/selftests/proc/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += -D_GNU_SOURCE
+LDFLAGS += -pthread
 
 TEST_GEN_PROGS :=
 TEST_GEN_PROGS += fd-001-lookup
@@ -13,6 +14,7 @@ TEST_GEN_PROGS += proc-self-map-files-00
 TEST_GEN_PROGS += proc-self-syscall
 TEST_GEN_PROGS += proc-self-wchan
 TEST_GEN_PROGS += proc-subset-pid
+TEST_GEN_PROGS += proc-tid0
 TEST_GEN_PROGS += proc-uptime-001
 TEST_GEN_PROGS += proc-uptime-002
 TEST_GEN_PROGS += read
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-tid0.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2021 Alexey Dobriyan <adobriyan@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+// Test that /proc/*/task never contains "0".
+#include <sys/types.h>
+#include <dirent.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <pthread.h>
+
+static pid_t pid = -1;
+
+static void atexit_hook(void)
+{
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+	}
+}
+
+static void *f(void *_)
+{
+	return NULL;
+}
+
+static void sigalrm(int _)
+{
+	exit(0);
+}
+
+int main(void)
+{
+	pid = fork();
+	if (pid == 0) {
+		/* child */
+		while (1) {
+			pthread_t pth;
+			pthread_create(&pth, NULL, f, NULL);
+			pthread_join(pth, NULL);
+		}
+	} else if (pid > 0) {
+		/* parent */
+		atexit(atexit_hook);
+
+		char buf[64];
+		snprintf(buf, sizeof(buf), "/proc/%u/task", pid);
+
+		signal(SIGALRM, sigalrm);
+		alarm(1);
+
+		while (1) {
+			DIR *d = opendir(buf);
+			struct dirent *de;
+			while ((de = readdir(d))) {
+				if (strcmp(de->d_name, "0") == 0) {
+					exit(1);
+				}
+			}
+			closedir(d);
+		}
+
+		return 0;
+	} else {
+		perror("fork");
+		return 1;
+	}
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-test-that-proc-task-doesnt-contain-0.patch
lib-uninline-simple_strntoull-as-well.patch
elf-fix-overflow-in-total-mapping-size-calculation.patch
elf-simplify-stack_alloc-macro.patch

