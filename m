Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3678C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A799C61289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhEGBDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhEGBDV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD3C61041;
        Fri,  7 May 2021 01:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349342;
        bh=USvC0lUbWcL1lPukukmGw36dkDawo02kvr0ZzTI4+NU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lCWoJzwY6SD0rhpy5ynROB7qMA41IPNHoygOkSwEkVtPaeTzN3sX5kwKhgfzYBMcd
         8GlMUn50v0hge+nLnM3GUe4BUmsAQ5WuA66r81i8Px5OsvdCY8uylJGeHfELbghP0A
         9I5VxhAAxRi5W3fs6NNiG+6+dh7JVxa01nb+/g6o=
Date:   Thu, 06 May 2021 18:02:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        gladkov.alexey@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 07/91] selftests: proc: test subset=pid
Message-ID: <20210507010221.9wg8xd33q%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
