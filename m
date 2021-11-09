Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C08C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8C86117A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhKICNz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:13:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995C7610D2;
        Tue,  9 Nov 2021 02:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423869;
        bh=RZu5bgShZEdEWXAN2L2cQdXXqKP+ADZ6DGFRNu+sL5I=;
        h=Date:From:To:Subject:From;
        b=GH/CUx5r4HbFHERmcG90YaR9B8+exuXRx6FWKpqxzU+UvVskbD14fV952hC0k9ctE
         hT+DFrLzV0p0+9HaQNSc/jA6sct4bia5nZ3OUQwrnVyf08LpuUTwcLRn/OgmBodPqS
         UmV+7TJhliItyqCacNboKsMGHIL8oNlKwNeRIpb8=
Date:   Mon, 08 Nov 2021 18:11:09 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 proc-test-that-proc-task-doesnt-contain-0.patch removed from -mm tree
Message-ID: <20211109021109.pFAjaZyzX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: test that /proc/*/task doesn't contain "0"
has been removed from the -mm tree.  Its filename was
     proc-test-that-proc-task-doesnt-contain-0.patch

This patch was dropped because it was folded into procfs-do-not-list-tid-0-in-proc-pid-task.patch

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: test that /proc/*/task doesn't contain "0"

add selftest to check for the errant "0" in /proc/*/task

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

procfs-do-not-list-tid-0-in-proc-pid-task.patch
lib-uninline-simple_strntoull-as-well.patch
elf-simplify-stack_alloc-macro.patch
elf-fix-overflow-in-total-mapping-size-calculation.patch

