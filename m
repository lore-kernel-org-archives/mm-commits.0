Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DBBC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6055160E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8091E60233;
        Sat,  8 May 2021 22:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514314;
        bh=gloOYUWktXtCQe1M8JKLMYNUdbasbLP4XEXnKMbn8eo=;
        h=Date:From:To:Subject:From;
        b=mdAVtnWj1q5mOGarQYOTrQ4GT67Wc9/CCbySvmDXpYUsODj7l/NdoXYbGMi9Tznxz
         FGS1lfcbcqPfnsF3afe3CREv9m720v3dTELGIC+qX+7D7KWDGMFo79TOQdISF1bV/6
         l/qdmCXTuCY+YJuAzDeBhULVoGYJDZB8zGg/+FmM=
Date:   Sat, 08 May 2021 15:51:54 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] proc-test-subset=pid.patch removed from -mm tree
Message-ID: <20210508225154.Ozd9UWpBl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: proc: test subset=pid
has been removed from the -mm tree.  Its filename was
     proc-test-subset=pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: selftests: proc: test subset=pid

Test that /proc instance mounted with

	mount -t proc -o subset=pid

contains only ".", "..", "self", "thread-self" and pid directories.

Note:
Currently "subset=pid" doesn't return "." and ".." via readdir.
This must be a bug.

Link: https://lkml.kernel.org/r/YFYZZ7WGaZlsnChS@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/Makefile          |    1 
 tools/testing/selftests/proc/proc-subset-pid.c |  121 +++++++++++++++
 2 files changed, 122 insertions(+)

--- a/tools/testing/selftests/proc/Makefile~proc-test-subset=pid
+++ a/tools/testing/selftests/proc/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += proc-self-map-files-00
 TEST_GEN_PROGS += proc-self-map-files-002
 TEST_GEN_PROGS += proc-self-syscall
 TEST_GEN_PROGS += proc-self-wchan
+TEST_GEN_PROGS += proc-subset-pid
 TEST_GEN_PROGS += proc-uptime-001
 TEST_GEN_PROGS += proc-uptime-002
 TEST_GEN_PROGS += read
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-subset-pid.c
@@ -0,0 +1,121 @@
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
+/*
+ * Test that "mount -t proc -o subset=pid" hides everything but pids,
+ * /proc/self and /proc/thread-self.
+ */
+#undef NDEBUG
+#include <assert.h>
+#include <errno.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <unistd.h>
+#include <stdio.h>
+
+static inline bool streq(const char *a, const char *b)
+{
+	return strcmp(a, b) == 0;
+}
+
+static void make_private_proc(void)
+{
+	if (unshare(CLONE_NEWNS) == -1) {
+		if (errno == ENOSYS || errno == EPERM) {
+			exit(4);
+		}
+		exit(1);
+	}
+	if (mount(NULL, "/", NULL, MS_PRIVATE|MS_REC, NULL) == -1) {
+		exit(1);
+	}
+	if (mount(NULL, "/proc", "proc", 0, "subset=pid") == -1) {
+		exit(1);
+	}
+}
+
+static bool string_is_pid(const char *s)
+{
+	while (1) {
+		switch (*s++) {
+		case '0':case '1':case '2':case '3':case '4':
+		case '5':case '6':case '7':case '8':case '9':
+			continue;
+
+		case '\0':
+			return true;
+
+		default:
+			return false;
+		}
+	}
+}
+
+int main(void)
+{
+	make_private_proc();
+
+	DIR *d = opendir("/proc");
+	assert(d);
+
+	struct dirent *de;
+
+	bool dot = false;
+	bool dot_dot = false;
+	bool self = false;
+	bool thread_self = false;
+
+	while ((de = readdir(d))) {
+		if (streq(de->d_name, ".")) {
+			assert(!dot);
+			dot = true;
+			assert(de->d_type == DT_DIR);
+		} else if (streq(de->d_name, "..")) {
+			assert(!dot_dot);
+			dot_dot = true;
+			assert(de->d_type == DT_DIR);
+		} else if (streq(de->d_name, "self")) {
+			assert(!self);
+			self = true;
+			assert(de->d_type == DT_LNK);
+		} else if (streq(de->d_name, "thread-self")) {
+			assert(!thread_self);
+			thread_self = true;
+			assert(de->d_type == DT_LNK);
+		} else {
+			if (!string_is_pid(de->d_name)) {
+				fprintf(stderr, "d_name '%s'\n", de->d_name);
+				assert(0);
+			}
+			assert(de->d_type == DT_DIR);
+		}
+	}
+
+	char c;
+	int rv = readlink("/proc/cpuinfo", &c, 1);
+	assert(rv == -1 && errno == ENOENT);
+
+	int fd = open("/proc/cpuinfo", O_RDONLY);
+	assert(fd == -1 && errno == ENOENT);
+
+	return 0;
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are


