Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457AEC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2893A61208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbhKICeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICeQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E4326120A;
        Tue,  9 Nov 2021 02:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425091;
        bh=lAwknhz5/HxBzc4K1Fv3Enzi4lbRn3jXGXdZ/jql4AM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M/6wo0yTK7uRRqmba1EfsMPYs6gkV9kh5RCN1ryd2q3fc7uoc8j6BteYH+rk8U+gR
         LDfidLtscc1fvk21K9OxTeI7DUsDAsE3pLEPtbOkU8TjUSSirYYQUOVRfGRyKi0ZBT
         vINCJx/DdzGAnt+wLw3hcILgTQzbl4pFYclcyl3M=
Date:   Mon, 08 Nov 2021 18:31:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        fweimer@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 03/87] procfs: do not list TID 0 in
 /proc/<pid>/task
Message-ID: <20211109023130.QN61VzMwU%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Florian Weimer <fweimer@redhat.com>
Subject: procfs: do not list TID 0 in /proc/<pid>/task

If a task exits concurrently, task_pid_nr_ns may return 0.

[akpm@linux-foundation.org: coding style tweaks]
[adobriyan@gmail.com: test that /proc/*/task doesn't contain "0"]
  Link: https://lkml.kernel.org/r/YV88AnVzHxPafQ9o@localhost.localdomain
Link: https://lkml.kernel.org/r/8735pn5dx7.fsf@oldenburg.str.redhat.com
Signed-off-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                           |    3 
 tools/testing/selftests/proc/.gitignore  |    1 
 tools/testing/selftests/proc/Makefile    |    2 
 tools/testing/selftests/proc/proc-tid0.c |   81 +++++++++++++++++++++
 4 files changed, 87 insertions(+)

--- a/fs/proc/base.c~procfs-do-not-list-tid-0-in-proc-pid-task
+++ a/fs/proc/base.c
@@ -3799,7 +3799,10 @@ static int proc_task_readdir(struct file
 	     task = next_tid(task), ctx->pos++) {
 		char name[10 + 1];
 		unsigned int len;
+
 		tid = task_pid_nr_ns(task, ns);
+		if (!tid)
+			continue;	/* The task has just exited. */
 		len = snprintf(name, sizeof(name), "%u", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
--- a/tools/testing/selftests/proc/.gitignore~procfs-do-not-list-tid-0-in-proc-pid-task
+++ a/tools/testing/selftests/proc/.gitignore
@@ -11,6 +11,7 @@
 /proc-self-syscall
 /proc-self-wchan
 /proc-subset-pid
+/proc-tid0
 /proc-uptime-001
 /proc-uptime-002
 /read
--- a/tools/testing/selftests/proc/Makefile~procfs-do-not-list-tid-0-in-proc-pid-task
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
